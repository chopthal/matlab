clear all

global C
C = 32*10^(-9);

fileName =...
    'TestSet\Biacore2000_CM5_antiB2M_B2M\32nM_man.txt';
data = load(fileName);
xdata = data(:, 1);
ydata = data(:, 2);

figure(1); cla;
plot(xdata, ydata);

assoStart = 30;
assoEnd = 150;
dissoStart = 155;
dissoEnd = 420;
% eventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

k0 = [1*10^(-3) 1*10^6]; 
lb = [5*10^(-4) 10^5];
ub = [10^(-2) 10^7];

[k, resnorm] = lsqcurvefit(@(k, xdata) LsqFit ...
        (k, xdata, ydata, @AssociationRateEquationODE),...
        k0, xdata(assoStart:assoEnd), ydata(assoStart:assoEnd), lb, ub);
chi2 = sqrt(resnorm / size(xdata, 1));

fprintf('kd : %G\nka : %G\nResNorm : %G\nChi2 : %G\n', k(1), k(2), resnorm, chi2)
[T, R] = ODESolve(k, xdata, ydata, @AssociationRateEquationODE);
F = LsqFit(k, xdata, ydata, @AssociationRateEquationODE);

figure(1); hold on;
plot(T, R(:, 3), 'r'); hold off;
% plot(T, F, 'r'); hold off;


function dy = AssociationRateEquationODE(t, y, k)

global C

kd = k(1);
ka = k(2);

dy = zeros(3, 1);

dy(1) = 0;
dy(2) = -ka*C*y(2) + kd*y(3); % B
dy(3) = ka*C*y(2) - kd*y(3); % AB

end

function [X, Y] = ODESolve(k, xdata, ydata, pfuncAsso)

Rmax = 75;
assoStart = 30;
assoEnd = 150;

absTol = 1e-4;
relTol = 1e-4;
y0Asso = [0; Rmax; 0];
options = odeset('RelTol', relTol, 'AbsTol', absTol);
    
tspanAsso = assoStart:assoEnd;
[X, Y] = ode15s(@(x, y) pfuncAsso (x, y, k), tspanAsso, y0Asso, options);    

end


function F = LsqFit(k, xdata, ydata, pfuncAsso)

[T, R] = ODESolve(k, xdata, ydata, pfuncAsso);
% Drift, Bulky Index...

% assoStart = 30;
% assoEnd = 150;

F = R(:, 3);

end