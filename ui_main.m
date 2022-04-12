close force all
% Create UIFigure and hide until all components are created
app.UIFigure = uifigure(1);
clf(app.UIFigure);
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100 100 1083 665];
app.UIFigure.Name = 'iMPick';

% Create FileMenu
app.FileMenu = uimenu(app.UIFigure);
app.FileMenu.Text = 'File';

% Create SaveProjectMenu
app.SaveProjectMenu = uimenu(app.FileMenu);
app.SaveProjectMenu.Text = 'Save Project';

% Create LoadProjectMenu
app.LoadProjectMenu = uimenu(app.FileMenu);
app.LoadProjectMenu.Text = 'Load Project';

% Create ExitMenu
app.ExitMenu = uimenu(app.FileMenu);
app.ExitMenu.Separator = 'on';
app.ExitMenu.Text = 'Exit';

% Create DataMenu
app.DataMenu = uimenu(app.UIFigure);
app.DataMenu.Text = 'Data';

% Create AddMenu
app.AddMenu = uimenu(app.DataMenu);
app.AddMenu.Text = 'Add';

% Create iMSPRminiDataMenu
app.iMSPRminiDataMenu = uimenu(app.AddMenu);
app.iMSPRminiDataMenu.Text = 'iMSPR-mini Data';

% Create iMSPRProDataMenu
app.iMSPRProDataMenu = uimenu(app.AddMenu);
app.iMSPRProDataMenu.Text = 'iMSPR-Pro Data';

% Create BiacoreDataMenu
app.BiacoreDataMenu = uimenu(app.AddMenu);
app.BiacoreDataMenu.Text = 'Biacore Data';

% Create ExportMenu
app.ExportMenu = uimenu(app.DataMenu);
app.ExportMenu.Text = 'Export';

% Create DisplayedSensorgramsMenu
app.DisplayedSensorgramsMenu = uimenu(app.ExportMenu);
app.DisplayedSensorgramsMenu.Text = 'Displayed Sensorgram(s)';

% Create AllSensorgramsMenu
app.AllSensorgramsMenu = uimenu(app.ExportMenu);
app.AllSensorgramsMenu.Text = 'All Sensorgrams';

% Create AboutMenu
app.AboutMenu = uimenu(app.UIFigure);
app.AboutMenu.Text = 'About';

% Create HelpMenu
app.HelpMenu = uimenu(app.AboutMenu);
app.HelpMenu.Text = 'Help';

% Create VersionMenu
app.VersionMenu = uimenu(app.AboutMenu);
app.VersionMenu.Text = 'Version';

% Create WebsiteMenu
app.WebsiteMenu = uimenu(app.AboutMenu);
app.WebsiteMenu.Text = 'Website';

% Create MainGridLayout
app.MainGridLayout = uigridlayout(app.UIFigure);
app.MainGridLayout.ColumnWidth = {'1x', 300};
app.MainGridLayout.RowHeight = {'1x'};
app.MainGridLayout.ColumnSpacing = 20;
app.MainGridLayout.RowSpacing = 0;
app.MainGridLayout.Padding = [20 20 20 20];

% Create RightGridLayout
app.RightGridLayout = uigridlayout(app.MainGridLayout);
app.RightGridLayout.ColumnWidth = {'1x'};
app.RightGridLayout.RowHeight = {35, '1x'};
app.RightGridLayout.ColumnSpacing = 0;
app.RightGridLayout.RowSpacing = 0;
app.RightGridLayout.Padding = [0 5 0 5];
app.RightGridLayout.Layout.Row = 1;
app.RightGridLayout.Layout.Column = 2;

% Create TableButtonGridLayout
app.TableButtonGridLayout = uigridlayout(app.RightGridLayout);
app.TableButtonGridLayout.ColumnWidth = {100, '1x', 25, 25, 25, 30};
app.TableButtonGridLayout.RowHeight = {25};
app.TableButtonGridLayout.ColumnSpacing = 5;
app.TableButtonGridLayout.RowSpacing = 0;
app.TableButtonGridLayout.Padding = [0 0 0 0];
app.TableButtonGridLayout.Layout.Row = 1;
app.TableButtonGridLayout.Layout.Column = 1;

% Create CheckBox
app.CheckBox = uicheckbox(app.TableButtonGridLayout);
app.CheckBox.Text = '';
app.CheckBox.Layout.Row = 1;
app.CheckBox.Layout.Column = 6;
app.CheckBox.Value = 1;

% Create DelButton
app.DelButton = uibutton(app.TableButtonGridLayout, 'push');
app.DelButton.Layout.Row = 1;
app.DelButton.Layout.Column = [3 5];
app.DelButton.Text = 'Delete';

% Create SortButton
app.SortButton = uibutton(app.TableButtonGridLayout, 'push');
app.SortButton.Layout.Row = 1;
app.SortButton.Layout.Column = 1;
app.SortButton.Text = 'Sort (1,2,3...)';

% Create UITable
app.UITable = uitable(app.RightGridLayout);
app.UITable.ColumnName = {'Index'; 'ID'; 'Type'; 'Display'};
app.UITable.RowName = {};
app.UITable.Layout.Row = 2;
app.UITable.Layout.Column = 1;
alignRight = uistyle('HorizontalAlignment', 'right');
addStyle(app.UITable, alignRight);

% Create ContextMenu to UITable
app.UIContextMenuUITable = uicontextmenu(app.UIFigure);
app.UITableContextMenuNumbering = uimenu(app.UIContextMenuUITable, "Text", 'Numbering index from selected row');
app.UITableContextMenuMove = uimenu(app.UIContextMenuUITable, "Text", "Move this curve");
app.UITable.ContextMenu = app.UIContextMenuUITable;

% Create LeftGridLayout
app.LeftGridLayout = uigridlayout(app.MainGridLayout);
app.LeftGridLayout.ColumnWidth = {'1x'};
app.LeftGridLayout.ColumnSpacing = 0;
app.LeftGridLayout.RowSpacing = 0;
app.LeftGridLayout.Padding = [0 0 0 0];
app.LeftGridLayout.Layout.Row = 1;
app.LeftGridLayout.Layout.Column = 1;

