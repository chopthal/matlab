clear all

global C
% C : Analyte solution Concentration
C = 32*10^(-9);

assoStart = 30;
assoEnd = 150;
dissoStart = 151;
dissoEnd = 499;
eventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

% Load Raw-data
fileName =...
    'C:\Users\tjckd\OneDrive\바탕 화면\icluebio\Kinetics\MultiKinetics\TestSet\Biacore2000_CM5_antiB2M_B2M\32nM_man.txt';
data = load(fileName);
xdata = data(:, 1);
ydata = data(:, 2);

% Initial Values (kt, kd, ka, Rmax)
k0 = [2.01*10^8 2.95*10^(-3) 2.04*10^6 70]; 
lb = [10^8 10^(-4) 10^5 0];
ub = [10^10 10^(-2) 10^7 1000];

% ResNorm = (sum((fun(x,xdata)-ydata).^2))
[k, resnorm] = lsqcurvefit(@(k, xdata) LsqFit ...
        (k, xdata, ydata, @AssociationRateEquationODE, @DissociationRateEquationODE, eventTime),...
        k0, xdata, ydata, lb, ub);
chi2 = sqrt(resnorm / size(xdata, 1));

fprintf('kt : %G\nkd : %G\nka : %G\nRmax : %G\nResNorm : %G\nChi2 : %G\n', k(1), k(2), k(3), k(4), resnorm, chi2)
[T, R] = ODESolve(k, xdata, ydata, @AssociationRateEquationODE, @DissociationRateEquationODE, eventTime);

figure(1)
plot(xdata, ydata); hold on;
plot(T, R(:, 3), 'r'); hold off;


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


function dy = DissociationRateEquationODE(t, y, k)

kd = k(2);
ka = k(3);

dy = zeros(3,1);

dy(1) = 0; % A = 0
dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
dy(3) =  ka*y(1)*y(2) - kd*y(3); % AB

end


function [X, Y] = ODESolve(k, xdata, ydata, pfuncAsso, pfuncDisso, eventTime)

Rmax = k(4);

absTol = 1e-4;
relTol = 1e-4;

y0Asso = [0; Rmax; 0];
y0Disso = [0; Rmax; Rmax];
options = odeset('RelTol', relTol, 'AbsTol', absTol);

assoStart = find(xdata == eventTime(1));
assoEnd = find(xdata == eventTime(2));
dissoStart = find(xdata == eventTime(3));
dissoEnd = find(xdata == eventTime(4));

tspanAsso = xdata(assoStart:assoEnd);
tspanDisso = xdata(dissoStart:dissoEnd);

[XAsso, YAsso] = ode15s(@(x, y) pfuncAsso (x, y, k), tspanAsso, y0Asso, options);
[XDisso, YDisso] = ode15s(@(x, y) pfuncDisso (x, y, k), tspanDisso, y0Disso, options);

X = [XAsso; XDisso];
Y = [YAsso; YDisso];

end


function F = LsqFit(k, xdata, ydata, pfuncAsso, pfuncDisso, eventTime)

[T, R] = ODESolve(k, xdata, ydata, pfuncAsso, pfuncDisso, eventTime);

n = length(T);
m = length(xdata);
F = zeros(m, 1);

j = 1;
for i = 1 : n
  if T(i) == xdata(j)
      F(j) = R(i, 3);
      j = j + 1;
  end
end  

end