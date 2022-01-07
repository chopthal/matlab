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
app.UILabel.Text = "1:1 Langmuir binding model";
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
assoStart = 90; assoEnd = 280; dissoStart = 281; dissoEnd = 650;
app.UIFigure.UserData.EventTime = [assoStart, assoEnd, dissoStart, dissoEnd];

getframe(app.UIAxes);

% parentPath = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\iMSPR_test_failed\PathTest';
parentPath = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\20211224_SMF_2-34,49,59,54_kinetics\20211224_SMF_2-34,49,59,54_kinetics\2021-12-24 14-36-56';
app.UIFigure.UserData.Analyte = test_path_parsing(parentPath, app.UIFigure.UserData.EventTime);
app.UIDropdownName.Items = {app.UIFigure.UserData.Analyte.Name};

% disp(app.UIFigure.UserData.Analyte)

% Button Pushed functions
app.UIDropdownName.ValueChangedFcn = @(src, event) UIDropdownNameValueChangedFunction(src, event, app.UIFigure.UserData.Analyte, app);
app.UIButtonOK.ButtonPushedFcn = @(src, event) OKButtonPushedFunction(src, event, app);
app.UIButtonTimingSet.ButtonPushedFcn = @(src, event) TimingButtonPushed(src, event, app, app.UIFigure.UserData.Analyte);
app.UIButtonFit.ButtonPushedFcn = @(src, event) FitButtonPushed(src, event, app);
app.UIButtonFittingSet.ButtonPushedFcn = @(src, event) FittingSetButtonPushed(src, event, app);

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
                app.UIFigure.UserData.Analyte(i).DefaultFittingVariable);
end
        
UIDropdownNameValueChangedFunction(app.UIDropdownName, [], app.UIFigure.UserData.Analyte, app)

%% Set Fitting variables to Default
for i = 1:size(app.UIFigure.UserData.Analyte, 2)
    app.UIFigure.UserData.Analyte(i).FittingVariable = struct;
    app.UIFigure.UserData.Analyte(i).FittingVariable = app.UIFigure.UserData.Analyte(i).DefaultFittingVariable;
end

close(UIProgressDialog)

function [k, kName, chi2, fittedT, fittedR] = ReadyForCurveFitting(concentration, eventTime, xdata, ydata, fittingVariable)    

fitTimer = tic;
if strcmp(fittingVariable.FittingModel, 'OneToOneStandard')
    [k, kName, chi2, T, R] = OneToOneStandardFitting(...
        concentration, eventTime, xdata, ydata, fittingVariable.OneToOneStandard);
end
fitTime = toc(fitTimer); disp(fitTime)
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

% disp(app.UIFigure.UserData.Analyte(analyteNo).EventTime)

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
% kResult = {[koff], [kon], [Rmax], [BI]};
kVars = {'koff', 'kon', 'Rmax', 'BI'};
kResult = cell(size(kVars, 2), 1);
for i = 1:size(kResult, 1)    
    kResult{i, 1} = zeros(size(analyte(analyteNo).Concentration, 1), 1);
    tmpIdx = contains(analyte(1).kName, analyte(1).kName{i});
    kResult{i, 1}(:, 1) = analyte(analyteNo).k(tmpIdx);    
end

numericKD = kResult{1, 1} ./ kResult{2, 1};
numericKA = kResult{2, 1} ./ kResult{1, 1};
numericChi2 = ones(size(analyte(analyteNo).Concentration, 1), 1) * analyte(analyteNo).chi2;

