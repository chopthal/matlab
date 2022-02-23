function [k, kName, chi2, T, R] = OneToOneSingleCycleKinetics(concentration, associationStart, associationEnd, dissociationStart, dissociationEnd, xData, yData, isMassTransfer, fittingVariables)

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

algorithm = 'levenberg-marquardt';
if sum(strcmp(fittingVariables.Type, 'Local')) == 0
    scaleProblem = 'none';        
else    
    scaleProblem = 'jacobian';
%     scaleProblem = 'none';        
end

disp(scaleProblem)

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

% options = optimoptions('lsqcurvefit',...
%     'Algorithm', 'levenberg-marquardt',...
%     'FiniteDifferenceType', 'central',...
%     'MaxIterations', 100, ...
%     'FunctionTolerance', 1e-8, ...
%     'MaxFunctionEvaluations', 2e3, ...
%     'StepTolerance', 1e-7, ...
%     'Display', 'iter-detailed');

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


xDataEffectiveRange = [];
yDataEffectiveRange = [];
for i = 1:length(associationStart)
    associationTimes{i} = [associationStart(i), associationEnd(i)];
    dissociationTimes{i} = [dissociationStart(i), dissociationEnd(i)];

    [tmpIdxAsso, ~] = find(associationTimes{i} == xData);
    [tmpIdxDisso, ~] = find(dissociationTimes{i} == xData);
    
    xDataEffectiveRange = [xDataEffectiveRange; xData(tmpIdxAsso(1):tmpIdxAsso(2))];
    xDataEffectiveRange = [xDataEffectiveRange; xData(tmpIdxDisso(1):tmpIdxDisso(2))];
    yDataEffectiveRange = [yDataEffectiveRange; yData(tmpIdxAsso(1):tmpIdxAsso(2))];
    yDataEffectiveRange = [yDataEffectiveRange; yData(tmpIdxDisso(1):tmpIdxDisso(2))];
end


% ResNorm = (sum((fun(x,xdata)-ydata).^2))
% lsqfitcurve assigns k(defined as k0, lb, ub) value to k position of ODESolve. 
[k, resnorm] = lsqcurvefit(@(k, xData) LsqFit ...
        (k, xData,...
         @AssociationRateEquationODE,...
         @DissociationRateEquationODE,...
           associationTimes, dissociationTimes, isMassTransfer, concentration, idxVar),...
        k0, xDataEffectiveRange, yDataEffectiveRange, lb, ub, options);
chi2 = sqrt(resnorm / size(xData, 1));

[T, R] = ODESolve(k, xData,...
    @AssociationRateEquationODE,...
    @DissociationRateEquationODE,...
    associationTimes, dissociationTimes, isMassTransfer, concentration, idxVar);

end


function dy = AssociationRateEquationODE(t, y, k, isMassTransfer, C)
    
    kd = k(1);
    ka = k(2);

    dy = zeros(3, 1);
        
    dy(1) = 0; % A = 0
%     dy(2) = -ka * y(1) * y(2) + kd * y(3); % B
%     dy(3) =  ka * y(1) * y(2) - kd * y(3); % AB
    dy(2) = -ka * C * y(2) + kd * y(3); % B
    dy(3) =  ka * C * y(2) - kd * y(3); % AB
    
end


function dy = DissociationRateEquationODE(t, y, k)

    kd = k(1);
    ka = k(2);

    dy = zeros(3,1);

    dy(1) = 0; % A = 0
%     dy(2) = -ka * y(1) * y(2) + kd * y(3); % B
%     dy(3) =  ka * y(1) * y(2) - kd * y(3); % AB
    dy(2) = -ka * 0 * y(2) + kd * y(3); % B
    dy(3) =  ka * 0 * y(2) - kd * y(3); % AB

end


function [X, Y] = ODESolve(k, xData, pfuncAsso, pfuncDisso, associationTimes, dissociationTimes, isMassTransfer, concentration, idxVar)

    X = [];
    Y = [];
   

    absTol = 1e-6;
    relTol = 1e-6;    
    options = odeset('RelTol', relTol, 'AbsTol', absTol);
    YDisso = zeros(1, 3);

    for i = 1 : size(associationTimes, 2)
    
        [tmpIdxAsso, ~] = find(associationTimes{i} == xData);
        [tmpIdxDisso, ~] = find(dissociationTimes{i} == xData);
        xShift = associationTimes{i}(1) - tmpIdxAsso(1);
        tspanAsso = tmpIdxAsso(1) : tmpIdxAsso(2);
        tspanDisso = tmpIdxDisso(1) : tmpIdxDisso(2);

        C = concentration(i);              
%         tspanAsso = associationTimes{i}(1):associationTimes{i}(2);
%         tspanDisso = dissociationTimes{i}(1):dissociationTimes{i}(2);

        Rmax = k(3) - YDisso(end);  

        y0Asso = [0; Rmax; YDisso(end, 3)];
        kInput = k(idxVar{i});
        [XAsso, YAsso] = ode15s(@(x, y) pfuncAsso (x, y, kInput, isMassTransfer, C), tspanAsso, y0Asso, options);
%         y0Disso = [0; Rmax; YAsso(end, 3)];  
        y0Disso = [0; 0; YAsso(end, 3)];
        [XDisso, YDisso] = ode15s(@(x, y) pfuncDisso (x, y, kInput), tspanDisso, y0Disso, options);
        X = [X; XAsso; XDisso];        
        YAsso = YAsso + kInput(4);
        % YAsso = YAsso + kInput(3) * (XAsso-XAsso(1)) + kInput(4); % Bulky index (kInput(5)) and Drift (kInput(6))
%         YDisso = YDisso + kInput(4) * (XDisso-XAsso(1)); % Drift (kInput(6))
        Y = [Y; YAsso; YDisso];
    end

end


function F = LsqFit(k, xData, pfuncAsso, pfuncDisso, associationTimes, dissociationTimes, isMassTransfer, concentration, idxVar)

    [T, R] = ODESolve(k, xData, pfuncAsso, pfuncDisso, associationTimes, dissociationTimes, isMassTransfer, concentration, idxVar);
    F = R(:, 3);

end