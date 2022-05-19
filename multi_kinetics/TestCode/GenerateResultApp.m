function app = GenerateResultApp

app = struct;

% Generate App (Figure, axes, table..)
app.UIFigure = uifigure;
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100, 100, 850, 750];
app.UIFigure.UserData.ResultFilePath = [];
app.UIFigure.UserData.LineExpandRatio = 1e5;
app.UIMainGrid = uigridlayout(app.UIFigure);

app.UIDropdownGrid = uigridlayout(app.UIMainGrid);
app.UIDropdownGrid.Padding = [10 0 0 10];
app.UILabelName = uilabel(app.UIDropdownGrid);
app.UILabelName.Text = 'Analyte : ';
app.UIDropdownName = uidropdown(app.UIDropdownGrid);
app.UIDropdownName.Items = {'Analyte(1)', 'Analyte(2)', 'Analyte(3)'};
app.UIDropdownName.Value = app.UIDropdownName.Items{matches(app.UIDropdownName.Items, app.UIDropdownName.Items(1))};
app.UICheckBoxLegend = uicheckbox(app.UIDropdownGrid);
app.UICheckBoxLegend.Text = 'Legend';
app.UICheckBoxLegend.Value = 1;

app.UIAxes = uiaxes(app.UIMainGrid);
app.UIAxes.XLabel.String = 'Time (s)';
app.UIAxes.YLabel.String = 'Response (RU)';

app.UIOptionButtonGrid = uigridlayout(app.UIMainGrid);
app.UIOptionButtonGrid.RowHeight = {'1x'};
app.UIOptionButtonGrid.ColumnWidth = {100, 100, '1x', 100, 100};
app.UIOptionButtonGrid.ColumnSpacing = 5;
app.UIOptionButtonGrid.Padding = [0 10 0 10];
app.UIButtonOK = uibutton(app.UIOptionButtonGrid);
app.UIButtonCancel = uibutton(app.UIOptionButtonGrid);
app.UIButtonOK.Text = 'OK';
app.UIButtonOK.Visible = 'Off';
app.UIButtonCancel.Text = 'Cancel';
app.UIButtonCancel.Visible = 'Off';

app.UILabel = uilabel(app.UIMainGrid); 
app.UILabel.Text = "Fitting Result";
app.UILabel.VerticalAlignment = 'center';

app.UITable = uitable(app.UIMainGrid);
app.UIMainGrid.RowHeight = {40, '10x', 50, 20, '5x', 50};
app.UIMainGrid.ColumnWidth = {'1x'};

app.UIMainButtonGrid = uigridlayout(app.UIMainGrid);
app.UIMainButtonGrid.ColumnSpacing = 5;
app.UIMainButtonGrid.Padding = [0 10 0 10];

app.UIButtonTimingSet = uibutton(app.UIOptionButtonGrid);
app.UIButtonTimingSet.Text = 'Timing Set';

app.UIButtonBaseline = uibutton(app.UIOptionButtonGrid);
app.UIButtonBaseline.Text = 'Baseline';

app.UIButtonFittingSet = uibutton(app.UIMainButtonGrid);
app.UIButtonFittingSet.Text = 'Fitting Set';
app.UIButtonFit = uibutton(app.UIMainButtonGrid);
app.UIButtonFit.Text = 'Fit';

app.UIButtonReport = uibutton(app.UIMainButtonGrid);
app.UIButtonReport.Text = 'Report';
app.UIButtonExport = uibutton(app.UIMainButtonGrid);
app.UIButtonExport.Text = 'Export Data';
app.UIButtonClose = uibutton(app.UIMainButtonGrid);
app.UIButtonClose.Text = 'Close';

app.UIDropdownGrid.RowHeight = {'1x'};
app.UIDropdownGrid.ColumnWidth = {60, 200, '1x', 100};

app.UIMainButtonGrid.RowHeight = {'1x'};
app.UIMainButtonGrid.ColumnWidth = {100, 100, '1x', 100, 100, 100};

