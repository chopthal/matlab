close force all; clear;

app = struct;
% Generate App (Figure, axes, table..)
app.UIFigure = uifigure;
app.UIFigure.Visible = 'On';
app.UIFigure.Position = [100, 100, 800, 600];
app.UIMainGrid = uigridlayout(app.UIFigure);

app.UIDropdownGrid = uigridlayout(app.UIMainGrid);
app.UILabelName = uilabel(app.UIDropdownGrid);
app.UILabelName.Text = 'Analyte : ';
app.UIDropdownName = uidropdown(app.UIDropdownGrid);
app.UIDropdownName.Items = {'Analyte(1)', 'Analyte(2)', 'Analyte(3)'};
app.UIDropdownName.Value = app.UIDropdownName.Items{matches(app.UIDropdownName.Items, app.UIDropdownName.Items(1))};
app.UIButtonOK = uibutton(app.UIDropdownGrid);
app.UIButtonOK.Text = 'OK';
app.UIButtonOK.Visible = 'Off';

app.UIAxes = uiaxes(app.UIMainGrid);
app.UIAxes.XLabel.String = 'Time (s)';
app.UIAxes.YLabel.String = 'Response (RU)';

app.UILabel = uilabel(app.UIMainGrid); 
app.UILabel.Text = "1:1 Langmuir binding model (Global parameters)";
app.UILabel.VerticalAlignment = 'bottom';

app.UITable = uitable(app.UIMainGrid);
app.UIMainGrid.RowHeight = {50, '10x', '1x', '3x', 50};
app.UIMainGrid.ColumnWidth = {'1x'};

app.UIButtonGrid = uigridlayout(app.UIMainGrid);
app.UIButtonFit = uibutton(app.UIButtonGrid);
app.UIButtonFit.Text = 'Fit';
app.UIButtonClose = uibutton(app.UIButtonGrid);
app.UIButtonClose.Text = 'Close';

app.UIButtonFittingSet = uibutton(app.UIButtonGrid);
app.UIButtonFittingSet.Text = 'Fitting Set';
app.UIButtonTimingSet = uibutton(app.UIButtonGrid);
app.UIButtonTimingSet.Text = 'Timing Set';

app.UIDropdownGrid.RowHeight = {'1x'};
app.UIDropdownGrid.ColumnWidth = {60, 200, '1x', 100};

app.UIButtonGrid.RowHeight = {'1x'};
app.UIButtonGrid.ColumnWidth = {100, 100, '1x', 100, 100};

app.UIDropdownGrid.Layout.Row = 1; app.UIDropdownGrid.Layout.Column = 1;
app.UIAxes.Layout.Row = 2; app.UIAxes.Layout.Column = 1;
app.UILabel.Layout.Row = 3; app.UILabel.Layout.Column = 1;
app.UITable.Layout.Row = 4; app.UITable.Layout.Column = 1;
app.UIButtonGrid.Layout.Row = 5; app.UIButtonGrid.Layout.Column = 1;

app.UILabelName.Layout.Row = 1; app.UILabelName.Layout.Column = 1;
app.UIDropdownName.Layout.Row = 1; app.UIDropdownName.Layout.Column = 2;
app.UIButtonOK.Layout.Row = 1; app.UIButtonOK.Layout.Column = 4;

app.UIButtonFit.Layout.Row = 1; app.UIButtonFit.Layout.Column = 4;
app.UIButtonClose.Layout.Row = 1; app.UIButtonClose.Layout.Column = 5;
app.UIButtonFittingSet.Layout.Row = 1; app.UIButtonFittingSet.Layout.Column = 2;
app.UIButtonTimingSet.Layout.Row = 1; app.UIButtonTimingSet.Layout.Column = 1;

% Get Inputs from Main UI Table
% Injection delay (sec) when normalizing
% Normalization flow rate (ul/min)
% Flow rate (ul/min)
% Current flow rate (ul/min)
% Calcuate Current Injection delay (sec)
concentration = [32*10^(-9); 16*10^(-9); 8*10^(-9); 4*10^(-9); 2e-9];
assoStart = 90; assoEnd = 219; dissoStart = 220; dissoEnd = 470;
app.UIFigure.UserData.EventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

