% fittingModel = 'OneToOneStandard';
fittingModel = 'OneToOneMassTransfer';
boundRatio = 100000000;

concentration = [200000*10^(-9); 100000*10^(-9); 50000*10^(-9); 25000*10^(-9); 12500e-9; 6250e-9];
assoStart = 53; assoEnd = 170; dissoStart = 171; dissoEnd = 500;
eventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

path = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\yd_results';
file = '#114 export';
ext = '.txt';
tmpTable = readtable(fullfile(path, strcat(file, ext)));

if size(concentration, 1) ~= size(tmpTable, 2)/2   
    disp('Number of data and conc is different!')
    return
end

xdata = []; ydata = [];
savData = [];
fig = figure(1); clf(fig, 'reset'); ax = axes(fig); cla(ax);
for i = 1:size(concentration, 1)
    tmpData = tmpTable{:, :};
    data = tmpData(:, 2*i-1:2*i);
    newx = [1:size(data(:, 2), 1)]';
    newy = data(:, 2);
    savData(:, i) = newy;
    xdata = [xdata; newx];
    ydata = [ydata; newy];
    hold(ax, 'On'); plot(ax, newx, newy, 'Color', 'Blue')
end
pause(0.01)
savTable = array2table([newx savData]);
writetable(savTable, fullfile(path, strcat(file, '_timeDomain')), 'Delimiter', 'tab', 'WriteVariableNames', false);


% kmass = [1*10^8  1*10^8  1*10^8  1*10^8  2*10^8];

kon   = ones(1, size(concentration, 1)) * 1e5;
koff  = ones(1, size(concentration, 1)) * 1e-3;
kt    = ones(1, size(concentration, 1)) * 10^8; 
Rmax  = ones(1, size(concentration, 1)) * 330;
BI    = ones(1, size(concentration, 1)) * 0;
% drift = [0       0       0       0       0];

% fittingVariables.Name = {'kon';   'koff';   'Rmax';   'BI'};
% fittingVariables.Type = {'Global'; 'Global'; 'Global'; 'Local'};
% fittingVariables.InitialValue{1, 1} = kon; 
% fittingVariables.InitialValue{2, 1} = koff;
% fittingVariables.InitialValue{3, 1} = Rmax;
% fittingVariables.InitialValue{4, 1} = BI;
% fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * boundRatio;
% fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * boundRatio;
% fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * boundRatio;
% fittingVariables.UpperBound{4, 1} = inf(size(fittingVariables.InitialValue{4, 1}));
% fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / boundRatio;
% fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / boundRatio;
% fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / boundRatio;
% fittingVariables.LowerBound{4, 1} = -inf(size(fittingVariables.InitialValue{4, 1}));

fittingVariables.Name = {'kon';   'koff';  'kt';  'Rmax';   'BI'};
fittingVariables.Type = {'Global'; 'Global'; 'Global'; 'Global'; 'Local'};
fittingVariables.InitialValue = cell(length(fittingVariables.Type), 1);
fittingVariables.UpperBound = cell(length(fittingVariables.Type), 1);
fittingVariables.LowerBound = cell(length(fittingVariables.Type), 1);
fittingVariables.InitialValue{1, 1} = kon; 
fittingVariables.InitialValue{2, 1} = koff;
fittingVariables.InitialValue{3, 1} = kt;
fittingVariables.InitialValue{4, 1} = Rmax;
fittingVariables.InitialValue{5, 1} = BI;
fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * boundRatio;
fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * boundRatio;
fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * boundRatio;
fittingVariables.UpperBound{4, 1} = fittingVariables.InitialValue{4, 1} * boundRatio;
fittingVariables.UpperBound{5, 1} = inf(size(fittingVariables.InitialValue{5, 1}));
fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / boundRatio;
fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / boundRatio;
fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / boundRatio;
fittingVariables.LowerBound{4, 1} = fittingVariables.InitialValue{4, 1} / boundRatio;
fittingVariables.LowerBound{5, 1} = -inf(size(fittingVariables.InitialValue{4, 1}));

[k, kName, chi2, T, R] = OneToOneStandardFitting(concentration, eventTime, xdata, ydata, fittingVariables, fittingModel);
disp([char(kName) num2str(k')])
disp(chi2)

fittedT = reshape(T, size(R, 1)/length(concentration), length(concentration));
fittedR = reshape(R(:, 3), size(R, 1)/length(concentration), length(concentration));
for i = 1:size(fittedR, 2)
    hold(ax, 'On'); plot(ax, fittedT(:, i), fittedR(:, i), 'Color', 'Red');
end