app.UIDropdownGrid.Layout.Row = 1; app.UIDropdownGrid.Layout.Column = 1;
app.UIAxes.Layout.Row = 2; app.UIAxes.Layout.Column = 1;

app.UIOptionButtonGrid.Layout.Row = 3; app.UIOptionButtonGrid.Layout.Column = 1;
app.UILabel.Layout.Row = 4; app.UILabel.Layout.Column = 1;
app.UITable.Layout.Row = 5; app.UITable.Layout.Column = 1;
app.UIMainButtonGrid.Layout.Row = 6; app.UIMainButtonGrid.Layout.Column = 1;

app.UILabelName.Layout.Row = 1; app.UILabelName.Layout.Column = 1;
app.UIDropdownName.Layout.Row = 1; app.UIDropdownName.Layout.Column = 2;
app.UICheckBoxLegend.Layout.Row = 1; app.UICheckBoxLegend.Layout.Column = 4;

app.UIButtonTimingSet.Layout.Row = 1; app.UIButtonTimingSet.Layout.Column = 1;
app.UIButtonBaseline.Layout.Row = 1; app.UIButtonBaseline.Layout.Column = 2;
app.UIButtonOK.Layout.Row = 1; app.UIButtonOK.Layout.Column = 4;
app.UIButtonCancel.Layout.Row = 1; app.UIButtonCancel.Layout.Column = 5;


app.UIButtonFittingSet.Layout.Row = 1; app.UIButtonFittingSet.Layout.Column = 1;
app.UIButtonFit.Layout.Row = 1; app.UIButtonFit.Layout.Column = 2;
app.UIButtonReport.Layout.Row = 1; app.UIButtonReport.Layout.Column = 4; 
app.UIButtonExport.Layout.Row = 1; app.UIButtonExport.Layout.Column = 5; 
app.UIButtonClose.Layout.Row = 1; app.UIButtonClose.Layout.Column = 6;

% Button Pushed functions
app.UIDropdownName.ValueChangedFcn = @(src, event) UIDropdownNameValueChangedFunction(src, event, app.UIFigure.UserData.Analyte, app);
app.UICheckBoxLegend.ValueChangedFcn = @(src, event) UICheckBoxLegendValueChangedFunction(src, event, app);
app.UIButtonTimingSet.ButtonPushedFcn = @(src, event) TimingButtonPushed(src, event, app, app.UIFigure.UserData.Analyte);
app.UIButtonBaseline.ButtonPushedFcn = @(src, event) BaselineButtonPushed(src, event, app, app.UIFigure.UserData.Analyte);
app.UIButtonOK.ButtonPushedFcn = @(src, event) OKButtonPushedFunction(src, event, app);
app.UIButtonCancel.ButtonPushedFcn = @(src, event) CancelButtonPushedFunction(src, event, app);

app.UIButtonFittingSet.ButtonPushedFcn = @(src, event) FittingSetButtonPushed(src, event, app);
app.UIButtonFit.ButtonPushedFcn = @(src, event) FitButtonPushed(src, event, app);
app.UIButtonReport.ButtonPushedFcn = @(src, event) ReportButtonPushed(src, event, app);
app.UIButtonClose.ButtonPushedFcn = @(src, event) CloseButtonPushed(src, event, app);
app.UIButtonExport.ButtonPushedFcn = @(src, event) ExportButtonPushed(src, event, app);


end



function OKButtonPushedFunction(src, event, app)

set(findobj(app.UIFigure, 'type', 'uibutton'), 'Enable', 'On')
set(findobj(app.UIFigure, 'type', 'uidropdown'), 'Enable', 'On')
app.UIButtonOK.Visible = 'Off'; app.UIButtonOK.Enable = 'Off';
app.UIButtonCancel.Visible = 'Off'; app.UIButtonCancel.Enable = 'Off';
analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));
analyte = app.UIFigure.UserData.Analyte(analyteNo);

