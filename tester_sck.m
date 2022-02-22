concentration = [5e-7 10e-7 20e-7 40e-7 80e-7];

associationTime = [11 420 834 1249 1667];
injectionTime = 180;
dissociationTime = associationTime + injectionTime;

fileName = 'TestSet/titration_data.txt';
fig = figure(1); clf(fig, 'reset'); ax = axes(fig); cla(ax);
data = readtable(fileName);
xData = floor(data.X); yData = data.Y;
hold(ax, 'on'); plot(ax, xData, yData);

pause(0.01)

% kmass = [1*10^8  1*10^8  1*10^8  1*10^8  2*10^8];
koff  = [10^(-3) 10^(-3) 10^(-3) 10^(-3) 10^(-3)]; 
kon   = [10^6    10^6    10^6    10^6    10^6];
Rmax  = [2100    2100    2100    2100    2100];
BI    = [0       0       0       0       0];
drift = [0       0       0       0       0];

fittingVariables.Name = {'koff';   'kon';    'Rmax';   'BI'};
fittingVariables.Type = {'Global'; 'Global'; 'Global'; 'Constant'};
% fittingVariables.Type = {'Constant'; 'Constant'; 'Constant'; 'Constant'};
fittingVariables.InitialValue = cell(length(fittingVariables.Type), 1);
fittingVariables.UpperBound = cell(length(fittingVariables.Type), 1);
fittingVariables.LowerBound = cell(length(fittingVariables.Type), 1);

fittingVariables.InitialValue{1, 1} = koff; 
fittingVariables.InitialValue{2, 1} = kon;
fittingVariables.InitialValue{3, 1} = Rmax;
fittingVariables.InitialValue{4, 1} = BI;

fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * 10000;
fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * 10000;
fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * 10000;
fittingVariables.UpperBound{4, 1} = inf(size(fittingVariables.InitialValue{4, 1}));

fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / 10000;
fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / 10000;
fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / 10000;
fittingVariables.LowerBound{4, 1} = -inf(size(fittingVariables.InitialValue{4, 1}));

isMassTransfer = false;
[k, kName, chi2, T, R] = OneToOneSingleCycleKinetics(...
    concentration, associationTime, dissociationTime, xData, yData, isMassTransfer, fittingVariables);
disp([char(kName) num2str(k')])
disp(chi2)

fittedT = reshape(T, size(R, 1)/length(concentration), length(concentration));
fittedR = reshape(R(:, 3), size(R, 1)/length(concentration), length(concentration));
for i = 1:size(fittedR, 2)
    hold(ax, 'On'); plot(ax, fittedT(:, i), fittedR(:, i), 'Color', 'Red');
end