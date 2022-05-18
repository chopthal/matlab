function [k, kName, chi2, T, R] = OneToOneKineticsFitting(concentration, eventTime, xdata, ydata, isMassTransfer, fittingVariables)

% concentration : concentration matrix. ex) [2*10^(-9); 4*10^(-9); 8*10^(-9); 16*10^(-9); 32e-9]
% eventTime : [Association Start time, Association End time, Dissociation
% Start time, Dissociation End time]
% isMassTransfer : True or False
% fittingVariables : Struct (Required fields : Name, Type, InitialValue, UpperBound,
% LowerBound)
% No drift : Set 'Constant', 0
% No BI : Set 'Constant', 0

varType = fittingVariables.Type;
if isempty(isMassTransfer); isMassTransfer = false; end

numCurve = length(concentration);

% Number of inital values (k)
numLocal = length(find(ismember(varType, 'Local')));
numGlobal = length(find(ismember(varType, 'Global')));
numConstant = length(find(ismember(varType, 'Constant')));
numK = numLocal * numCurve + numGlobal + numConstant * numCurve;
idxVar = cell(numCurve, 1);
idxVar{1} = 1:numLocal+numGlobal+numConstant;
lastIdx = idxVar{1}(end);

% kt, kd, ka, Rmax, BI, drift
for i = 2 : numCurve    
    for j = 1:length(varType)
        if strcmp(varType{j}, 'Global')
            idxVar{i}(j) = idxVar{i-1}(j);
        elseif strcmp(varType{j}, 'Local') || strcmp(varType{j}, 'Constant')
            lastIdx = lastIdx + 1;
            idxVar{i}(j) = lastIdx;
        end
    end
end