if strcmp(src.UserData, app.UIButtonTimingSet.Text)
    app.UIFigure.UserData.Analyte(analyteNo).EventTime =...
    round([app.UIButtonTimingSet.UserData.lineAsStart.Position(1),...
    app.UIButtonTimingSet.UserData.lineAsEnd.Position(1), ...
    app.UIButtonTimingSet.UserData.lineDisStart.Position(1), ...
    app.UIButtonTimingSet.UserData.lineDisEnd.Position(1)]);

    app.UIFigure.UserData.MarkAsStart.Position(1) = app.UIButtonTimingSet.UserData.lineAsStart.Position(1);
    app.UIFigure.UserData.MarkAsEnd.Position(1) = app.UIButtonTimingSet.UserData.lineAsEnd.Position(1);
    app.UIFigure.UserData.MarkDisStart.Position(1) = app.UIButtonTimingSet.UserData.lineDisStart.Position(1);
    app.UIFigure.UserData.MarkDisEnd.Position(1) = app.UIButtonTimingSet.UserData.lineDisEnd.Position(1);
    
    delete(app.UIButtonTimingSet.UserData.lineAsStart)
    delete(app.UIButtonTimingSet.UserData.lineAsEnd)
    delete(app.UIButtonTimingSet.UserData.lineDisStart)
    delete(app.UIButtonTimingSet.UserData.lineDisEnd)
elseif strcmp(src.UserData, app.UIButtonBaseline.Text)    
    analyte.YData = [];    
    
    if app.UIButtonBaseline.UserData.lineBaseline.Position(1) > analyte.XData(end)
        app.UIButtonBaseline.UserData.lineBaseline.Position(1) = analyte.XData(end);
        app.UIButtonBaseline.UserData.lineBaseline.Position(2) = analyte.XData(end);
    elseif app.UIButtonBaseline.UserData.lineBaseline.Position(1) < analyte.XData(1)
        app.UIButtonBaseline.UserData.lineBaseline.Position(1) = analyte.XData(1);
        app.UIButtonBaseline.UserData.lineBaseline.Position(2) = analyte.XData(1);
    end

    for ii = 1:length(analyte.Data)                
        analyte.Data{ii}.y = analyte.Data{ii}.y - analyte.Data{ii}.y(round(app.UIButtonBaseline.UserData.lineBaseline.Position(1)));
        analyte.RmaxCandidate(ii, 1) = analyte.Data{ii, 1}.y(analyte.Data{ii, 1}.x == analyte.EventTime(3));                
        analyte.YData = [analyte.YData; analyte.Data{ii, 1}.y];
    end

    analyte.Baseline = app.UIButtonBaseline.UserData.lineBaseline.Position(1);
    delete(app.UIButtonBaseline.UserData.lineBaseline)
    app.UIFigure.UserData.Analyte(analyteNo) = analyte;
    UIDropdownNameValueChangedFunction(app.UIDropdownName, [], app.UIFigure.UserData.Analyte, app)
end

end


function CancelButtonPushedFunction(src, event, app)

src = app.UIButtonOK;

set(findobj(app.UIFigure, 'type', 'uibutton'), 'Enable', 'On')
set(findobj(app.UIFigure, 'type', 'uidropdown'), 'Enable', 'On')
app.UIButtonOK.Visible = 'Off'; app.UIButtonOK.Enable = 'Off';
app.UIButtonCancel.Visible = 'Off'; app.UIButtonCancel.Enable = 'Off';

if strcmp(src.UserData, app.UIButtonTimingSet.Text)
    delete(app.UIButtonTimingSet.UserData.lineAsStart)
    delete(app.UIButtonTimingSet.UserData.lineAsEnd)
    delete(app.UIButtonTimingSet.UserData.lineDisStart)
    delete(app.UIButtonTimingSet.UserData.lineDisEnd)
elseif strcmp(src.UserData, app.UIButtonBaseline.Text)
    delete(app.UIButtonBaseline.UserData.lineBaseline)
end

end



function UIDropdownNameValueChangedFunction(src, event, analyte, app)