% Button Pushed functions
app.UIButtonOK.ButtonPushedFcn = @(src, event) OKButtonPushedFunction(src, event, app);
app.UIButtonTimingSet.ButtonPushedFcn = @(btn, event) TimingButtonPushed(app);

% Plot curves
parentPath = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\iMSPR_test_failed';
parentPathContents = dir(parentPath);
listContents = {parentPathContents.name};
isFolder = [parentPathContents.isdir];
listFolder = listContents(isFolder);
listAnalyteFolder = listFolder(contains(listFolder, 'Analyte'));
listFullPathAnalyteFolder = fullfile(parentPath, listAnalyteFolder, 'RU');
listFullPathCurve = fullfile(listFullPathAnalyteFolder, 'Ch1-Ch2.txt');

cla(app.UIAxes);
getframe(app.UIAxes);

data = cell(size(listFullPathCurve, 2), 1);
rmaxCandidate = zeros(size(listFullPathCurve, 2), 1);
for i = 1:size(listFullPathCurve, 2)
    data{i, 1} = readtable(listFullPathCurve{i}, 'VariableNamingRule', 'preserve');
    data{i}.y = data{i}.y - data{i}.y(1);    
    rmaxCandidate(i) = data{i}.y(data{i}.x == dissoStart);
    hold(app.UIAxes, 'on'); plot(app.UIAxes, data{i}.x, data{i}.y, 'Color', 'Black')
end

xdata = []; ydata = [];
for i = 1:size(data, 1)
    xdata = [xdata; data{i}.x];
    ydata = [ydata; data{i}.y];
end
pause(0.01)

app.UIFigure.UserData.MarkAsStart = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkAsStart.Parent = app.UIAxes;
app.UIFigure.UserData.MarkAsStart.Position = [app.UIFigure.UserData.EventTime(1), -1, 0, 1];
app.UIFigure.UserData.MarkAsStart.Color = [1, 0, 0];

app.UIFigure.UserData.MarkAsEnd = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkAsEnd.Parent = app.UIAxes;
app.UIFigure.UserData.MarkAsEnd.Position = [app.UIFigure.UserData.EventTime(2), -1, 0, 1];
app.UIFigure.UserData.MarkAsEnd.Color = [0, 1, 0];

app.UIFigure.UserData.MarkDisStart = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkDisStart.Parent = app.UIAxes;
app.UIFigure.UserData.MarkDisStart.Position = [app.UIFigure.UserData.EventTime(3), -1, 0, 1];
app.UIFigure.UserData.MarkDisStart.Color = [0, 0, 1];

app.UIFigure.UserData.MarkDisEnd = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkDisEnd.Parent = app.UIAxes;
app.UIFigure.UserData.MarkDisEnd.Position = [app.UIFigure.UserData.EventTime(4), -1, 0, 1];
app.UIFigure.UserData.MarkDisEnd.Color = [0, 1, 1];

ReadyForCurveFitting(app.UIFigure, app.UIAxes, app.UITable, concentration, app.UIFigure.UserData.EventTime, xdata, ydata, rmaxCandidate)

function ReadyForCurveFitting(UIFigure, UIAxes, UITable, concentration, eventTime, xdata, ydata, rmaxCandidate)    

UIProgressDialog = ...
    uiprogressdlg(UIFigure, 'Title', 'Please wait', ...
    'Message', 'Fitting Curve(s)...', ...
    'Indeterminate', 'on');
pause(0.01)

kmass = zeros(1, size(concentration, 1));
koff = ones(1, size(concentration, 1)) * 10^(-3);
kon = ones(1, size(concentration, 1)) * 10^6;
Rmax = ones(1, size(concentration, 1)) * max(rmaxCandidate);
BI = zeros(1, size(concentration, 1));
drift = zeros(1, size(concentration, 1));

