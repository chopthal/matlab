clear all

global CMat
% CMat : Analyte solution Concentration
CMat = [32*10^(-9); 16*10^(-9); 4e-9];

assoStart = 30;
assoEnd = 150;
dissoStart = 151;
dissoEnd = 499;
eventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

% Load Raw-data
fileName = {
    'C:\Users\tjckd\OneDrive\바탕 화면\icluebio\Kinetics\MultiKinetics\TestSet\Biacore2000_CM5_antiB2M_B2M\32nM_man.txt';
    'C:\Users\tjckd\OneDrive\바탕 화면\icluebio\Kinetics\MultiKinetics\TestSet\Biacore2000_CM5_antiB2M_B2M\16nM_man.txt';
    'C:\Users\tjckd\OneDrive\바탕 화면\icluebio\Kinetics\MultiKinetics\TestSet\Biacore2000_CM5_antiB2M_B2M\4nM_man.txt'
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

% Initial Values (kt, kd, ka, Rmax)
k0 = [3*10^8 10^(-3) 10^6 73.31]; 
lb = k0/10;
ub = k0*10;

options = optimoptions('lsqcurvefit',...
    'Algorithm', 'levenberg-marquardt',...
    'FiniteDifferenceType', 'central',...
    'MaxIterations', 500, ...
    'PlotFcn', 'optimplotfunccount',...
    'Display', 'iter',...
    'FunctionTolerance', 1e-20, ...
    'OptimalityTolerance', 1e-20);

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
[k, resnorm] = lsqcurvefit(@(k, xdata) LsqFit ...
        (k, xdata, ydata, @AssociationRateEquationODE, @DissociationRateEquationODE, eventTime),...
        k0, xdataEffectiveRange, ydataEffectiveRange, lb, ub);
chi2 = sqrt(resnorm / size(xdata, 1));

fprintf('kt : %G\nkd : %G\nka : %G\nRmax : %G\nResNorm : %G\nChi2 : %G\n', k(1), k(2), k(3), k(4), resnorm, chi2)
[T, R] = ODESolve(k, xdata, ydata, @AssociationRateEquationODE, @DissociationRateEquationODE, eventTime);

figure(1); hold on;
plot(T, R(:, 3), 'r'); hold off;

function dy = OneToOneRateEquationODE(t, y, k, type)
% Type
% 1) Association with mass transfer ('AssoMass')
% 2) Association without mass transfer ('Asso')
% 3) Dissociation ('Disso')

global C

if strcmp(type, 'Asso')    
    kt = k(1);
    kd = k(2);
    ka = k(3);

    dy = zeros(3, 1);
    dy(1) = C; % A
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) = ka *y(1)*y(2) - kd*y(3); % AB    
elseif strcmp(type, 'AssoMass')
    kt = k(1);
    kd = k(2);
    ka = k(3);

    dy = zeros(3, 1);
    dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) = ka *y(1)*y(2) - kd*y(3); % AB    
elseif strcmp(type, 'Disso')    
    kd = k(2);
    ka = k(3);

    dy = zeros(3,1);
    dy(1) = 0; % A = 0
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) =  ka*y(1)*y(2) - kd*y(3); % AB
end

end

% With mass transfer (ka)
function dy = AssociationRateEquationODE(t, y, k)

global C

kt = k(1);
kd = k(2);
ka = k(3);

dy = zeros(3, 1);

dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
dy(3) = ka *y(1)*y(2) - kd*y(3); % AB

end

% TODO : Solve 2 separated diff eqs for local variable
function dy = AssociationRateEquationODE2(t, y, k)

global C

kt = k(1);
kd = k(2);
ka = k(3);

dy = zeros(3, 1);

dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
dy(3) = ka *y(1)*y(2) - kd*y(3); % AB

end


function dy = DissociationRateEquationODE(t, y, k)

kd = k(2);
ka = k(3);

dy = zeros(3,1);

dy(1) = 0; % A = 0
dy(2) = -ka*0*y(2) + kd*y(3); % B
dy(3) =  ka*0*y(2) - kd*y(3); % AB

end


function [X, Y] = ODESolve(k, xdata, ydata, pfuncAsso, pfuncDisso, eventTime)

global CMat C

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
    
%     y0Disso = [0; ydata(dissoStart(i, 1)); ydata(dissoStart(i, 1))];          
    tspanAsso = xdata(assoStart(i, 1) : assoEnd(i, 1));
    tspanDisso = xdata(dissoStart(i, 1) : dissoEnd(i, 1));

    [XAsso, YAsso] = ode15s(@(x, y) pfuncAsso (x, y, k), tspanAsso, y0Asso, options);
    y0Disso = [0; Rmax; YAsso(end, 3)];  
    [XDisso, YDisso] = ode15s(@(x, y) pfuncDisso (x, y, k), tspanDisso, y0Disso, options);

    X = [X; XAsso; XDisso];
    Y = [Y; YAsso; YDisso];
end

end


function F = LsqFit(k, xdata, ydata, pfuncAsso, pfuncDisso, eventTime)

[T, R] = ODESolve(k, xdata, ydata, pfuncAsso, pfuncDisso, eventTime);
% Drift, Bulky Index...

F = R(:, 3);

end