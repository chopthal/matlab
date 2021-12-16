injectionTime = 300;
stabilizationTime = 300;
assoStart1 = 0;
assoEnd1 = assoStart1 + injectionTime;
dissoStart1 = assoEnd1;
dissoEnd1 = dissoStart1 + stabilizationTime;

eventTime = [assoStart1, assoEnd1, dissoStart1, dissoEnd1;...
    assoStart2, assoEnd2, dissoStart2, dissoEnd2;...
    assoStart3, assoEnd3, dissoStart3, dissoEnd3;...
    assoStart4, assoEnd4, dissoStart4, dissoEnd4;...
    assoStart5, assoEnd5, dissoStart5, dissoEnd5];

concentration = [10, 20, 40, 80, 160]; % nM

fileName = 'TestSet\Kinetic titration\Kinetic titration 1.txt';
data = load(fileName);

fig1 = figure(1);
ax1 = axes(fig1);
cla(ax1)
plot(ax1, data(:, 1), data(:, 2))

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