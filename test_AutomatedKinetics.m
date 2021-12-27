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
% concentration = [32*10^(-9); 16*10^(-9); 8*10^(-9); 4*10^(-9); 2e-9];
assoStart = 90; assoEnd = 219; dissoStart = 220; dissoEnd = 470;
app.UIFigure.UserData.EventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

getframe(app.UIAxes);

parentPath = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\iMSPR_test_failed\PathTest';
app.UIFigure.UserData.Analyte = test_path_parsing(parentPath, app.UIFigure.UserData.EventTime);
app.UIDropdownName.Items = {app.UIFigure.UserData.Analyte.Name};

disp(app.UIFigure.UserData.Analyte)

% Button Pushed functions
app.UIDropdownName.ValueChangedFcn = @(src, event) UIDropdownNameValueChangedFunction(src, event, app.UIFigure.UserData.Analyte, app);
app.UIButtonOK.ButtonPushedFcn = @(src, event) OKButtonPushedFunction(src, event, app);
app.UIButtonTimingSet.ButtonPushedFcn = @(src, event) TimingButtonPushed(src, event, app, app.UIFigure.UserData.Analyte);
app.UIButtonFit.ButtonPushedFcn = @(src, event) FitButtonPushed(src, event);

UIProgressDialog = ...
    uiprogressdlg(app.UIFigure, 'Title', 'Please wait', ...
    'Message', 'Fitting Curve(s)...', ...
    'Indeterminate', 'on');
pause(0.01)
for i = 1:size(app.UIFigure.UserData.Analyte, 2)
    [app.UIFigure.UserData.Analyte(i).k,...
        app.UIFigure.UserData.Analyte(i).kName,...
        app.UIFigure.UserData.Analyte(i).chi2,...
        app.UIFigure.UserData.Analyte(i).FittedT,...
        app.UIFigure.UserData.Analyte(i).FittedR]...
            = ReadyForCurveFitting(...
                app.UIFigure.UserData.Analyte(i).Concentration,...
                app.UIFigure.UserData.Analyte(i).EventTime,...
                app.UIFigure.UserData.Analyte(i).XData,...
                app.UIFigure.UserData.Analyte(i).YData,...
                app.UIFigure.UserData.Analyte(i).RmaxCandidate);
end
        
UIDropdownNameValueChangedFunction(app.UIDropdownName, [], app.UIFigure.UserData.Analyte, app)
close(UIProgressDialog)

function [k, kName, chi2, fittedT, fittedR] = ReadyForCurveFitting(concentration, eventTime, xdata, ydata, rmaxCandidate)    

koff = ones(1, size(concentration, 1)) * 10^(-3);
kon = ones(1, size(concentration, 1)) * 10^6;
Rmax = ones(1, size(concentration, 1));
if max(rmaxCandidate)>0; Rmax = Rmax * rmaxCandidate; end
BI = zeros(1, size(concentration, 1));
drift = zeros(1, size(concentration, 1));

fittingVariables.Name = {'koff';   'kon';    'Rmax';   'BI';    'drift'};
fittingVariables.Type = {'Global'; 'Global'; 'Global'; 'Constant'; 'Constant'};
fittingVariables.InitialValue = cell(length(fittingVariables.Type), 1);
fittingVariables.UpperBound = cell(length(fittingVariables.Type), 1);
fittingVariables.LowerBound = cell(length(fittingVariables.Type), 1);

fittingVariables.InitialValue{1, 1} = koff;
fittingVariables.InitialValue{2, 1} = kon;
fittingVariables.InitialValue{3, 1} = Rmax;
fittingVariables.InitialValue{4, 1} = BI;
fittingVariables.InitialValue{5, 1} = drift;

fittingVariables.UpperBound{1, 1} = fittingVariables.InitialValue{1, 1} * 10;
fittingVariables.UpperBound{2, 1} = fittingVariables.InitialValue{2, 1} * 10;
fittingVariables.UpperBound{3, 1} = fittingVariables.InitialValue{3, 1} * 10;
fittingVariables.UpperBound{4, 1} = inf(size(fittingVariables.InitialValue{4, 1}));
fittingVariables.UpperBound{5, 1} = inf(size(fittingVariables.InitialValue{5, 1}));