src = app.UIDropdownName;
cla(app.UIAxes);
analyteNo = find(strcmp(src.Items, src.Value));
concentrationUnit = analyte(analyteNo).ConcentrationUnit{1};
[concentration, concentrationUnit] = FindConcentrationUnit(analyte(analyteNo).Concentration, concentrationUnit);

linePlot.Raw = [];
linePlot.RawString = [];
linePlot.Fitted = [];
linePlot.FittedString = [];
for i = 1:size(analyte(analyteNo).Data, 1)
    hold(app.UIAxes, 'on');
    linePlot.Raw(end+1) = plot(app.UIAxes,...
        analyte(analyteNo).Data{i, 1}.x,...
        analyte(analyteNo).Data{i, 1}.y);
    linePlot.RawString{end+1} = strcat(concentration{i}, concentrationUnit);
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
    linePlot.Fitted(end+1) = plot(app.UIAxes,...
        analyte(analyteNo).FittedT(:, i),...
        analyte(analyteNo).FittedR(:, i),...
        'color', 'black');
    linePlot.FittedString{end+1} = strcat(concentration{i}, concentrationUnit, '(Fitted)');
end

app.UIFigure.UserData.Legend = legend(app.UIAxes,...
    [flip(linePlot.Raw) flip(linePlot.Fitted)],...
    [flip(linePlot.RawString) flip(linePlot.FittedString)]);
app.UIFigure.UserData.Legend.ContextMenu = '';
app.UIFigure.UserData.Legend.ItemHitFcn = @(src, event)LegendItemHitFcn(src, event);
app.UIFigure.UserData.Legend.Orientation = 'horizontal';
app.UIFigure.UserData.Legend.Location = 'northoutside';
app.UIFigure.UserData.Legend.NumColumns = 5;
app.UIFigure.UserData.Legend.FontSize = 9.5;
UICheckBoxLegendValueChangedFunction([], [], app);
axtoolbar(app.UIAxes, {'pan', 'zoomin', 'zoomout', 'restoreview', 'export'});

% Table display (koff, kon, Rmax, KA, KD)
currentModel = analyte(analyteNo).FittingVariable.FittingModel;
kVars = analyte(analyteNo).FittingVariable.(currentModel).Name;
kResult = cell(size(kVars, 1), 1);
for i = 1:size(kResult, 1)    
    kResult{i, 1} = zeros(size(analyte(analyteNo).Concentration, 1), 1);
    tmpIdx = contains(analyte(analyteNo).kName, analyte(analyteNo).kName{i});
    kResult{i, 1}(:, 1) = analyte(analyteNo).k(tmpIdx);    
end

numericKD = kResult{2, 1} ./ kResult{1, 1};
numericKA = kResult{1, 1} ./ kResult{2, 1};
numericChi2 = ones(size(analyte(analyteNo).Concentration, 1), 1) * analyte(analyteNo).chi2;

for i = 1:size(kVars, 1)
    variable.(kVars{i, 1}) = cell(size(analyte(analyteNo).Concentration, 1), 1);
    if strcmp(kVars{i, 1}, 'kon') || strcmp(kVars{i, 1}, 'koff') || strcmp(kVars{i, 1}, 'kt')
        varType = '%0.2e';
    elseif strcmp(kVars{i, 1}, 'Rmax') || strcmp(kVars{i, 1}, 'BI')
        varType = '%0.2f';
    end
    for ii = 1:size(analyte(analyteNo).Concentration, 1)
        variable.(kVars{i, 1}){ii, 1} = sprintf(varType, kResult{i, 1}(ii, 1));
        variable.KD{ii, 1} = sprintf('%0.2e', numericKD(ii, 1));
        variable.KA{ii, 1} = sprintf('%0.2e', numericKA(ii, 1));
        variable.chi2{ii, 1} = sprintf('%0.2f', numericChi2(ii, 1));
    end
end

