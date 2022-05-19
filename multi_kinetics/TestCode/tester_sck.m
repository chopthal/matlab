i = 3;

concentration = cell(5, 1);
associationStart = cell(5, 1);
associationEnd = cell(5, 1);
dissociationStart = cell(5, 1);
dissociationEnd = cell(5, 1);
driftRange = cell(5, 1);

scaleFactor(1) = 10;
concentration{1} = [5e-7 10e-7 20e-7 40e-7 80e-7];
associationStart{1} = [8 454 885 1316 1738] + 42;
associationEnd{1} = [264  616 1049 1480 1907] + 42;
dissociationStart{1} = [290 645 1081 1508 1940] + 42;
dissociationEnd{1} = [431 852 1286 1708 2600] + 42;
driftRange{1} = [1 48];

scaleFactor(2) = 10;
concentration{2} = [5e-7 10e-7 20e-7 40e-7 80e-7];
associationStart{2} =  [12   435   848    1263   1687] + 40;
associationEnd{2} =    [203  616   1032   1436   1844] + 40;
dissociationStart{2} = [213  637   1049   1467   1887] + 40;
dissociationEnd{2} =   [414  821   1242   1659   2600] + 40;
driftRange{2} = [1 41];

scaleFactor(3) = 100;
concentration{3} = [5e-7 10e-7 20e-7 40e-7 80e-7];
associationStart{3} =  [20   503   924    1358   1788] + 48;
associationEnd{3} =    [200  639   1062   1485   1911] + 48;
dissociationStart{3} = [224  665   1100   1536   1972] + 48;
dissociationEnd{3} =   [448  877   1303   1726   2600] + 48;
driftRange{3} = [-42 20] + 48;

scaleFactor(4) = 1000;
concentration{4} = [10e-7 20e-7 40e-7 80e-7];
associationStart{4} =  [497   926    1368   1786];
associationEnd{4} =    [650   1077   1500   1922];
dissociationStart{4} = [670   1102   1525   1967];
dissociationEnd{4} =   [887   1313   1738   2635];
driftRange{4} = [3 461];

scaleFactor(5) = 100;
concentration{5} = [5e-7 10e-7 20e-7 40e-7 80e-7];
associationStart{5} =  [165  466   911    1233   1661];
associationEnd{5} =    [333  628   1040   1386   1808];
dissociationStart{5} = [362  655   1090   1435   1850];
dissociationEnd{5} =   [438  861   1198   1610   2440];
driftRange{5} = [3 135];


fileName = 'TestSet/titration_data_2.txt';
fig = figure(1); clf(fig, 'reset'); ax = axes(fig); cla(ax);
xlabel(ax, 'Time (sec)');
ylabel(ax, 'Signal (RU)');
data = table2array(readtable(fileName));
concentration = concentration{i};
associationStart = associationStart{i};
associationEnd = associationEnd{i};
dissociationStart = dissociationStart{i};
dissociationEnd = dissociationEnd{i};
driftRange = driftRange{i};

data = data(:, 2*i-1:2*i);
xData = 1:size(yData, 1); yData = data(:, 2);
xData = xData';

xFit = driftRange(1):driftRange(2);
yFit = yData(driftRange(1):driftRange(2));
p = polyfit(xFit, yFit, 1);
drift = p(1)*xData + p(2);
yData = yData - drift;

hold(ax, 'on'); plot(ax, xData, yData);



pause(0.01)

% kmass = [1*10^8  1*10^8  1*10^8  1*10^8  2*10^8];
% koff  = ones(1, length(concentration)) * 10^-4;
% kon   = ones(1, length(concentration)) * 10^3;
koff  = ones(1, length(concentration)) * 10^-4;
kon   = ones(1, length(concentration)) * 10^1;
Rmax  = ones(1, length(concentration)) * 2000;
BI    = ones(1, length(concentration)) * 0;
scaleFactor = scaleFactor(i);
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
    fprintf('%s : %.2e\n', kName{i}, k(i))
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