idxEachVar = mat2cell(cell2mat(idxVar)', ones(1, length(varType)), numCurve);

k0 = zeros(1, numK); % kt1, kd1, ka1, Rmax1, kt2, kd2, ka2, Rmax2, ...
lb = zeros(1, numK); ub = zeros(1, numK); kName = cell(1, numK);

% Initial Values (kt, kd, ka, Rmax, kt2, kd2, kt3, kd3)
for i = 1:length(varType)
    if strcmp(varType{i}, 'Global')
        k0(i) = fittingVariables.InitialValue{i}(1);
        lb(i) = fittingVariables.LowerBound{i}(1);
        ub(i) = fittingVariables.UpperBound{i}(1);   
        kName{i} = fittingVariables.Name{i};
    elseif strcmp(varType{i}, 'Local')
        k0(idxEachVar{i}) = fittingVariables.InitialValue{i};
        lb(idxEachVar{i}) = fittingVariables.LowerBound{i};
        ub(idxEachVar{i}) = fittingVariables.UpperBound{i};
        for ii = idxEachVar{i}; kName{ii} = fittingVariables.Name{i}; end
    elseif strcmp(varType{i}, 'Constant')
        k0(idxEachVar{i}) = fittingVariables.InitialValue{i};
        lb(idxEachVar{i}) = fittingVariables.InitialValue{i};
        ub(idxEachVar{i}) = fittingVariables.InitialValue{i};
        for ii = idxEachVar{i}; kName{ii} = fittingVariables.Name{i}; end
    end
end

options = optimoptions('lsqcurvefit',...
    'Algorithm', 'levenberg-marquardt',...
    'FiniteDifferenceType', 'central',...
    'MaxIterations', 100, ...
    'FunctionTolerance', 1e-8, ...
    'MaxFunctionEvaluations', 2e3, ...
    'StepTolerance', 1e-7);
%     'FiniteDifferenceStepSize', eps^(1/3), ...
%     'Display', 'iter-detailed',...
%     'PlotFcn', 'optimplotstepsize',...

assoStartPoint = find(xdata==eventTime(1));
assoEndPoint = find(xdata==eventTime(2));
dissoStartPoint = find(xdata==eventTime(3));
dissoEndPoint = find(xdata==eventTime(4));

xdataEffectiveRange = [];
ydataEffectiveRange = [];
for i = 1:size(assoStartPoint, 1)    
    xdataEffectiveRange = [xdataEffectiveRange; xdata(assoStartPoint(i, 1):assoEndPoint(i, 1))];
    xdataEffectiveRange = [xdataEffectiveRange; xdata(dissoStartPoint(i, 1):dissoEndPoint(i, 1))];
    ydataEffectiveRange = [ydataEffectiveRange; ydata(assoStartPoint(i, 1):assoEndPoint(i, 1))];
    ydataEffectiveRange = [ydataEffectiveRange; ydata(dissoStartPoint(i, 1):dissoEndPoint(i, 1))];
end

% ResNorm = (sum((fun(x,xdata)-ydata).^2))
% lsqfitcurve assigns k(defined as k0, lb, ub) value to k position of ODESolve. 
[k, resnorm] = lsqcurvefit(@(k, xdata) LsqFit ...
        (k, xdata,...
         @AssociationRateEquationODE,...
         @DissociationRateEquationODE,...
           eventTime, isMassTransfer, concentration, idxVar),...
        k0, xdataEffectiveRange, ydataEffectiveRange, lb, ub, options);
chi2 = sqrt(resnorm / size(xdata, 1));

[T, R] = ODESolve(k, xdata,...
    @AssociationRateEquationODE,...
    @DissociationRateEquationODE,...
    eventTime, isMassTransfer, concentration, idxVar);

end


function dy = AssociationRateEquationODE(t, y, k, isMassTransfer, C)

    kt = k(1);
    kd = k(2);
    ka = k(3);

    dy = zeros(3, 1);
    
    if isMassTransfer
        dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
        dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
        dy(3) = ka *y(1)*y(2) - kd*y(3); % AB        
    else
        dy(1) = 0;
        dy(2) = -ka*C*y(2) + kd*y(3); % B
        dy(3) = ka *C*y(2) - kd*y(3); % AB
    end
    

end


function dy = DissociationRateEquationODE(t, y, k)

    kd = k(2);
    ka = k(3);

    dy = zeros(3,1);

    dy(1) = 0; % A = 0
    dy(2) = -ka*0*y(2) + kd*y(3); % B
    dy(3) =  ka*0*y(2) - kd*y(3); % AB

end


function [X, Y] = ODESolve(k, xdata, pfuncAsso, pfuncDisso, eventTime, isMassTransfer, concentration, idxVar)

    X = [];
    Y = [];

    Rmax = k(4);
    assoStart = find(xdata == eventTime(1));
    assoEnd = find(xdata == eventTime(2));
    dissoStart = find(xdata == eventTime(3));
    dissoEnd = find(xdata == eventTime(4));

    absTol = 1e-6;
    relTol = 1e-6;
    y0Asso = [0; Rmax; 0];
    options = odeset('RelTol', relTol, 'AbsTol', absTol);

    for i = 1 : size(assoStart, 1)
        C = concentration(i);              
        tspanAsso = xdata(assoStart(i, 1) : assoEnd(i, 1));
        tspanDisso = xdata(dissoStart(i, 1) : dissoEnd(i, 1));
        
        % Define 'k' here. Separte to proper position.
        % For example, k_from_lsqfit = [kt1, ka, kd1, Rmax, kt2, kd2, kt3, kd3];
        % k_here = [k(5), k(6), k(3), k(4)];
        % k_idx = [5, 6, 3, 4];
        % k_here = k(k_idx)
        kInput = k(idxVar{i});
        [XAsso, YAsso] = ode15s(@(x, y) pfuncAsso (x, y, kInput, isMassTransfer, C), tspanAsso, y0Asso, options);
        y0Disso = [0; Rmax; YAsso(end, 3)];  
        [XDisso, YDisso] = ode15s(@(x, y) pfuncDisso (x, y, kInput), tspanDisso, y0Disso, options);
        X = [X; XAsso; XDisso];        
        YAsso = YAsso + kInput(6) * (XAsso-XAsso(1)) + kInput(5); % Bulky index (kInput(5)) and Drift (kInput(6))
        YDisso = YDisso + kInput(6) * (XDisso-XAsso(1)); % Drift (kInput(6))
        Y = [Y; YAsso; YDisso];
    end

end


function F = LsqFit(k, xdata, pfuncAsso, pfuncDisso, eventTime, isMassTransfer, concentration, idxVar)

    [T, R] = ODESolve(k, xdata, pfuncAsso, pfuncDisso, eventTime, isMassTransfer, concentration, idxVar);
    F = R(:, 3);

end