for i = 1:size(analyte(analyteNo).Concentration, 1)        
    variable.KD{i, 1} = sprintf('%0.2e', numericKD(i, 1));
    variable.KA{i, 1} = sprintf('%0.2e', numericKA(i, 1));
    variable.chi2{i, 1} = sprintf('%0.2f', numericChi2(i, 1));
end

if isempty(analyte(analyteNo).chi2); analyte(analyteNo).chi2 = NaN; end

if strcmp(currentModel, 'OneToOneStandard')
    app.UITable.Data = table(concentration, variable.KD, variable.kon, variable.koff, variable.Rmax, variable.KA, variable.BI, variable.chi2);
    app.UITable.ColumnName = cell(1, 8);
    app.UITable.ColumnName{1} = strcat('Concentration (', concentrationUnit, ')');
    app.UITable.ColumnName{2} = 'KD (M)';
    app.UITable.ColumnName{3} = 'kon (1/(M*s))';
    app.UITable.ColumnName{4} = 'koff (1/s)';
    app.UITable.ColumnName{5} = 'Rmax (RU)';
    app.UITable.ColumnName{6} = 'KA (1/M)';
    app.UITable.ColumnName{7} = 'BI (RU)';
    app.UITable.ColumnName{8} = 'Chi2 (RU^2)';
elseif strcmp(currentModel, 'OneToOneMassTransfer')
    app.UITable.Data = table(concentration, variable.KD, variable.kon, variable.koff, variable.kt, variable.Rmax, variable.KA, variable.BI, variable.chi2);
    app.UITable.ColumnName = cell(1, 9);
    app.UITable.ColumnName{1} = strcat('Concentration (', concentrationUnit, ')');
    app.UITable.ColumnName{2} = 'KD (M)';
    app.UITable.ColumnName{3} = 'kon (1/(M*s))';
    app.UITable.ColumnName{4} = 'koff (1/s)';
    app.UITable.ColumnName{5} = 'kt (RU/Ms)';
    app.UITable.ColumnName{6} = 'Rmax (RU)';
    app.UITable.ColumnName{7} = 'KA (1/M)';
    app.UITable.ColumnName{8} = 'BI (RU)';
    app.UITable.ColumnName{9} = 'Chi2 (RU^2)';
end

end


function UICheckBoxLegendValueChangedFunction(src, event, app)
    
try
    app.UIFigure.UserData.Legend.Visible = app.UICheckBoxLegend.Value;
    app.UIFigure.UserData.Legend.Location = 'northoutside';
catch
    disp('Checkbox Error!')
end

end

function [concStr, unit] = FindConcentrationUnit(concentration, concentrationUnit)

% Giga ~ ato    
    unitNames = {'GM', 'MM', 'KM', 'M', 'mM', 'uM', 'nM', 'pM', 'fM', 'aM'};
    unitDigitCriteria = [9 6 3 0 -3 -6 -9 -12 -15 -18];    
    
    if isempty(concentrationUnit)
        logConc = log10(concentration);
        digitConc = round(round(min(logConc(~isinf(logConc))))/3) * 3;
        [~, idx] = min(abs(digitConc - unitDigitCriteria));
    else
        idx = find(matches(unitNames, concentrationUnit));
    end
    unitDigit = unitDigitCriteria(idx);        
    unit = (unitNames{idx});
    concNum = concentration / 10^unitDigit;
    concStr = cell(length(concNum), 1);
    
    for i = 1:length(concNum)
        concStr{i, 1} = sprintf('%0.2f', concNum(i));
    end
end

function TimingButtonPushed(src, event, app, analyte)

app.UIButtonOK.UserData = src.Text;

src = app.UIButtonTimingSet;
analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));

% Disable buttons and dropdowns
set(findobj(app.UIFigure, 'type', 'uibutton'), 'Enable', 'Off')
set(findobj(app.UIFigure, 'type', 'uidropdown'), 'Enable', 'Off')

% Visualize OK button
app.UIButtonOK.Visible = 'On'; app.UIButtonOK.Enable = 'On';
app.UIButtonCancel.Visible = 'On'; app.UIButtonCancel.Enable = 'On';