[concentration, concentrationUnit] = FindConcentrationUnit(analyte(analyteNo).Concentration);
koff = cell(size(analyte(analyteNo).Concentration, 1), 1);
kon = cell(size(analyte(analyteNo).Concentration, 1), 1);
Rmax = cell(size(analyte(analyteNo).Concentration, 1), 1);
BI = cell(size(analyte(analyteNo).Concentration, 1), 1);
KD = cell(size(analyte(analyteNo).Concentration, 1), 1);
KA = cell(size(analyte(analyteNo).Concentration, 1), 1);
for i = 1:size(analyte(analyteNo).Concentration, 1)
%     concentration{i, 1} = sprintf('%0.2f', analyte(analyteNo).Concentration(i, 1));
    koff{i, 1} = sprintf('%0.2e', kResult{1, 1}(i, 1));
    kon{i, 1} = sprintf('%0.2e', kResult{2, 1}(i, 1));
    Rmax{i, 1} = sprintf('%0.2f', kResult{3, 1}(i, 1));
    BI{i, 1} = sprintf('%0.2f', kResult{4, 1}(i, 1));
    KD{i, 1} = sprintf('%0.2e', numericKD(i, 1));
    KA{i, 1} = sprintf('%0.2e', numericKA(i, 1));
    chi2{i, 1} = sprintf('%0.2f', numericChi2(i, 1));
end

if isempty(analyte(analyteNo).chi2); analyte(analyteNo).chi2 = NaN; end
app.UITable.Data = table(concentration, KD, kon, koff, Rmax, KA, BI, chi2);
app.UITable.ColumnName{1} = strcat('Concentration (', concentrationUnit, ')');
app.UITable.ColumnName{2} = 'KD (M)';
app.UITable.ColumnName{3} = 'kon (1/(M*s))';
app.UITable.ColumnName{4} = 'koff (1/s)';
app.UITable.ColumnName{5} = 'Rmax (RU)';
app.UITable.ColumnName{6} = 'KA (1/M)';
app.UITable.ColumnName{7} = 'BI (RU)';
app.UITable.ColumnName{8} = 'Chi2 (RU^2)';

end

function [concStr, unit] = FindConcentrationUnit(concentration)
    logConc = log10(concentration);
    digitConc = round(round(min(logConc(~isinf(logConc))))/3) * 3;

    % Giga ~ ato    
    unitNames = {'GM', 'MM', 'KM', 'M', 'mM', 'uM', 'nM', 'pM', 'fM', 'aM'};
    unitDigitCriteria = [9 6 3 0 -3 -6 -9 -12 -15 -18];    
    [~, idx] = min(abs(digitConc - unitDigitCriteria));
    unitDigit = unitDigitCriteria(idx);        
    unit = (unitNames{idx});
    concNum = concentration / 10^unitDigit;
    concStr = cell(length(concNum), 1);
    
    for i = 1:length(concNum)
        concStr{i, 1} = sprintf('%0.2f', concNum(i));
    end
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

function FitButtonPushed(src, event, app)

UIProgressDialog = ...
    uiprogressdlg(app.UIFigure, 'Title', 'Please wait', ...
    'Message', 'Fitting Curve(s)...', ...
    'Indeterminate', 'on');
pause(0.01)

analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));

[app.UIFigure.UserData.Analyte(analyteNo).k,...
    app.UIFigure.UserData.Analyte(analyteNo).kName,...
    app.UIFigure.UserData.Analyte(analyteNo).chi2,...
    app.UIFigure.UserData.Analyte(analyteNo).FittedT,...
    app.UIFigure.UserData.Analyte(analyteNo).FittedR]...
        = ReadyForCurveFitting(...
            app.UIFigure.UserData.Analyte(analyteNo).Concentration,...
            app.UIFigure.UserData.Analyte(analyteNo).EventTime,...            
            app.UIFigure.UserData.Analyte(analyteNo).XData,...
            app.UIFigure.UserData.Analyte(analyteNo).YData,...
            app.UIFigure.UserData.Analyte(analyteNo).FittingVariable);
        
UIDropdownNameValueChangedFunction(app.UIDropdownName, [], app.UIFigure.UserData.Analyte, app)
close(UIProgressDialog)

end

function FittingSetButtonPushed(src, event, app)
fittingSetApp = test_FittingSet(app);
waitfor(fittingSetApp.UIFigure)
disp(fittingSetApp)

analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));
currentAnalyte = getappdata(app.UIFigure, 'currentAnalyte');
app.UIFigure.UserData.Analyte(analyteNo) = currentAnalyte;

disp(app.UIFigure.UserData.Analyte(analyteNo).FittingVariable.OneToOneStandard.Type)

end