fittingVariables.Name = {'kt';    'koff';   'kon';    'Rmax';   'BI';    'drift'};
fittingVariables.Type = {'Constant'; 'Global'; 'Global'; 'Global'; 'Constant'; 'Constant'};
fittingVariables.InitialValue = cell(length(fittingVariables.Type), 1);
fittingVariables.UpperBound = cell(length(fittingVariables.Type), 1);
fittingVariables.LowerBound = cell(length(fittingVariables.Type), 1);

fittingVariables.InitialValue{1, 1} = kmass;
fittingVariables.InitialValue{2, 1} = koff;
fittingVariables.InitialValue{3, 1} = kon;
fittingVariables.InitialValue{4, 1} = Rmax;
fittingVariables.InitialValue{5, 1} = BI;
fittingVariables.InitialValue{6, 1} = drift;

fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * 10;
fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * 10;
fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * 10;
fittingVariables.UpperBound{4, 1} = fittingVariables.InitialValue{4, 1} * 10;
fittingVariables.UpperBound{5, 1} = inf(size(fittingVariables.InitialValue{5, 1}));
fittingVariables.UpperBound{6, 1} = inf(size(fittingVariables.InitialValue{6, 1}));

fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / 10;
fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / 10;
fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / 10;
fittingVariables.LowerBound{4, 1} = fittingVariables.InitialValue{4, 1} / 10;
fittingVariables.LowerBound{5, 1} = -inf(size(fittingVariables.InitialValue{5, 1}));
fittingVariables.LowerBound{6, 1} = -inf(size(fittingVariables.InitialValue{6, 1}));

% isMassTransfer = true;
isMassTransfer = false;
[k, kName, chi2, T, R] = OneToOneKineticsFitting(...
    concentration, eventTime, xdata, ydata, isMassTransfer, fittingVariables);

fittedT = reshape(T, size(R, 1)/length(concentration), length(concentration));
fittedR = reshape(R(:, 3), size(R, 1)/length(concentration), length(concentration));
for i = 1:size(fittedR, 2)
    hold(UIAxes, 'On'); plot(UIAxes, fittedT(:, i), fittedR(:, i), 'Color', 'Red');
end

% Table display (koff, kon, Rmax, KA, KD)
koff = k(2); kon = k(3); Rmax = k(4); KD = koff / kon; KA = kon / koff;
UITable.Data = table(koff, kon, Rmax, KA, KD, chi2);
close(UIProgressDialog)

end


function OKButtonPushedFunction(src, event, app)

set(findobj(app.UIFigure, 'type', 'uibutton'), 'Enable', 'On')
set(findobj(app.UIFigure, 'type', 'uidropdown'), 'Enable', 'On')
app.UIButtonOK.Visible = 'Off'; app.UIButtonOK.Enable = 'Off';

app.UIFigure.UserData.EventTime =...
    round([app.UIButtonTimingSet.UserData.lineAsStart.Position(1),...
    app.UIButtonTimingSet.UserData.lineAsEnd.Position(1), ...
    app.UIButtonTimingSet.UserData.lineDisStart.Position(1), ...
    app.UIButtonTimingSet.UserData.lineDisEnd.Position(1)]);

% delete(findobj(app.UIFigure, 'Type', 'arrow'))

app.UIFigure.UserData.MarkAsStart.Position(1) = app.UIButtonTimingSet.UserData.lineAsStart.Position(1);
app.UIFigure.UserData.MarkAsEnd.Position(1) = app.UIButtonTimingSet.UserData.lineAsEnd.Position(1);
app.UIFigure.UserData.MarkDisStart.Position(1) = app.UIButtonTimingSet.UserData.lineDisStart.Position(1);
app.UIFigure.UserData.MarkDisEnd.Position(1) = app.UIButtonTimingSet.UserData.lineDisEnd.Position(1);

delete(app.UIButtonTimingSet.UserData.lineAsStart)
delete(app.UIButtonTimingSet.UserData.lineAsEnd)
delete(app.UIButtonTimingSet.UserData.lineDisStart)
delete(app.UIButtonTimingSet.UserData.lineDisEnd)

disp(app.UIFigure.UserData.EventTime)

end