UIAxes = app.UIAxes;
xLim = [analyte(analyteNo).XData(1), analyte(analyteNo).XData(end)]; 
yMag = abs(app.UIAxes.YLim(1) - app.UIAxes.YLim(2));
yLim = [-yMag yMag] * app.UIFigure.UserData.LineExpandRatio;

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

    srcType = {'Association Start', 'Association End', 'Dissociation Start', 'Dissociation End'};    

    if strcmp(lineSrc.Label, srcType{1})
        limitPos = [xLim(1)-1, app.UIButtonTimingSet.UserData.lineAsEnd.Position(1)];
        margin = [1 5];
    elseif strcmp(lineSrc.Label, srcType{2})
        limitPos = [app.UIButtonTimingSet.UserData.lineAsStart.Position(1), app.UIButtonTimingSet.UserData.lineDisStart.Position(1)];
        margin = [5 1];
    elseif strcmp(lineSrc.Label, srcType{3})
        limitPos = [app.UIButtonTimingSet.UserData.lineAsEnd.Position(1), app.UIButtonTimingSet.UserData.lineDisEnd.Position(1)];
        margin = [1 5];
    elseif strcmp(lineSrc.Label, srcType{4})
        limitPos = [app.UIButtonTimingSet.UserData.lineDisStart.Position(1), xLim(2)+1];
        margin = [5 1];
    end

    if lineSrc.Position(1) <= limitPos(1)
        lineSrc.Position(1) = limitPos(1) + margin(1);
        lineSrc.Position(2) = lineSrc.Position(1);
    elseif lineSrc.Position(1) >= limitPos(2)
        lineSrc.Position(1) = limitPos(2) - margin(2);
        lineSrc.Position(2) = lineSrc.Position(1);
    end

    SetDrawingArea(UserData, xLim)
end

function SetDrawingArea(UserData, xLim)
    UserData.lineAsStart.DrawingArea =...
        [xLim(1), 0,...
        UserData.lineAsEnd.Position(1)-xLim(1)-5, 0];
    UserData.lineAsEnd.DrawingArea =...
        [UserData.lineAsStart.Position(1)+5, 0,...
        UserData.lineDisStart.Position(1)-UserData.lineAsStart.Position(1)-1, 0];
    UserData.lineDisStart.DrawingArea =...
        [UserData.lineAsEnd.Position(1)+1, 0,...
        UserData.lineDisEnd.Position(1) - UserData.lineAsEnd.Position(1) - 5, 0];
    UserData.lineDisEnd.DrawingArea =...
        [UserData.lineDisStart.Position(1)+1, 0,...
        xLim(2) - UserData.lineDisStart.Position(1), 0];
end

end

function BaselineButtonPushed(src, event, app, analyte)

app.UIButtonOK.UserData = src.Text;
analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));

% Disable buttons and dropdowns
set(findobj(app.UIFigure, 'type', 'uibutton'), 'Enable', 'Off')
set(findobj(app.UIFigure, 'type', 'uidropdown'), 'Enable', 'Off')

% Visualize OK button
app.UIButtonOK.Visible = 'On'; app.UIButtonOK.Enable = 'On';
app.UIButtonCancel.Visible = 'On'; app.UIButtonCancel.Enable = 'On';

UIAxes = app.UIAxes;
xLim = [analyte(analyteNo).XData(1), analyte(analyteNo).XData(end)]; 
yMag = abs(app.UIAxes.YLim(1) - app.UIAxes.YLim(2));
yLim = [-yMag yMag] * app.UIFigure.UserData.LineExpandRatio;

baselinePos = [analyte(analyteNo).Baseline, yLim(1);...
    analyte(analyteNo).Baseline, yLim(2)];
src.UserData.lineBaseline = drawline('Parent', UIAxes,...
     'Position', baselinePos, ...
     'Deletable', 0, ...
     'InteractionsAllowed', 'translate', ...
     'Label', 'Baseline', ...
     'LabelVisible', 'hover', ...
     'Color', [0 0 0], ...
     'LineWidth', 2);
 