fittingVariables.LowerBound{1, 1} = fittingVariables.InitialValue{1, 1} / 10;
fittingVariables.LowerBound{2, 1} = fittingVariables.InitialValue{2, 1} / 10;
fittingVariables.LowerBound{3, 1} = fittingVariables.InitialValue{3, 1} / 10;
fittingVariables.LowerBound{4, 1} = -inf(size(fittingVariables.InitialValue{4, 1}));
fittingVariables.LowerBound{5, 1} = -inf(size(fittingVariables.InitialValue{5, 1}));

[k, kName, chi2, T, R] = OneToOneStandardFitting(...
    concentration, eventTime, xdata, ydata, fittingVariables);

fittedT = reshape(T, size(R, 1)/length(concentration), length(concentration));
fittedR = reshape(R(:, 3), size(R, 1)/length(concentration), length(concentration));

end


function OKButtonPushedFunction(src, event, app)

set(findobj(app.UIFigure, 'type', 'uibutton'), 'Enable', 'On')
set(findobj(app.UIFigure, 'type', 'uidropdown'), 'Enable', 'On')
app.UIButtonOK.Visible = 'Off'; app.UIButtonOK.Enable = 'Off';

analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));

app.UIFigure.UserData.Analyte(analyteNo).EventTime =...
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

disp(app.UIFigure.UserData.Analyte(analyteNo).EventTime)

end

function UIDropdownNameValueChangedFunction(src, event, analyte, app)

cla(app.UIAxes);
analyteNo = find(strcmp(src.Items, src.Value));

for i = 1:size(analyte(analyteNo).Data, 1)
    hold(app.UIAxes, 'on');
    plot(app.UIAxes,...
        analyte(analyteNo).Data{i, 1}.x,...
        analyte(analyteNo).Data{i, 1}.y,...
        'Color', 'Black')
end

app.UIFigure.UserData.MarkAsStart = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkAsStart.Parent = app.UIAxes;
app.UIFigure.UserData.MarkAsStart.Position = [analyte(analyteNo).EventTime(1), -1, 0, 1];
app.UIFigure.UserData.MarkAsStart.Color = [1, 0, 0];

app.UIFigure.UserData.MarkAsEnd = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkAsEnd.Parent = app.UIAxes;
app.UIFigure.UserData.MarkAsEnd.Position = [analyte(analyteNo).EventTime(2), -1, 0, 1];
app.UIFigure.UserData.MarkAsEnd.Color = [0, 1, 0];

app.UIFigure.UserData.MarkDisStart = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkDisStart.Parent = app.UIAxes;
app.UIFigure.UserData.MarkDisStart.Position = [analyte(analyteNo).EventTime(3), -1, 0, 1];
app.UIFigure.UserData.MarkDisStart.Color = [0, 0, 1];

app.UIFigure.UserData.MarkDisEnd = annotation(app.UIFigure, 'arrow'); 
app.UIFigure.UserData.MarkDisEnd.Parent = app.UIAxes;
app.UIFigure.UserData.MarkDisEnd.Position = [analyte(analyteNo).EventTime(4), -1, 0, 1];
app.UIFigure.UserData.MarkDisEnd.Color = [0, 1, 1];

for i = 1:size(analyte(analyteNo).FittedR, 2)
    hold(app.UIAxes, 'On');
    plot(app.UIAxes,...
        analyte(analyteNo).FittedT(:, i),...
        analyte(analyteNo).FittedR(:, i),...
        'Color', 'Red');
end
% Table display (koff, kon, Rmax, KA, KD)
koff = analyte(analyteNo).k(1);
kon = analyte(analyteNo).k(2);
Rmax = analyte(analyteNo).k(3);
KD = koff / kon; KA = kon / koff;
if isempty(analyte(analyteNo).chi2); analyte(analyteNo).chi2 = NaN; end
chi2 = analyte(analyteNo).chi2;
app.UITable.Data = table(koff, kon, Rmax, KA, KD, chi2);

end

function TimingButtonPushed(src, event, app, analyte)

src = app.UIButtonTimingSet;
analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));