% Create TopGridLayout
app.TopGridLayout = uigridlayout(app.LeftGridLayout);
app.TopGridLayout.ColumnWidth = {'1x'};
app.TopGridLayout.RowHeight = {30, '1x'};
app.TopGridLayout.ColumnSpacing = 0;
app.TopGridLayout.RowSpacing = 0;
app.TopGridLayout.Padding = [0 0 0 0];
app.TopGridLayout.Layout.Row = 1;
app.TopGridLayout.Layout.Column = 1;

% Create SensorgramUIAxes
app.SensorgramUIAxes = uiaxes(app.TopGridLayout);
title(app.SensorgramUIAxes, 'Sensorgram')
xlabel(app.SensorgramUIAxes, 'Time (s)')
ylabel(app.SensorgramUIAxes, 'Signal (RU)')
zlabel(app.SensorgramUIAxes, 'Z')
app.SensorgramUIAxes.Layout.Row = 2;
app.SensorgramUIAxes.Layout.Column = 1;

% Create ReferencingGridLayout
app.ReferencingGridLayout = uigridlayout(app.TopGridLayout);
app.ReferencingGridLayout.ColumnWidth = {150, 100, 100, '1x', 150, 100};
app.ReferencingGridLayout.RowHeight = {'1x'};
app.ReferencingGridLayout.ColumnSpacing = 5;
app.ReferencingGridLayout.RowSpacing = 0;
app.ReferencingGridLayout.Padding = [0 0 0 0];
app.ReferencingGridLayout.Layout.Row = 1;
app.ReferencingGridLayout.Layout.Column = 1;

% Create BaselineSpinnerLabel
app.BaselineSpinnerLabel = uilabel(app.ReferencingGridLayout);
app.BaselineSpinnerLabel.HorizontalAlignment = 'right';
app.BaselineSpinnerLabel.Layout.Row = 1;
app.BaselineSpinnerLabel.Layout.Column = 1;
app.BaselineSpinnerLabel.Text = 'Base line (s) :';

% Create BaselineSpinner
app.BaselineSpinner = uispinner(app.ReferencingGridLayout);
app.BaselineSpinner.ValueDisplayFormat = '%.0f';
app.BaselineSpinner.RoundFractionalValues = 'on';
app.BaselineSpinner.HorizontalAlignment = 'right';
app.BaselineSpinner.Layout.Row = 1;
app.BaselineSpinner.Layout.Column = 2;
app.BaselineSpinner.Value = 1;

% Create ApplyButton
app.ApplyButton = uibutton(app.ReferencingGridLayout);
app.ApplyButton.Text = 'Apply';
app.ApplyButton.HorizontalAlignment = 'center';
app.ApplyButton.Layout.Row = 1;
app.ApplyButton.Layout.Column = 3;

% Create ReferencingDropDownLabel
app.ReferencingDropDownLabel = uilabel(app.ReferencingGridLayout);
app.ReferencingDropDownLabel.HorizontalAlignment = 'right';
app.ReferencingDropDownLabel.Layout.Row = 1;
app.ReferencingDropDownLabel.Layout.Column = 5;
app.ReferencingDropDownLabel.Text = 'Referencing :';

% Create ReferencingDropDown
app.ReferencingDropDown = uidropdown(app.ReferencingGridLayout);
app.ReferencingDropDown.Items = {'None', 'N-T-N-T', 'T-N-T-N'};
app.ReferencingDropDown.Layout.Row = 1;
app.ReferencingDropDown.Layout.Column = 6;
app.ReferencingDropDown.Value = 'None';

% Create BottomGridLayout
app.BottomGridLayout = uigridlayout(app.LeftGridLayout);
app.BottomGridLayout.ColumnWidth = {200, 40, '1x'};
app.BottomGridLayout.RowHeight = {'1x'};
app.BottomGridLayout.ColumnSpacing = 5;
app.BottomGridLayout.RowSpacing = 0;
app.BottomGridLayout.Padding = [5 5 5 5];
app.BottomGridLayout.Layout.Row = 2;
app.BottomGridLayout.Layout.Column = 1;

% Create RunButton
app.RunButton = uibutton(app.BottomGridLayout, 'push');
app.RunButton.Layout.Row = 1;
app.RunButton.Layout.Column = 2;
app.RunButton.Text = '>>';

% Create PreviewGridLayout
app.PreviewGridLayout = uigridlayout(app.BottomGridLayout);
app.PreviewGridLayout.ColumnWidth = {'1x'};
app.PreviewGridLayout.RowHeight = {'1x', 35};
app.PreviewGridLayout.ColumnSpacing = 0;
app.PreviewGridLayout.RowSpacing = 5;
app.PreviewGridLayout.Padding = [0 0 0 0];
app.PreviewGridLayout.Layout.Row = 1;
app.PreviewGridLayout.Layout.Column = 3;

% Create PreviewUIAxes
app.PreviewUIAxes = uiaxes(app.PreviewGridLayout);
title(app.PreviewUIAxes, 'Preview')
xlabel(app.PreviewUIAxes, 'Index')
ylabel(app.PreviewUIAxes, 'Result (RU)')
zlabel(app.PreviewUIAxes, 'Z')
app.PreviewUIAxes.Layout.Row = 1;
app.PreviewUIAxes.Layout.Column = 1;

% Create DetailedviewButton
app.DetailedviewButton = uibutton(app.PreviewGridLayout, 'push');
app.DetailedviewButton.Layout.Row = 2;
app.DetailedviewButton.Layout.Column = 1;
app.DetailedviewButton.Text = 'Detailed view';

% Create SettingGridLayout
app.SettingGridLayout = uigridlayout(app.BottomGridLayout);
app.SettingGridLayout.ColumnWidth = {'1x', 100};
app.SettingGridLayout.RowHeight = {25, 25, '3x', '2x'};
app.SettingGridLayout.ColumnSpacing = 5;
app.SettingGridLayout.RowSpacing = 5;
app.SettingGridLayout.Padding = [0 0 0 0];
app.SettingGridLayout.Layout.Row = 1;
app.SettingGridLayout.Layout.Column = 1;

% Create StartPointSpinnerLabel
app.StartPointSpinnerLabel = uilabel(app.SettingGridLayout);
app.StartPointSpinnerLabel.HorizontalAlignment = 'right';
app.StartPointSpinnerLabel.Layout.Row = 1;
app.StartPointSpinnerLabel.Layout.Column = 1;
app.StartPointSpinnerLabel.Text = 'Start Point (s) :';

