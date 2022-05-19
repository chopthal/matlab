concentration = [2*10^(-9); 4*10^(-9); 8*10^(-9); 16*10^(-9); 32e-9];
% concentration = [32*10^(-9); 16*10^(-9); 8*10^(-9); 4*10^(-9); 2e-9];
assoStart = 10; assoEnd = 310; dissoStart = 311; dissoEnd = 610;
% assoStart = 60; assoEnd = 104; dissoStart = 118; dissoEnd = 354;
eventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

fileName = {
    'TestSet\BiaSimul_Kt\2n.txt';
    'TestSet\BiaSimul_Kt\4n.txt';
    'TestSet\BiaSimul_Kt\8n.txt';
    'TestSet\BiaSimul_Kt\16n.txt';
    'TestSet\BiaSimul_Kt\32n.txt';
    };

% fileName = {
%     'result1.txt';
%     'result2.txt';
%     'result3.txt';
%     'result4.txt';
%     'result5.txt';
%     };

xdata = []; ydata = [];
fig = figure(1); clf(fig, 'reset'); ax = axes(fig); cla(ax);
for i = 1:size(fileName, 1)    
    data = load(fileName{i, 1});
    xdata = [xdata; data(:, 1)];
    ydata = [ydata; data(:, 2)];
    hold(ax, 'On'); plot(ax, data(:, 1), data(:, 2), 'Color', 'Blue')
end
pause(0.01)

% kmass = [1*10^8  1*10^8  1*10^8  1*10^8  2*10^8];
koff  = [10^(-3) 10^(-3) 10^(-3) 10^(-3) 10^(-3)]; 
kon   = [10^6    10^6    10^6    10^6    10^6];
Rmax  = [240     240     240     240     240];
% Rmax  = [50      50      50      50      50];
BI    = [0       0       0       0       0];
drift = [0       0       0       0       0];

% fittingVariables.Name = {'kt';    'koff';   'kon';    'Rmax';   'BI';    'drift'};
% fittingVariables.Type = {'Local'; 'Global'; 'Global'; 'Global'; 'Constant'; 'Constant'};
fittingVariables.Name = {'koff';   'kon';    'Rmax';   'BI'};
fittingVariables.Type = {'Global'; 'Global'; 'Global'; 'Constant'};
fittingVariables.InitialValue = cell(length(fittingVariables.Type), 1);
fittingVariables.UpperBound = cell(length(fittingVariables.Type), 1);
fittingVariables.LowerBound = cell(length(fittingVariables.Type), 1);

% fittingVariables.InitialValue{1, 1} = kmass;
% fittingVariables.InitialValue{2, 1} = koff; 
% fittingVariables.InitialValue{3, 1} = kon;
% fittingVariables.InitialValue{4, 1} = Rmax;
% fittingVariables.InitialValue{5, 1} = BI;
% fittingVariables.InitialValue{6, 1} = drift;
fittingVariables.InitialValue{1, 1} = koff; 
fittingVariables.InitialValue{2, 1} = kon;
fittingVariables.InitialValue{3, 1} = Rmax;
fittingVariables.InitialValue{4, 1} = BI;

% fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * 10;
% fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * 10;
% fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * 10;
% fittingVariables.UpperBound{4, 1} = fittingVariables.InitialValue{4, 1} * 10;
% fittingVariables.UpperBound{5, 1} = inf(size(fittingVariables.InitialValue{5, 1}));
% fittingVariables.UpperBound{6, 1} = inf(size(fittingVariables.InitialValue{6, 1}));
fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * 10;
fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * 10;
fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * 10;
fittingVariables.UpperBound{4, 1} = inf(size(fittingVariables.InitialValue{4, 1}));

% fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / 10;
% fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / 10;
% fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / 10;
% fittingVariables.LowerBound{4, 1} = fittingVariables.InitialValue{4, 1} / 10;
% fittingVariables.LowerBound{5, 1} = -inf(size(fittingVariables.InitialValue{5, 1}));
% fittingVariables.LowerBound{6, 1} = -inf(size(fittingVariables.InitialValue{6, 1}));
fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / 10;
fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / 10;
fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / 10;
fittingVariables.LowerBound{4, 1} = -inf(size(fittingVariables.InitialValue{4, 1}));

% isMassTransfer = true;
isMassTransfer = false;
% [k, kName, chi2, T, R] = OneToOneKineticsFitting(...
%     concentration, eventTime, xdata, ydata, isMassTransfer, fittingVariables);
[k, kName, chi2, T, R] = OneToOneStandardFitting(...
    concentration, eventTime, xdata, ydata,fittingVariables);
disp([char(kName) num2str(k')])
disp(chi2)

fittedT = reshape(T, size(R, 1)/length(concentration), length(concentration));
fittedR = reshape(R(:, 3), size(R, 1)/length(concentration), length(concentration));
for i = 1:size(fittedR, 2)
    hold(ax, 'On'); plot(ax, fittedT(:, i), fittedR(:, i), 'Color', 'Red');
end