src.UserData.lineBaseline.DrawingArea =...
        [xLim(1), 0,...
        xLim(2), 0];

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

fittingSetApp = FittingSet(app);
waitfor(fittingSetApp.UIFigure)

analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));
currentAnalyte = getappdata(app.UIFigure, 'currentAnalyte');

if ~isempty(currentAnalyte)
    app.UIFigure.UserData.Analyte(analyteNo) = currentAnalyte;
end

end

function ReportButtonPushed(src, event, app)
    filter = {'PDF file *.pdf'};
    defPath = app.UIFigure.UserData.ResultFilePath;    
    analyte = app.UIFigure.UserData.Analyte;
    analyteNo = find(strcmp(app.UIDropdownName.Items, app.UIDropdownName.Value));
    defName = strcat(analyte(analyteNo).Name, '_Report');
    [file, path] = uiputfile(filter, 'Save Report File', fullfile(defPath, defName));

    if isequal(file, 0) || isequal(path, 0)
        return;
    end
    
    GenerateReport(app, fullfile(path, file));
    app.UIFigure.UserData.ResultFilePath = path;

end

function ExportButtonPushed(src, event, app)

selPath = uigetdir(app.UIFigure.UserData.ResultFilePath, 'Save folder');
if isequal(selPath, 0); return; end

formatOut = 'yymmddHHMMSS';
dateStr = datestr(now, formatOut);
extension = 'txt';

for i = 1:size(app.UIFigure.UserData.Analyte, 2)    
    analyteName = MakeProperFolderName(app.UIFigure.UserData.Analyte(i).Name);
    pathName = fullfile(selPath, dateStr, analyteName);
    mkdir(pathName);
    
    fileName = fullfile(pathName, strcat('Calculated_Constants', '.', extension));
    resultCell = table2cell(app.UITable.Data);    
    resultHeader = app.UITable.ColumnName';
    resultCell = [resultHeader; resultCell];
    writecell(resultCell, fileName, 'Delimiter', 'tab');
    [concStr, unit] = FindConcentrationUnit(app.UIFigure.UserData.Analyte(i).Concentration, app.UIFigure.UserData.Analyte(i).ConcentrationUnit{1});
    
    for ii = 1:size(app.UIFigure.UserData.Analyte(i).Data, 1)
        fileNameRawData = strcat('Raw_', concStr{ii}, unit, '.', extension);
        writetable(app.UIFigure.UserData.Analyte(i).Data{ii}, fullfile(pathName, fileNameRawData), 'Delimiter', 'tab')
        
        fileNameFittedData = strcat('Fitted_', concStr{ii}, unit, '.', extension);
        x = app.UIFigure.UserData.Analyte(i).FittedT(:, ii);
        y = app.UIFigure.UserData.Analyte(i).FittedR(:, ii);
        fittedDataTable = table(x, y);
        writetable(fittedDataTable, fullfile(pathName, fileNameFittedData), 'Delimiter', 'tab')
    end
end
app.UIFigure.UserData.ResultFilePath = selPath;
winopen(fullfile(selPath, dateStr))

end

function CloseButtonPushed(src, event, app)

delete(app.UIFigure);

end

function properStr = MakeProperFolderName(inputStr)

if ~ischar(inputStr)
    disp('Input type should be char!')
    properStr = inputStr;
    return
end

properStr = ...
    inputStr((inputStr~='\')&(inputStr~='/')...
    &(inputStr~=':')&(inputStr~='*')...
    &(inputStr~='?')&(inputStr~='"')...
    &(inputStr~='<')&(inputStr~='>')...
    &(inputStr~='|'));

end


function LegendItemHitFcn(src, event)

if strcmp(event.SelectionType, 'normal')
    if event.Peer.LineWidth == 2
        event.Peer.LineWidth = 0.5;
    else
        event.Peer.LineWidth = 2;
    end
end

end