% Disable buttons and dropdowns
set(findobj(app.UIFigure, 'type', 'uibutton'), 'Enable', 'Off')
set(findobj(app.UIFigure, 'type', 'uidropdown'), 'Enable', 'Off')

% Visualize OK button
app.UIButtonOK.Visible = 'On'; app.UIButtonOK.Enable = 'On';

UIAxes = app.UIAxes;
xLim = UIAxes.XLim; yLim = UIAxes.YLim;

asStartPos = [analyte(analyteNo).EventTime(1), yLim(1);...
    analyte(analyteNo).EventTime(1), yLim(2)]; %#ok<*FNDSB>
asEndPos = [analyte(analyteNo).EventTime(2), yLim(1);...
    analyte(analyteNo).EventTime(2), yLim(2)];
disStartPos = [analyte(analyteNo).EventTime(3), yLim(1);...
    analyte(analyteNo).EventTime(3), yLim(2)];
disEndPos = [analyte(analyteNo).EventTime(4), yLim(1);...
    analyte(analyteNo).EventTime(4), yLim(2)];

src.UserData.lineAsStart = drawline('Parent', UIAxes,...
     'Position', asStartPos, ...
     'Deletable', 0, ...
     'InteractionsAllowed', 'translate', ...
     'Label', 'Association Start', ...
     'LabelVisible', 'hover', ...
     'Color', [1 0 0], ...
     'LineWidth', 2);

src.UserData.lineAsEnd = drawline('Parent', UIAxes,...
     'Position', asEndPos, ...
     'Deletable', 0, ...
     'InteractionsAllowed', 'translate', ...
     'Label', 'Association End', ...
     'LabelVisible', 'hover', ...
     'Color', [0 1 0], ...
     'LineWidth', 2);

src.UserData.lineDisStart = drawline('Parent', UIAxes,...
     'Position', disStartPos, ...
     'Deletable', 0, ...
     'InteractionsAllowed', 'translate', ...
     'Label', 'Dissociation Start', ...
     'LabelVisible', 'hover', ...
     'Color', [0 0 1], ...
     'LineWidth', 2);

src.UserData.lineDisEnd = drawline('Parent', UIAxes,...
     'Position', disEndPos, ...
     'Deletable', 0, ...
     'InteractionsAllowed', 'translate', ...
     'Label', 'Dissociation End', ...
     'LabelVisible', 'hover', ...
     'Color', [0 1 1], ...
     'LineWidth', 2);
 
addlistener(src.UserData.lineAsStart, 'ROIMoved', @(lineSrc, event)LineMoveEvent(lineSrc, event, src.UserData, xLim));
addlistener(src.UserData.lineAsEnd, 'ROIMoved', @(lineSrc, event)LineMoveEvent(lineSrc, event, src.UserData, xLim));
addlistener(src.UserData.lineDisStart, 'ROIMoved', @(lineSrc, event)LineMoveEvent(lineSrc, event, src.UserData, xLim));
addlistener(src.UserData.lineDisEnd, 'ROIMoved', @(lineSrc, event)LineMoveEvent(lineSrc, event, src.UserData, xLim));

SetDrawingArea(src.UserData, xLim)

function LineMoveEvent(lineSrc, event, UserData, xLim)
    SetDrawingArea(UserData, xLim)
end

function SetDrawingArea(UserData, xLim)
    % drawingArea = [x, y, w, h];
    UserData.lineAsStart.DrawingArea =...
        [xLim(1)+1, 0,...
        UserData.lineAsEnd.Position(1)-xLim(1)-1, 0];
    UserData.lineAsEnd.DrawingArea =...
        [UserData.lineAsStart.Position(1)+1, 0,...
        UserData.lineDisStart.Position(1)-UserData.lineAsStart.Position(1)-1, 0];
    UserData.lineDisStart.DrawingArea =...
        [UserData.lineAsEnd.Position(1)+1, 0,...
        UserData.lineDisEnd.Position(1) - UserData.lineAsEnd.Position(1)-1, 0];
    UserData.lineDisEnd.DrawingArea =...
        [UserData.lineDisStart.Position(1)+1, 0,...
        floor(xLim(2) - UserData.lineDisStart.Position(1)), 0];
end

end

function FitButtonPushed(src, event)
disp(src)
disp(event)
end