% Create StartPointSpinner
app.StartPointSpinner = uispinner(app.SettingGridLayout);
app.StartPointSpinner.ValueDisplayFormat = '%.0f';
app.StartPointSpinner.Layout.Row = 1;
app.StartPointSpinner.Layout.Column = 2;
app.StartPointSpinner.Value = 1;

% Create EndPointSpinnerLabel
app.EndPointSpinnerLabel = uilabel(app.SettingGridLayout);
app.EndPointSpinnerLabel.HorizontalAlignment = 'right';
app.EndPointSpinnerLabel.Layout.Row = 2;
app.EndPointSpinnerLabel.Layout.Column = 1;
app.EndPointSpinnerLabel.Text = 'End Point (s) :';

% Create EndPointSpinner
app.EndPointSpinner = uispinner(app.SettingGridLayout);
app.EndPointSpinner.ValueDisplayFormat = '%.0f';
app.EndPointSpinner.Layout.Row = 2;
app.EndPointSpinner.Layout.Column = 2;
app.EndPointSpinner.Value = 1;

% Create MethodButtonGroup
app.MethodButtonGroup = uibuttongroup(app.SettingGridLayout);
app.MethodButtonGroup.Title = 'Method';
app.MethodButtonGroup.Layout.Row = 3;
app.MethodButtonGroup.Layout.Column = [1 2];

% Create RUYendYstartButton
app.RUYendYstartButton = uiradiobutton(app.MethodButtonGroup);
app.RUYendYstartButton.Text = 'ΔRU (Yend - Ystart)';
app.RUYendYstartButton.Position = [11 97 127 22];
app.RUYendYstartButton.Value = true;

% Create AveragingYstartYendButton
app.AveragingYstartYendButton = uiradiobutton(app.MethodButtonGroup);
app.AveragingYstartYendButton.Text = 'Averaging (Ystart ~ Yend)';
app.AveragingYstartYendButton.Position = [11 75 159 22];

% Create DriftLinearfitButton
app.DriftLinearfitButton = uiradiobutton(app.MethodButtonGroup);
app.DriftLinearfitButton.Text = 'Drift (Linear fit)';
app.DriftLinearfitButton.Position = [11 53 101 22];

% Create CorrectionButtonGroup
app.CorrectionButtonGroup = uibuttongroup(app.SettingGridLayout);
app.CorrectionButtonGroup.Title = 'Correction';
app.CorrectionButtonGroup.Layout.Row = 4;
app.CorrectionButtonGroup.Layout.Column = [1 2];

% Create NoneButton
app.NoneButton = uiradiobutton(app.CorrectionButtonGroup);
app.NoneButton.Text = 'None';
app.NoneButton.Position = [11 49 58 22];
app.NoneButton.Value = true;

% Create byPositiveButton
app.byPTPTButton = uiradiobutton(app.CorrectionButtonGroup);
app.byPTPTButton.Text = 'P-T-P-T';
app.byPTPTButton.Position = [11 27 80 22];

% Create byPositiveButton
app.TPTPButton = uiradiobutton(app.CorrectionButtonGroup);
app.TPTPButton.Text = 'T-P-T-P';
app.TPTPButton.Position = [11 5 80 22];

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

% Define Callback
% Menu
app.iMSPRminiDataMenu.MenuSelectedFcn = @(src, event) DataAddMenuSelected(app, src, event);
app.iMSPRProDataMenu.MenuSelectedFcn = @(src, event) DataAddMenuSelected(app, src, event);
app.BiacoreDataMenu.MenuSelectedFcn = @(src, event) DataAddMenuSelected(app, src, event);
app.AllSensorgramsMenu.MenuSelectedFcn = @(src, event) ExportMenuSelected(app, src, event);
app.DisplayedSensorgramsMenu.MenuSelectedFcn = @(src, event) ExportMenuSelected(app, src, event);
app.SaveProjectMenu.MenuSelectedFcn = @(src, event) SaveProjectMenuSelected(app, src, event);
app.LoadProjectMenu.MenuSelectedFcn = @(src, event) LoadProjectMenuSelected(app, src, event);
app.HelpMenu.MenuSelectedFcn = @(src, event) HelpMenuSelected(app, src, event);
app.WebsiteMenu.MenuSelectedFcn = @(src, event) WebsiteMenuSelected(app, src, event);
app.ExitMenu.MenuSelectedFcn = @(src, event) ExitMenuSelected(app, src, event);
% Button
app.DelButton.ButtonPushedFcn = @(src, event) DelButtonPushed(app, src, event);
app.RunButton.ButtonPushedFcn = @(src, event) RunButtonPushed(app, src, event);
app.DetailedviewButton.ButtonPushedFcn = @(src, event) DetailedViewButtonPushed(app, src, event);
app.ApplyButton.ButtonPushedFcn = @(src, event) ApplyButtonPushed(app, src, event);
app.SortButton.ButtonPushedFcn = @(src, event) SortButtonPushed(app, src, event);
% Others
app.UITable.CellEditCallback = @(src, event) UITableCellEdit(app, src, event);
app.UITable.CellSelectionCallback = @(src, event) UITableCellSelection(app, src, event);
app.CheckBox.ValueChangedFcn = @(src, event) CheckBoxValueChanged(app, src, event);
app.ReferencingDropDown.ValueChangedFcn = @(src, event) ReferencingDropDownValueChanged(app, src, event);
app.UITableContextMenuNumbering.MenuSelectedFcn = @(src, event) UITableContextMenuNumberingSelected(app, src, event);
app.UITableContextMenuMove.MenuSelectedFcn = @(src, event) UITableContextMenuMoveSelected(app, src, event);
app.UIFigure.CloseRequestFcn = @(src, event) UIFigureCloseRequest(app, [], []);

%% Variable
app.UIFigure.UserData.CurrentFolder = 'C:/iCLUEB!O/iMPick';
app.UIFigure.UserData.ErrorLog = struct;
app.UIFigure.UserData.ErrorLog.FileName = 'iMPick_error_log';
app.UIFigure.UserData.ErrorLog.FileFolder = 'C:\iCLUEB!O\iMPick\error_logs';
app.UIFigure.UserData.ErrorLog.FilePath =...
    fullfile(app.UIFigure.UserData.ErrorLog.FileFolder,...
    strcat(app.UIFigure.UserData.ErrorLog.FileName,...
    '(', datestr(now, 'yyyy-mm-dd HH-MM-SS'), ')', '.txt'));
