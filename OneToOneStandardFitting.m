function [k, kName, chi2, T, R] = OneToOneStandardFitting(concentration, eventTime, xdata, ydata, fittingVariables, fittingModel)

% concentration : concentration matrix. ex) [2*10^(-9); 4*10^(-9); 8*10^(-9); 16*10^(-9); 32e-9]
% eventTime : [Association Start time, Association End time, Dissociation
% Start time, Dissociation End time]
% isMassTransfer : True or False
% fittingVariables : Struct (Required fields : Name, Type, InitialValue, UpperBound,
% LowerBound)
% No drift : Set 'Constant', 0
% No BI : Set 'Constant', 0

varType = fittingVariables.Type;
numCurve = length(concentration);

% Number of inital values (k)
numLocal = length(find(ismember(varType, 'Local')));
numGlobal = length(find(ismember(varType, 'Global')));
numConstant = length(find(ismember(varType, 'Constant')));
numK = numLocal * numCurve + numGlobal + numConstant * numCurve;
idxVar = cell(numCurve, 1);
idxVar{1} = 1:numLocal+numGlobal+numConstant;
lastIdx = idxVar{1}(end);

algorithm = 'levenberg-marquardt';
if sum(strcmp(fittingVariables.Type, 'Local')) == 0
    scaleProblem = 'none';        
else    
    scaleProblem = 'jacobian';
%     scaleProblem = 'none';        
end

options = optimoptions('lsqcurvefit',...
    'Algorithm', algorithm,...
    'FiniteDifferenceType', 'forward',...
    'MaxFunctionEvaluations', 40000, ...
    'MaxIterations', 1000, ...
    'FunctionTolerance', 1e-6, ...    
    'StepTolerance', 1e-10, ...
    'ScaleProblem', scaleProblem, ...
    'FiniteDifferenceStepSize', eps^(1/3), ... 
    'InitDamping', 0.01, ...
    'SubproblemAlgorithm', 'factorization', ... % cg
    'Display', 'iter-detailed');

% ka(on), kd(off), Rmax, BI
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

k0 = zeros(1, numK); % ka1, kd1, Rmax1, ka2, kd2, Rmax2, ...
lb = zeros(1, numK); ub = zeros(1, numK); kName = cell(1, numK);

% Initial Values (ka, ka, Rmax, kt2, kd2, kt3, kd3)
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

assoStartPoint = find(xdata==eventTime(1));
assoEndPoint = find(xdata==eventTime(2));
dissoStartPoint = find(xdata==eventTime(3));
dissoEndPoint = find(xdata==eventTime(4));

xdataEffectiveRange = [];
ydataEffectiveRange = [];
for i = 1:size(assoStartPoint, 1)    
    try
    xdataEffectiveRange = [xdataEffectiveRange; xdata(assoStartPoint(i, 1):assoEndPoint(i, 1))];
    xdataEffectiveRange = [xdataEffectiveRange; xdata(dissoStartPoint(i, 1):dissoEndPoint(i, 1))];
    ydataEffectiveRange = [ydataEffectiveRange; ydata(assoStartPoint(i, 1):assoEndPoint(i, 1))];
    ydataEffectiveRange = [ydataEffectiveRange; ydata(dissoStartPoint(i, 1):dissoEndPoint(i, 1))];
    catch
        disp('err')
    end
end

% Pre-fit for find initial values

% ResNorm = (sum((fun(x,xdata)-ydata).^2))
% lsqfitcurve assigns k(defined as k0, lb, ub) value to k position of ODESolve. 

% Input k0, lb, ub
% Normalize each variable to 0~0.1;

[k, resnorm] = lsqcurvefit(@(k, xdata) LsqFit ...
        (k, xdata,...
         @RateEquationODE,...
         fittingModel,...
           eventTime, concentration, idxVar),...
        k0, xdataEffectiveRange, ydataEffectiveRange, lb, ub, options);
chi2 = resnorm / size(xdataEffectiveRange, 1);

[T, R] = ODESolve(k, xdata,...
    @RateEquationODE, ...
    fittingModel, eventTime, concentration, idxVar);

end

function dy = RateEquationODE(t, y, k, fittingModel, C)

dy = zeros(3,1);
ka = k(1);
kd = k(2);

if strcmp(fittingModel, 'OneToOneMassTransfer')
    kt = k(3);    
    dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) = ka *y(1)*y(2) - kd*y(3); % AB        
else
    dy(1) = 0; % A = 0
%     dy(1) = C; % A = 0 (BiaEvaluation)
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) =  ka*y(1)*y(2) - kd*y(3); % AB
end


end

function [X, Y] = ODESolve(k, xdata, rateEquation, fittingModel, eventTime, concentration, idxVar)

    X = []; Y = [];
    assoStart = find(xdata == eventTime(1));
    assoEnd = find(xdata == eventTime(2));
    dissoStart = find(xdata == eventTime(3));
    dissoEnd = find(xdata == eventTime(4));

    absTol = 0.1;
    relTol = 0.1;
    options = odeset('RelTol', relTol, 'AbsTol', absTol, 'InitialStep', 1);

    for i = 1 : size(assoStart, 1)

        
        C = concentration(i);              
        
        tspanAsso = xdata(assoStart(i, 1) : assoEnd(i, 1));
        tspanDisso = xdata(dissoStart(i, 1) : dissoEnd(i, 1));
        
        % Define 'k' here. Separte to proper position.
        % For example, k_from_lsqfit = [kt1, ka, kd1, Rmax, kt2, kd2, kt3, kd3];
        % k_here = [k(5), k(6), k(3), k(4)];
        % k_idx = [5, 6, 3, 4];
        % k_here = k(k_idx)
        kInput = k(idxVar{i}); % kon, koff, Rmax,         
        if strcmp(fittingModel, 'OneToOneStandard')
            kInputODE = kInput(1:2);
            Rmax = kInput(3);
            bulkyIdx = kInput(4);
            y0Asso = [C; Rmax; 0]; %Check    
        elseif strcmp(fittingModel, 'OneToOneMassTransfer')
            kInputODE = kInput(1:3);
            Rmax = kInput(4);
            bulkyIdx = kInput(5);
            y0Asso = [0; Rmax; 0]; % BiaEvaluation
        end        
%         options = odeset('RelTol', Rmax*0.01, 'AbsTol', Rmax*0.1, 'InitialStep', 1);

%         y0Asso = [C; Rmax; 0]; %Check        
        [XAsso, YAsso] = ode15s(@(x, y) rateEquation (x, y, kInputODE, fittingModel, C), tspanAsso, y0Asso, options);
        y0Disso = [0; 0; YAsso(end, 3)]; %Check
         
        [XDisso, YDisso] = ode15s(@(x, y) rateEquation (x, y, kInputODE, fittingModel, C), tspanDisso, y0Disso, options);
        X = [X; XAsso; XDisso];        

        YAsso = YAsso + bulkyIdx; % Bulky index (kInput(4)) and W/O Drift (kInput(5))             
        Y = [Y; YAsso; YDisso];

    end        


end


function F = LsqFit(k, xdata, rateEquation, fittingModel, eventTime, concentration, idxVar)

    [T, R] = ODESolve(k, xdata, rateEquation, fittingModel, eventTime, concentration, idxVar);
    F = R(:, 3);

end