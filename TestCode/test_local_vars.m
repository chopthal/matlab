% Global variables : ka, Rmax
% Local variables : kt, kd
% lb(i) = ub(i) -> constant possible!!
% Add BI and Drift
% Type
% 1) Without Kt, Drift, BI
% 2) With Kt, BI / Without Drift
% 3) With Kt, Drift, BI
% 4) With Drift, without Kt

clear all

global CMat idxVar
% CMat : Analyte solution Concentration
% CMat = [32*10^(-9); 16*10^(-9); 8*10^(-9); 4*10^(-9); 2e-9];
CMat = [2*10^(-9); 4*10^(-9); 8*10^(-9); 16*10^(-9); 32e-9];

numCurve = length(CMat);

% assoStart = 35;
% assoEnd = 150;
% dissoStart = 151;
% dissoEnd = 499;
assoStart = 10;
assoEnd = 310;
dissoStart = 311;
dissoEnd = 610;
eventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

% Load Raw-data
% fileName = {
%     'TestSet\Biacore2000_CM5_antiB2M_B2M\32nM_man.txt';
%     'TestSet\Biacore2000_CM5_antiB2M_B2M\16nM_man.txt';
%     'TestSet\Biacore2000_CM5_antiB2M_B2M\8nM_2_man.txt';
%     'TestSet\Biacore2000_CM5_antiB2M_B2M\4nM_man.txt';
%     'TestSet\Biacore2000_CM5_antiB2M_B2M\2nM_man.txt';
%     };

fileName = {
    'TestSet\BiaSimul_Kt\2n.txt';
    'TestSet\BiaSimul_Kt\4n.txt';
    'TestSet\BiaSimul_Kt\8n.txt';
    'TestSet\BiaSimul_Kt\16n.txt';
    'TestSet\BiaSimul_Kt\32n.txt';
    };

xdata = [];
ydata = [];
for i = 1:size(fileName, 1)    
    data = load(fileName{i, 1});
    xdata = [xdata; data(:, 1)];
    ydata = [ydata; data(:, 2)];
end
figure(1); cla;
plot(xdata, ydata);

% Number of inital values (k)
type = 'AssoMass'; % Asso / AssoMass
varType = {'Local'; 'Global'; 'Global'; 'Global'; 'Local'; 'Constant'};
numLocal = length(find(ismember(varType, 'Local')));
numGlobal = length(find(ismember(varType, 'Global')));
numConstant = length(find(ismember(varType, 'Constant')));
numK = numLocal * numCurve + numGlobal + numConstant * numCurve;
idxVar = cell(numCurve, 1);
idxVar{1} = [1:numLocal+numGlobal+numConstant];
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
kt = [1*10^8  1*10^8  1*10^8 1*10^8 2*10^8];
kd = [10^(-3) 10^(-3) 10^(-3) 10^(-3) 10^(-3)]*0.7; 
ka = [10^6 10^6 10^6 10^6 10^6]*5;
% Rmax = [73.31 73.31 73.31 73.31 73.31];
Rmax = [240 240 240 240 240]*1.5;
BI = [0 2 4 8 10];
drift = [0.1 0.15 0.2 0.25 0.3]*0;
valVar = cell(length(varType), 1); valVar{1} = kt; valVar{2} = kd; valVar{3} = ka; valVar{4} = Rmax; valVar{5} = BI; valVar{6} = drift;
k0 = zeros(1, numK); % kt1, kd1, ka1, Rmax1, kt2, kd2, ka2, Rmax2, ...
lb = zeros(1, numK); ub = zeros(1, numK);

% Initial Values (kt, kd, ka, Rmax, kt2, kd2, kt3, kd3)
for i = 1:length(varType)
    if strcmp(varType{i}, 'Global')
        k0(i) = valVar{i}(1);
        lb(i) = valVar{i}(1)/10;
        ub(i) = valVar{i}(1)*10;
    elseif strcmp(varType{i}, 'Local')
        k0(idxEachVar{i}) = valVar{i};
        lb(idxEachVar{i}) = valVar{i}/10;
        ub(idxEachVar{i}) = valVar{i}*10;
    elseif strcmp(varType{i}, 'Constant')
        k0(idxEachVar{i}) = valVar{i};
        lb(idxEachVar{i}) = valVar{i};
        ub(idxEachVar{i}) = valVar{i};
    end
end