app.UIFigure.UserData.LogFileExpireDuration = 3 * 30 * 24;
app.UIFigure.UserData.AddApp = [];
app.UIFigure.UserData.DetailApp = [];
app.UIFigure.UserData.MoveApp = [];
app.UIFigure.UserData.URL = 'www.icluebio.com';
app.UIFigure.UserData.DefaultScatterSize = 10;
app.UIFigure.UserData.HighlightedScatterSize = 50;
app.UIFigure.UserData.DefaultLineWidth = 0.2;
app.UIFigure.UserData.HighlightedLineWidth = 10;
app.UIFigure.UserData.CurrentPath = pwd;
app.UIFigure.UserData.RawCurves = [];
app.UIFigure.UserData.DisplayCurves = [];
app.UIFigure.UserData.CurrentLinePlot = [];
app.UIFigure.UserData.ScatterPlot = [];
app.UIFigure.UserData.DataType.mini = 'iMSPR-mini Data';
app.UIFigure.UserData.DataType.Pro = 'iMSPR-Pro Data';
app.UIFigure.UserData.DataType.Biacore = 'Biacore Data';
app.UIFigure.UserData.Result = [];

%% Start up
WindowPositionToCenter(app.UIFigure, []);

% Make Current Folder            
status = mkdir(app.UIFigure.UserData.CurrentFolder);
if status == 0
    disp('UI_iMPick_StartUp.mlapp make current folder')
end
try
    MakeErrorLogFolder(app)
catch
    disp('MakeErrorLogFolder Error')
end

%% Function
% Callback
function SaveProjectMenuSelected(app, ~, ~)        
    project = struct;
    project.rawCurves = app.UIFigure.UserData.RawCurves;
    project.displayCurves = app.UIFigure.UserData.DisplayCurves;    
    project.tableData = app.UITable.Data;
    project.baseline = app.BaselineSpinner.Value;
    defaultFile = fullfile(app.UIFigure.UserData.CurrentPath, 'screening_project.mat');    
    [file, path] = uiputfile('*.mat', 'Project File', defaultFile); figure(app.UIFigure);
    if isequal(file,0) || isequal(path,0); return; end
    save(fullfile(path, file), 'project');
    app.UIFigure.UserData.CurrentPath = path;
end


function LoadProjectMenuSelected(app, ~, ~)
    [file, path] = uigetfile('*.mat', 'Project File'); figure(app.UIFigure);    
    if isequal(file,0) || isequal(path,0); return; end
    loadVar = load(fullfile(path, file));
    app.UIFigure.UserData.RawCurves = loadVar.project.rawCurves;
    app.UIFigure.UserData.DisplayCurves = loadVar.project.displayCurves;
    app.UITable.Data = loadVar.project.tableData;
    app.BaselineSpinner.Value = loadVar.project.baseline;
    TableBasicSetting(app, [], []);
    CalculateDisplayCurves(app);
    AdjustBaseline(app);
    PlotCurves(app);
    SetPlotVisibility(app);
    SetSpinnerLimits(app);
    cla(app.PreviewUIAxes);
    app.UIFigure.UserData.ScatterPlot = [];
    app.UIFigure.UserData.Result = [];
end


function WebsiteMenuSelected(app, ~, ~)
    try
        web(app.UIFigure.UserData.URL);
    catch
        disp('Web open error');
    end
end


function ExitMenuSelected(app, ~, ~)
    UIFigureCloseRequest(app, [], []);    
end


function DataAddMenuSelected(app, ~, event)
    if ~isempty(app.UIFigure.UserData.AddApp); return; end    
    app.UIFigure.UserData.AddCurves = [];
    if strcmp(event.Source.Text, app.UIFigure.UserData.DataType.mini)
        app.UIFigure.UserData.AddApp = ui_add(app, app.UIFigure.UserData.DataType.mini);
    elseif strcmp(event.Source.Text, app.UIFigure.UserData.DataType.Pro)
        app.UIFigure.UserData.AddApp = ui_add(app, app.UIFigure.UserData.DataType.Pro);
    elseif strcmp(event.Source.Text, app.UIFigure.UserData.DataType.Biacore)
        app.UIFigure.UserData.AddApp = ui_add(app, app.UIFigure.UserData.DataType.Biacore);    
    end
    
    waitfor(app.UIFigure.UserData.AddApp.UIFigure);
    app.UIFigure.UserData.AddApp = [];
    disp('Add app closed')
    
    if isempty(app.UIFigure.UserData.AddCurves)
        return
    end

    prevRawCurve = app.UIFigure.UserData.RawCurves;
    prevDisplayCurve = app.UIFigure.UserData.DisplayCurves;

    app.UIFigure.UserData.RawCurves =...
        [app.UIFigure.UserData.RawCurves; app.UIFigure.UserData.AddCurves];
    app.UIFigure.UserData.DisplayCurves = app.UIFigure.UserData.RawCurves;

    try
        AddTableData(app);
        CalculateDisplayCurves(app);
        AdjustBaseline(app);
        PlotCurves(app);
        SetPlotVisibility(app);
        SetSpinnerLimits(app);
    catch
        app.UIFigure.UserData.RawCurves = prevRawCurve;
        app.UIFigure.UserData.DisplayCurves = prevDisplayCurve;
        disp('Data loading error!')
    end
end


