concentration = [5e-7 10e-7 20e-7 40e-7 80e-7];

associationStart = [13 433 843 1257 1681];
associationEnd = [201  614 1030 1433 1844];
dissociationStart = [217 637 1050 1462 1886];
dissociationEnd = [415 820 1242 1661 3213];

fileName = 'TestSet/titration_data.txt';
fig = figure(1); clf(fig, 'reset'); ax = axes(fig); cla(ax);
data = readtable(fileName);
xData = floor(data.X); yData = data.Y;
hold(ax, 'on'); plot(ax, xData, yData);

pause(0.01)

% kmass = [1*10^8  1*10^8  1*10^8  1*10^8  2*10^8];
koff  = ones(1, 5) * 10^-4;
kon   = ones(1, 5) * 10^3;
Rmax  = ones(1, 5) * 2000;
BI    = ones(1, 5) * 0;
scaleFactor = 10;
drift = [0       0       0       0       0];

fittingVariables.Name = {'koff';   'kon';    'Rmax';   'BI'};
fittingVariables.Type = {'Global'; 'Global'; 'Global'; 'Local'};
% fittingVariables.Type = {'Constant'; 'Constant'; 'Constant'; 'Constant'};
fittingVariables.InitialValue = cell(length(fittingVariables.Type), 1);
fittingVariables.UpperBound = cell(length(fittingVariables.Type), 1);
fittingVariables.LowerBound = cell(length(fittingVariables.Type), 1);

fittingVariables.InitialValue{1, 1} = koff; 
fittingVariables.InitialValue{2, 1} = kon;
fittingVariables.InitialValue{3, 1} = Rmax;
fittingVariables.InitialValue{4, 1} = BI;

fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * scaleFactor;
fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * scaleFactor;
fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * scaleFactor;
fittingVariables.UpperBound{4, 1} = inf(size(fittingVariables.InitialValue{4, 1}));

fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / scaleFactor;
fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / scaleFactor;
fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / scaleFactor;
fittingVariables.LowerBound{4, 1} = -inf(size(fittingVariables.InitialValue{4, 1}));

isMassTransfer = false;
[k, kName, chi2, T, R] = OneToOneSingleCycleKinetics(...
    concentration, associationStart, associationEnd, dissociationStart, dissociationEnd, xData, yData, isMassTransfer, fittingVariables);
% disp([char(kName) num2str(k')])

for i=1:size(kName, 2)
    fprintf('%s : %d\n', kName{i}, k(i))
end

disp(chi2)

% fittedT = reshape(T, size(R, 1)/length(concentration), length(concentration));
% fittedR = reshape(R(:, 3), size(R, 1)/length(concentration), length(concentration));
fittedT = T;
fittedR = R(:, 3);
hold(ax, 'On'); plot(ax, fittedT, fittedR, 'Color', 'Red')
% for i = 1:size(fittedR, 2)
%     hold(ax, 'On'); plot(ax, fittedT(:, i), fittedR(:, i), 'Color', 'Red');
% end