% Range of BI and drift (-inf ~ inf)
colIdxBI = 5;
colIdxDrift = 6;
if strcmp(varType{colIdxBI}, 'Global') || strcmp(varType{colIdxBI}, 'Local')
    lb(idxEachVar{colIdxBI}) = -inf; ub(idxEachVar{colIdxBI}) = inf;
end
if strcmp(varType{colIdxDrift}, 'Global') || strcmp(varType{colIdxDrift}, 'Local')
    lb(idxEachVar{colIdxDrift}) = -inf; ub(idxEachVar{colIdxDrift}) = inf;
end


options = optimoptions('lsqcurvefit',...
    'Algorithm', 'levenberg-marquardt',...
    'FiniteDifferenceType', 'central',...
    'MaxIterations', 200, ...
    'FunctionTolerance', 1e-12, ...
    'MaxFunctionEvaluations', 1e10, ...
    'StepTolerance', 1e-8);
%     'FiniteDifferenceStepSize', eps^(1/3), ...
%     'Display', 'iter-detailed',...
%     'PlotFcn', 'optimplotstepsize',...
   

assoStartPoint = find(xdata==assoStart);
assoEndPoint = find(xdata==assoEnd);
dissoStartPoint = find(xdata==dissoStart);
dissoEndPoint = find(xdata==dissoEnd);

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
           eventTime, type),...
        k0, xdataEffectiveRange, ydataEffectiveRange, lb, ub, options);
chi2 = sqrt(resnorm / size(xdata, 1));

% fprintf('kt1 : %G\nkt2 : %G\nkt3 : %G\nkd1 : %G\nkd2 : %G\nkd3 : %G\nka : %G\nRmax : %G\nResNorm : %G\nChi2 : %G\n',...
%     k(1), k(5), k(7), k(2), k(6), k(8), k(3), k(4), resnorm, chi2)
disp(num2str(k))
disp(chi2)
[T, R] = ODESolve(k, xdata,...
    @AssociationRateEquationODE,...
    @DissociationRateEquationODE,...
    eventTime, type);

figure(1); hold on;
plot(T, R(:, 3), 'r'); hold off;

% With mass transfer (ka)
function dy = AssociationRateEquationODE(t, y, k, type)

    global C
    
    kt = k(1);
    kd = k(2);
    ka = k(3);

    dy = zeros(3, 1);
    
    if strcmp(type, 'Asso')
        dy(1) = 0;
        dy(2) = -ka*C*y(2) + kd*y(3); % B
        dy(3) = ka *C*y(2) - kd*y(3); % AB
    elseif strcmp(type, 'AssoMass')
        dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
        dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
        dy(3) = ka *y(1)*y(2) - kd*y(3); % AB
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


function [X, Y] = ODESolve(k, xdata, pfuncAsso, pfuncDisso, eventTime, type)

    global CMat C idxVar

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
    % y0Disso = [0; Rmax; Rmax];
    options = odeset('RelTol', relTol, 'AbsTol', absTol);

    for i = 1 : size(assoStart, 1)
        C = CMat(i);
              
        tspanAsso = xdata(assoStart(i, 1) : assoEnd(i, 1));
        tspanDisso = xdata(dissoStart(i, 1) : dissoEnd(i, 1));
        
        % Define 'k' here. Separte to proper position.
        % For example, k_from_lsqfit = [kt1, ka, kd1, Rmax, kt2, kd2, kt3, kd3];
        % k_here = [k(5), k(6), k(3), k(4)];
        % k_idx = [5, 6, 3, 4];
        % k_here = k(k_idx)
        kInput = k(idxVar{i});

        [XAsso, YAsso] = ode15s(@(x, y) pfuncAsso (x, y, kInput, type), tspanAsso, y0Asso, options);
        y0Disso = [0; Rmax; YAsso(end, 3)];  
        [XDisso, YDisso] = ode15s(@(x, y) pfuncDisso (x, y, kInput), tspanDisso, y0Disso, options);

        X = [X; XAsso; XDisso];
%         Y = [Y; YAsso; YDisso];
%         disp(kInput(6))
        YAsso = YAsso + kInput(6) * (XAsso-XAsso(1)) + kInput(5);
        YDisso = YDisso + kInput(6) * (XDisso-XAsso(1)); % Bulky Index
        Y = [Y; 
            YAsso;
            YDisso];
    end

end


function F = LsqFit(k, xdata, pfuncAsso, pfuncDisso, eventTime, type)

    [T, R] = ODESolve(k, xdata, pfuncAsso, pfuncDisso, eventTime, type);
    % Drift, Bulky Index...

    F = R(:, 3);

end