function ExportMenuSelected(app, ~, event)
    selPath = uigetdir(app.UIFigure.UserData.CurrentPath, 'Save folder'); figure(app.UIFigure);
    if isequal(selPath, 0); return; end

    if isempty(app.UITable.Data)
        disp('No data');
        return
    end

    isDisplay = [app.UITable.Data{:, strcmp(app.UITable.ColumnName, 'Display')}];
    if strcmp(event.Source.Text, app.AllSensorgramsMenu.Text)
        isDisplay(:) = true;
    end
    numCurve = sum(isDisplay);
    
    tmpLen = zeros(size(app.UIFigure.UserData.CurrentLinePlot, 1), 1);
    for i = 1:size(app.UIFigure.UserData.CurrentLinePlot, 1)
        tmpLen(i) = size(app.UIFigure.UserData.CurrentLinePlot{i, 1}.YData, 2);
    end
    lenData = max(tmpLen);
    curveData = nan(lenData, numCurve);
    displayedLinePlot = app.UIFigure.UserData.CurrentLinePlot(isDisplay);
    
    for i = 1:size(curveData, 2)
        curveData(1:size(displayedLinePlot{i, 1}.YData, 2), i) = displayedLinePlot{i, 1}.YData;
    end

    colNames = arrayfun(@num2str, [app.UITable.Data{:, 1}], 'UniformOutput', 0);
    colNames = colNames(isDisplay);
    curveTable = array2table(curveData, 'VariableNames', colNames);
    
    formatOut = 'yymmddHHMMSS';
    dateStr = datestr(now, formatOut);
    extension = 'txt';
    
    curveFileName = strcat('curve_data', '_', dateStr, '.', extension);
    fullFile = fullfile(selPath, curveFileName);
    writetable(curveTable, fullFile, 'Delimiter', 'tab')

    if isempty(app.UIFigure.UserData.Result)
        return
    end
    
    type = app.UITable.Data(:, strcmp(app.UITable.ColumnName, 'Type'));
    type = type(isDisplay);
    ID = [app.UITable.Data{:, strcmp(app.UITable.ColumnName, 'ID')}]';
    ID = ID(isDisplay);
    barData = [num2cell(app.UIFigure.UserData.Result(isDisplay, 1)),...
        num2cell(ID),...
        type];    
    indexCell = {'Index', 'ID', 'Type'};
    barTable = cell2table(barData, 'VariableNames', indexCell);
    
    resultFileName = strcat('table_data', '_', dateStr, '.', extension);
    fullFile = fullfile(selPath, resultFileName);
    writetable(barTable, fullFile, 'Delimiter', 'tab')
    app.currentPath = selPath;
    
end


function HelpMenuSelected(~, ~, ~)
    winopen('User Manua d5e86.html');
end


function SortButtonPushed(app, ~, ~)
    if isempty(app.UITable.Data)
        return
    end
    
    tableData = app.UITable.Data;
    idxColumn = [tableData{:, 1}];
    [~, sortIdx] = sort(idxColumn);
    
    app.UITable.Data(sortIdx, :);
    app.UIFigure.UserData.RawCurves = app.UIFigure.UserData.RawCurves(sortIdx, :);
    app.UIFigure.UserData.DisplayCurves = app.UIFigure.UserData.DisplayCurves(sortIdx, :);
    app.UIFigure.UserData.CurrentLinePlot = app.UIFigure.UserData.CurrentLinePlot(sortIdx, :);
    
    app.UITable.Data = tableData(sortIdx, :);
    RenumberingID(app);
end


function UITableCellEdit(app, ~, event)
    indices = event.Indices;    
    if indices(1, 2) == find(strcmp(app.UITable.ColumnName, 'Type'))
        CalculateDisplayCurves(app);
        AdjustBaseline(app);
        PlotCurves(app);
        SetPlotVisibility(app);
        RenumberingID(app);
    elseif indices(1, 2) == find(strcmp(app.UITable.ColumnName, 'Display'))
        SetPlotVisibility(app);
        SetScatterVisibility(app);
    elseif indices(1, 2) == find(strcmp(app.UITable.ColumnName, 'Index'))
        app.UITable.Data{event.Indices(1, 1)} = floor(event.NewData);
    end     
end


function CheckBoxValueChanged(app, ~, ~)
    if isempty(app.UITable.Data)
        return
    end
    value = app.CheckBox.Value;
    for i = 1:size(app.UITable.Data, 1)
        app.UITable.Data{i, strcmp(app.UITable.ColumnName, 'Display')} = value;
    end
    SetPlotVisibility(app);
    SetScatterVisibility(app);
end


function UITableCellSelection(app, ~, ~)
    if isempty(app.UITable.Selection); return; end
    indices = app.UITable.Selection;
    for i = 1:length(app.UIFigure.UserData.CurrentLinePlot)
        if isempty(app.UIFigure.UserData.CurrentLinePlot{i, 1})
            continue;
        end
        app.UIFigure.UserData.CurrentLinePlot{i, 1}.LineWidth = app.UIFigure.UserData.DefaultLineWidth;
    end
    if indices(1, 2) ~= 1
        return;
    end
    if ~isempty(app.UIFigure.UserData.CurrentLinePlot{indices(1), 1})
        app.UIFigure.UserData.CurrentLinePlot{indices(1), 1}.LineWidth =...
            app.UIFigure.UserData.HighlightedLineWidth;
    end
    
    if isempty(app.UIFigure.UserData.ScatterPlot); return; end
    if size(app.UIFigure.UserData.ScatterPlot.XData, 2) < indices(1, 1); return; end
    sizeData = app.UIFigure.UserData.ScatterPlot.SizeData;    
    sizeData = sizeData./sizeData * app.UIFigure.UserData.DefaultScatterSize;    
    sizeData(indices(1, 1)) =...
        sizeData(indices(1, 1)) * app.UIFigure.UserData.HighlightedScatterSize ...
        / app.UIFigure.UserData.DefaultScatterSize;
    app.UIFigure.UserData.ScatterPlot.SizeData = sizeData;
end


function ReferencingDropDownValueChanged(app, ~, ~)
    CalculateDisplayCurves(app);
    AdjustBaseline(app);
    PlotCurves(app);
    SetPlotVisibility(app);
    SetSpinnerLimits(app);
end


