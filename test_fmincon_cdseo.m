clear all

% Association
% @(Rmax1, Koff1, Kon1, BI1)Rmax1 * rawDataConcen{1} /(Koff1/Kon1 + rawDataConcen{1}) 
% *(1 - exp(-(Kon1*rawDataConcen{1} + Koff1) *rawDataAssoX{1})) + 0 - rawDataAssoY{1}

% Dissociation
% @(Koff1) 5.517000e+01 * exp(-Koff1 * rawDataDissoX{1}) - rawDataDissoY{1}

% xVarDisso =
%     {'x(2)'}

% xVarAsso =
%     {'x(1), x(2), x(3), x(4)…'}

% dy(1) = @(kt, kd) kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
% dy(2) = @(ka, kd) -ka*y(1)*y(2) + kd*y(3); % B
% dy(3) = @(ka, kd) ka *y(1)*y(2) - kd*y(3); % AB

tAssoEnd = 120;
tDissoEnd = 500;
Rmax = 62.85;
tspan1 = 0:tAssoEnd;
tspan2 = tAssoEnd+1:tDissoEnd;
[t1, y1] = ode15s(@func,tspan1,[0;Rmax;0]);
[t2, y2] = ode15s(@func2, tspan2, [0;Rmax;y1(end, 3)]);

rawT = [t1; t2];
rawY = [y1(:, 3); y2(:, 3)];

% figure(1)
% plot(rawT, rawY)

A = [];
b = [];
Aeq = [];
beq = [];
lb = [10^8 10^(-4) 10^5 10^(-10)];
ub = [10^10 10^(-2) 10^7 10^(-8)];
x0 = [2.01*10^8 2.95*10^(-3) 2.04*10^6 16*10^(-9)];

global kt ka kd C

odeFun = @(kt, ka, kd, C) ode15s(fcn2, 0:120, [0;Rmax;0]) - y1;

[x, fval] = fmincon(odeFun, x0, A, b, Aeq, beq, lb, ub);

function dy = fcn2(t, y)

global kt ka kd C

dy = zeros(3, 1);

dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
dy(3) = ka *y(1)*y(2) - kd*y(3); % AB

end



% Association
function dy = func(t,y)
    ka = 2.04*10^6;
    kd = 2.95*10^(-3);
    kt = 2.01*10^8;
    C = 16*10^(-9);
    dy = zeros(3,1);
    
    dy(1) = kt*(C-y(1)) - (ka*y(1)*y(2) - kd*y(3)); % A (mass transfer)
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) = ka *y(1)*y(2) - kd*y(3); % AB
end

% Dissociation
function dy = func2(t,y)
    ka = 2.04*10^6;
    kd = 2.95*10^(-3);
    kt = 2.01*10^8;
    C = 16*10^(-9);
    dy = zeros(3,1);
    
    dy(1) = 0;
    dy(2) = -ka*y(1)*y(2) + kd*y(3); % B
    dy(3) = ka *y(1)*y(2) - kd*y(3); % AB
end