function DelButtonPushed(app, ~, ~)
    if isempty(app.UITable.Selection)
        return
    end

    indices = app.UITable.Selection(:, 1);
    uniqIdx = unique(indices);
    tmpIdx = true(size(app.UITable.Data, 1), 1);
    tmpIdx(uniqIdx, :) = false;
    
    copyIdx = [];
    for i = 1:size(app.UITable.Data, 2)
        copyIdx = [copyIdx; tmpIdx];
    end

    app.UIFigure.UserData.RawCurves = app.UIFigure.UserData.RawCurves(tmpIdx);
    app.UIFigure.UserData.DisplayCurves = app.UIFigure.UserData.DisplayCurves(tmpIdx);
    tmpTableData = app.UITable.Data(logical(copyIdx));
    app.UITable.Data = reshape(tmpTableData, [], size(app.UITable.ColumnName, 1));
    PlotCurves(app);

    if isempty(app.UIFigure.UserData.ScatterPlot)
        return
    end

    if isempty(app.UIFigure.UserData.ScatterPlot.XData) || isempty(app.UIFigure.UserData.ScatterPlot.YData)
        return
    end

    app.UIFigure.UserData.ScatterPlot.XData = app.UIFigure.UserData.ScatterPlot.XData(tmpIdx);
    app.UIFigure.UserData.ScatterPlot.YData = app.UIFigure.UserData.ScatterPlot.YData(tmpIdx);
    app.UIFigure.UserData.ScatterPlot.SizeData = app.UIFigure.UserData.ScatterPlot.SizeData(tmpIdx);
end


function RunButtonPushed(app, ~, ~)
    if isempty(app.UIFigure.UserData.DisplayCurves); return; end
    result = nan(size(app.UIFigure.UserData.DisplayCurves, 1), 2);
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1)
        startIdx = []; endIdx = [];
        result(i, 1) = app.UITable.Data{i, strcmp(app.UITable.ColumnName, 'Index')};        
        if size(app.UIFigure.UserData.DisplayCurves{i, 1}, 2) == 2
            yData = app.UIFigure.UserData.DisplayCurves{i, 1}(:, 2);
            startIdx = find(app.StartPointSpinner.Value == app.UIFigure.UserData.DisplayCurves{i, 1}(:, 1));
            endIdx = find(app.EndPointSpinner.Value == app.UIFigure.UserData.DisplayCurves{i, 1}(:, 1));
        end
        if isempty(startIdx) || isempty(endIdx)
            continue;
        end
        if strcmp(app.MethodButtonGroup.SelectedObject.Text(1), 'Δ') % Delta RU
            result(i, 2) = yData(endIdx) - yData(startIdx);
        elseif strcmp(app.MethodButtonGroup.SelectedObject.Text(1), 'A') % Averaging
            result(i, 2) = mean(yData(startIdx:endIdx));
        elseif strcmp(app.MethodButtonGroup.SelectedObject.Text(1), 'D') % Drift
            try
                x = app.StartPointSpinner.Value:app.EndPointSpinner.Value;
                y = yData(app.StartPointSpinner.Value:app.EndPointSpinner.Value);
                p = polyfit(x, y, 1);
                yfit = polyval(p, x);
                result(i, 2) = yfit(end) - yfit(1);
            catch
                disp('RunButtonPushed - Linear fit error')
                continue;
            end
        end
    end

    positiveIndex = find(ismember(app.UITable.Data(:, strcmp(app.UITable.ColumnName, 'Type')),...
        'Positive'));     
    tmpResult = result(:, 2);
    if ~isempty(positiveIndex)
        if strcmp(app.CorrectionButtonGroup.SelectedObject.Text, 'P-T-P-T')
            for i = 1:size(positiveIndex, 1)
                if i == size(positiveIndex, 1)
                    tmpResult(positiveIndex(end) : end) =...
                        tmpResult(positiveIndex(end) : end) - tmpResult(positiveIndex(end));
                else
                    tmpResult(positiveIndex(i) : positiveIndex(i+1)-1) =...
                        tmpResult(positiveIndex(i) : positiveIndex(i+1)-1) - tmpResult(positiveIndex(i));
                end
            end
            result(:, 2) = tmpResult;
        elseif strcmp(app.CorrectionButtonGroup.SelectedObject.Text, 'T-P-T-P')
            for i = 1:size(positiveIndex, 1)
                if i == 1
                    tmpResult(1 : positiveIndex(1)) =...
                        tmpResult(1 : positiveIndex(1)) - tmpResult(positiveIndex(1));
                else
                    tmpResult(positiveIndex(i-1)+1 : positiveIndex(i)) =...
                        tmpResult(positiveIndex(i-1)+1 : positiveIndex(i)) - tmpResult(positiveIndex(i));
                end
            end
            result(:, 2) = tmpResult;
        end
        
    end

    cla(app.PreviewUIAxes);
    app.UIFigure.UserData.ScatterPlot =...
        scatter(app.PreviewUIAxes, result(:, 1), result(:, 2), 'filled');

    app.UIFigure.UserData.ScatterPlot.SizeData =...
        ones(size(app.UIFigure.UserData.ScatterPlot.YData, 2), 1)...
        *app.UIFigure.UserData.DefaultScatterSize;    
    SetScatterVisibility(app)    
    app.UIFigure.UserData.Result = result;

end


function DetailedViewButtonPushed(app, ~, ~)
    if isempty(app.UIFigure.UserData.ScatterPlot); return; end
    if isempty(app.UIFigure.UserData.ScatterPlot.YData); return; end
    if ~isempty(app.UIFigure.UserData.DetailApp); return; end
    app.UIFigure.UserData.DetailApp = ui_detailed_view(app);
    waitfor(app.UIFigure.UserData.DetailApp.UIFigure);
    app.UIFigure.UserData.DetailApp = [];
    disp('Detailed view closed');
end


function ApplyButtonPushed(app, ~, ~)
    AdjustBaseline(app);
    PlotCurves(app);
    SetPlotVisibility(app);
    UITableCellSelection(app, [], app.UITable);
end


function UITableContextMenuNumberingSelected(app, ~, ~)
    if isempty(app.UITable.Selection); return; end
    startIdx = app.UITable.Selection(1, 1);
    startNo = app.UITable.Data{startIdx, strcmp(app.UITable.ColumnName, 'Index')};
    app.UITable.Data(startIdx:end, strcmp(app.UITable.ColumnName, 'Index')) = ...
        num2cell(startNo:startNo + size(app.UITable.Data, 1)-startIdx)';
    RenumberingID(app);
end


function UITableContextMenuMoveSelected(app, ~, ~)
    if isempty(app.UITable.Selection); return; end
    if ~isempty(app.UIFigure.UserData.MoveApp); return; end
    app.UIFigure.UserData.MoveApp = ui_move_curve(app);
    waitfor(app.UIFigure.UserData.MoveApp.UIFigure);
    app.UIFigure.UserData.MoveApp = [];
    disp('Move app closed')
    if isempty(app.UIFigure.UserData.MoveCurve); return; end
    curveIdx = app.UITable.Selection(1, 1);
    app.UIFigure.UserData.CurrentLinePlot{curveIdx}.XData =...
        app.UIFigure.UserData.CurrentLinePlot{curveIdx}.XData +...
        app.UIFigure.UserData.MoveCurve(1);
    app.UIFigure.UserData.CurrentLinePlot{curveIdx}.YData =...
        app.UIFigure.UserData.CurrentLinePlot{curveIdx}.YData +...
        app.UIFigure.UserData.MoveCurve(2);    
    
    app.UIFigure.UserData.RawCurves{curveIdx}(:, 1) =...
        app.UIFigure.UserData.RawCurves{curveIdx}(:, 1) +...
        app.UIFigure.UserData.MoveCurve(1);
    app.UIFigure.UserData.RawCurves{curveIdx}(:, 2) =...
        app.UIFigure.UserData.RawCurves{curveIdx}(:, 2) +...
        app.UIFigure.UserData.MoveCurve(2);

    CalculateDisplayCurves(app);
    SetSpinnerLimits(app);
end


function UIFigureCloseRequest(app, ~, ~)
    try
        SaveErrorLogFile(app);
        delete(app.UIFigure);
    catch
        close force all
    end
end


% Business logic
function PlotCurves(app)
    cla(app.SensorgramUIAxes);
    app.UIFigure.UserData.CurrentLinePlot = cell(size(app.UIFigure.UserData.DisplayCurves));
    
    hold(app.SensorgramUIAxes, 'On')
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1)
        x = []; y = [];
        if size(app.UIFigure.UserData.DisplayCurves{i, 1}, 2) == 2
            x = app.UIFigure.UserData.DisplayCurves{i, 1}(:, 1);
            y = app.UIFigure.UserData.DisplayCurves{i, 1}(:, 2);            
        end
        app.UIFigure.UserData.CurrentLinePlot{i, 1} =...
            plot(app.SensorgramUIAxes, ...
            x, y, ...
            'LineWidth', app.UIFigure.UserData.DefaultLineWidth);                
    end
    hold(app.SensorgramUIAxes, 'Off')
end


function AddTableData(app)
    prevData = app.UITable.Data;
    if size(prevData, 1) >= size(app.UIFigure.UserData.DisplayCurves, 1)
        ME = MException('AddTableData function', ...
            'Display curves is less than previous table data');
        throw(ME);
    end
    newCurves = app.UIFigure.UserData.DisplayCurves(size(prevData, 1)+1 : end);    

    if isempty(app.UITable.Data)
        newIdx = [1:size(app.UIFigure.UserData.DisplayCurves, 1)]';                  
        newTypeData    = cell(size(newIdx, 1), 1);
        newTypeData(:) = {'Target'};  % Default value      
        newIsDisplay = true(size(app.UIFigure.UserData.DisplayCurves, 1), 1);
    else
        prevIdx = [prevData{:, 1}]';
        newIdx = [max(prevIdx)+1:...
            max(prevIdx) + size(newCurves, 1)]'; 
        newTypeData = cell(size(newIdx, 1), 1);        
        newTypeData(:) = {'Target'};  % Default value
        newIsDisplay = true(size(newCurves, 1), 1);        
    end
    newID = newIdx;

    newData = cat(2, num2cell(newIdx), num2cell(newID), newTypeData, num2cell(newIsDisplay));
    app.UITable.Data = [prevData; newData];
    TableBasicSetting(app, [], []);
end


function CalculateDisplayCurves(app)
    if isempty(app.UITable.Data); return; end
    
    negativeIndex = find(ismember(...
        app.UITable.Data(:, strcmp(app.UITable.ColumnName, 'Type')), 'Negative'));
    app.UIFigure.UserData.DisplayCurves = app.UIFigure.UserData.RawCurves;

    if strcmp(app.ReferencingDropDown.Value, 'T-N-T-N')
        for i = 1:size(negativeIndex, 1)
            if i == 1
                for j = 1:negativeIndex(i)
                    resultCurve = ...
                        SubstractReferenceCurve(...
                            app.UIFigure.UserData.RawCurves{j, 1}, ...
                            app.UIFigure.UserData.RawCurves{negativeIndex(i), 1}...
                            );
                    app.UIFigure.UserData.DisplayCurves{j, 1} = resultCurve;
                end
            else
                for j = negativeIndex(i-1)+1:negativeIndex(i)
                    resultCurve = ...
                        SubstractReferenceCurve(...
                            app.UIFigure.UserData.RawCurves{j, 1}, ...
                            app.UIFigure.UserData.RawCurves{negativeIndex(i), 1}...
                            );
                    app.UIFigure.UserData.DisplayCurves{j, 1} = resultCurve;
                end
            end
        end
    elseif strcmp(app.ReferencingDropDown.Value, 'N-T-N-T')
        for i = 1:size(negativeIndex, 1)
            if i == size(negativeIndex, 1)
                for j = negativeIndex(i):size(app.UIFigure.UserData.DisplayCurves, 1)
                    resultCurve = ...
                        SubstractReferenceCurve(...
                            app.UIFigure.UserData.RawCurves{j, 1}, ...
                            app.UIFigure.UserData.RawCurves{negativeIndex(i), 1}...
                            );
                    app.UIFigure.UserData.DisplayCurves{j, 1} = resultCurve;
                end
            else
                for j = negativeIndex(i):negativeIndex(i+1)
                    resultCurve = ...
                        SubstractReferenceCurve(...
                            app.UIFigure.UserData.RawCurves{j, 1}, ...
                            app.UIFigure.UserData.RawCurves{negativeIndex(i), 1}...
                            );
                    app.UIFigure.UserData.DisplayCurves{j, 1} = resultCurve;
                end
            end
        end
    end
end


function AdjustBaseline(app)
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1)
        if size(app.UIFigure.UserData.DisplayCurves{i, 1}, 1) < app.BaselineSpinner.Value
            continue;
        end
        isBase = 0;
        if size(app.UIFigure.UserData.DisplayCurves{i, 1}, 2) == 2
            isBase = app.UIFigure.UserData.DisplayCurves{i, 1}(:, 1) == app.BaselineSpinner.Value;
        end
        if sum(isBase) == 0
            continue;
        end
        
        subVal = app.UIFigure.UserData.DisplayCurves{i, 1}(isBase, 2);
        if isnan(subVal)
            continue;
        end

        app.UIFigure.UserData.DisplayCurves{i, 1}(:, 2) =...
            app.UIFigure.UserData.DisplayCurves{i, 1}(:, 2) -...
            app.UIFigure.UserData.DisplayCurves{i, 1}(isBase, 2);        
    end
end


function SetPlotVisibility(app)
    if isempty(app.UITable.Data)
        return
    end
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1)
        set(app.UIFigure.UserData.CurrentLinePlot{i, 1},...
            'Visible',...
            app.UITable.Data{i, strcmp(app.UITable.ColumnName, 'Display')});
    end
end


function SetScatterVisibility(app)
    if isempty(app.UIFigure.UserData.ScatterPlot); return; end
    sizeData = app.UIFigure.UserData.ScatterPlot.SizeData;    
    isDisplay = [app.UITable.Data{:, strcmp(app.UITable.ColumnName, 'Display')}];
    isDisplay = isDisplay(1:size(app.UIFigure.UserData.ScatterPlot.XData, 2));
    
    sizeData(~isDisplay) = nan;
    sizeData(isDisplay) = app.UIFigure.UserData.DefaultScatterSize;
    app.UIFigure.UserData.ScatterPlot.SizeData = sizeData;
end


function SetSpinnerLimits(app)
    if isempty(app.UIFigure.UserData.DisplayCurves); return; end
    if isempty(app.UIFigure.UserData.DisplayCurves{1, 1}); return; end
    
    tmpMin = nan(size(app.UIFigure.UserData.DisplayCurves, 1), 1);
    tmpMax = nan(size(app.UIFigure.UserData.DisplayCurves, 1), 1);    
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1)
        if size(app.UIFigure.UserData.DisplayCurves{i, 1}, 2) == 2
            tmpMin(i, 1) = min(app.UIFigure.UserData.DisplayCurves{i, 1}(:, 1));
            tmpMax(i, 1) = max(app.UIFigure.UserData.DisplayCurves{i, 1}(:, 1));
        end
    end

    minVal = min(tmpMin);
    maxVal = max(tmpMax);

    if isnan(minVal) || isnan(maxVal)
        uialert(app.UIFigure, "Invalid x-axis data")
        minVal = 0; maxVal = 0;        
    end

    app.BaselineSpinner.Limits = [minVal, maxVal];
    app.StartPointSpinner.Limits = [minVal, maxVal];
    app.EndPointSpinner.Limits = [minVal, maxVal];
end
        

function RenumberingID(app)
    tmpIdx = [app.UITable.Data{:, strcmp(app.UITable.ColumnName, 'Index')}]';
    tmpType = app.UITable.Data(:, strcmp(app.UITable.ColumnName, 'Type'));
    targetIdx = strcmp(tmpType, 'Target');
    
    tmpID = zeros(size(tmpIdx, 1), 1);
    tmpTargetID = 1:sum(targetIdx);
    tmpID(targetIdx) = tmpTargetID;
    app.UITable.Data(:, strcmp(app.UITable.ColumnName, 'ID')) = num2cell(tmpID);
end


function TableBasicSetting(app, ~, ~)
    type = {'Target', 'Positive', 'Negative'};  
    columnname =   {'Index', 'ID', 'Type', 'Display'};
    columnformat = {'numeric','char', type, 'logical'};
    columneditable = [true, false, true, true];     
    app.UITable.ColumnName = columnname;
    app.UITable.ColumnFormat = columnformat;
    app.UITable.ColumnEditable = columneditable;
end


function resultCurve = SubstractReferenceCurve(rawCurve, referenceCurve)
    resultCurve = [];
    isMemberRaw = ismember(rawCurve(:, 1), referenceCurve(:, 1));
    isMemberNeg = ismember(referenceCurve(:, 1), rawCurve(:, 1));
    if sum(isMemberRaw) == 0 || sum(isMemberNeg) == 0
        return;
    end
    xRaw = rawCurve(isMemberRaw, 1);
    yRaw = rawCurve(isMemberRaw, 2);
    xNeg = referenceCurve(isMemberNeg, 1);
    yNeg = referenceCurve(isMemberNeg, 2);                    
    resultCurve = [xRaw, yRaw - yNeg];                                    
end


function MakeErrorLogFolder(app)
    if isfile(app.UIFigure.UserData.ErrorLog.FileName)    
        fileattrib(app.UIFigure.UserData.ErrorLog.FileName, '+h');                    
    end
       
    status = mkdir(app.UIFigure.UserData.ErrorLog.FileFolder);
    if status == 0
        disp('Make Error Log folder')
    end
    
    logFolderContent = dir(app.UIFigure.UserData.ErrorLog.FileFolder);
    tmpDate = [logFolderContent.datenum];
    tmpName = {logFolderContent.name};
    tmpDate = tmpDate([logFolderContent.isdir] == 0);
    tmpName = tmpName([logFolderContent.isdir] == 0);
    tmpDate = tmpDate(contains(tmpName, app.UIFigure.UserData.ErrorLog.FileName));      
    tmpName = tmpName(contains(tmpName, app.UIFigure.UserData.ErrorLog.FileName));
    
    timeLimit = datenum(duration(app.UIFigure.UserData.LogFileExpireDuration, 0, 0));
    expiredIdx = now - tmpDate > timeLimit;
    
    targetFile = tmpName(expiredIdx);
    for i = 1: length(targetFile)
        delete(fullfile(app.UIFigure.UserData.ErrorLog, targetFile{i}))
    end
end 


function SaveErrorLogFile(app)
    if isfile(app.UIFigure.UserData.ErrorLog.FileName)
        if ~isfolder(app.UIFigure.UserData.ErrorLog.FileFolder)
            mkdir(app.UIFigure.UserData.ErrorLog.FileFolder);
        end        
        try 
            copyfile(app.UIFigure.UserData.ErrorLog.FileName, app.UIFigure.UserData.ErrorLog.FilePath);
            fileattrib(app.UIFigure.UserData.ErrorLog.FilePath, '-h');
            delete(fullfile(pwd, app.UIFigure.UserData.ErrorLog.FileName));
        catch
            disp('Log file saving Error')
        end
    end
end