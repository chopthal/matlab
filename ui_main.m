close force all
% Create UIFigure and hide until all components are created
app.UIFigure = uifigure(1);
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100 100 1083 665];
app.UIFigure.Name = 'MATLAB App';

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

% Create DownButton
% app.DownButton = uibutton(app.TableButtonGridLayout, 'push');
% app.DownButton.Layout.Row = 1;
% app.DownButton.Layout.Column = 5;
% app.DownButton.Text = '▼';

% Create UpButton
% app.UpButton = uibutton(app.TableButtonGridLayout, 'push');
% app.UpButton.Layout.Row = 1;
% app.UpButton.Layout.Column = 4;
% app.UpButton.Text = '▲';

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
app.UITable.ColumnName = {'Index'; 'Type'; 'Display'};
app.UITable.RowName = {};
app.UITable.Layout.Row = 2;
app.UITable.Layout.Column = 1;

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
app.BaselineSpinnerLabel.Text = 'Base line :';

% Create BaselineSpinner
app.BaselineSpinner = uispinner(app.ReferencingGridLayout);
app.BaselineSpinner.ValueDisplayFormat = '%.0f';
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
app.StartPointSpinnerLabel.Text = 'Start Point :';

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
app.EndPointSpinnerLabel.Text = 'End Point :';

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

% Create NormalizationButtonGroup
app.NormalizationButtonGroup = uibuttongroup(app.SettingGridLayout);
app.NormalizationButtonGroup.Title = 'Normalization';
app.NormalizationButtonGroup.Layout.Row = 4;
app.NormalizationButtonGroup.Layout.Column = [1 2];

% Create NoneButton
app.NoneButton = uiradiobutton(app.NormalizationButtonGroup);
app.NoneButton.Text = 'None';
app.NoneButton.Position = [11 49 58 22];
app.NoneButton.Value = true;

% Create byPositiveButton
app.byPTPTButton = uiradiobutton(app.NormalizationButtonGroup);
app.byPTPTButton.Text = 'P-T-P-T';
app.byPTPTButton.Position = [11 27 80 22];

% Create byPositiveButton
app.TPTPButton = uiradiobutton(app.NormalizationButtonGroup);
app.TPTPButton.Text = 'T-P-T-P';
app.TPTPButton.Position = [11 5 80 22];

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

% Define Callback
app.iMSPRminiDataMenu.MenuSelectedFcn = @(src, event) DataAddMenuSelected(app, src, event);
app.iMSPRProDataMenu.MenuSelectedFcn = @(src, event) DataAddMenuSelected(app, src, event);
app.BiacoreDataMenu.MenuSelectedFcn = @(src, event) DataAddMenuSelected(app, src, event);
app.SortButton.ButtonPushedFcn = @(src, event) SortButtonPushed(app, src, event);
app.UITable.CellEditCallback = @(src, event) UITableCellEdit(app, src, event);
app.UITable.CellSelectionCallback = @(src, event) UITableCellSelection(app, src, event);
app.CheckBox.ValueChangedFcn = @(src, event) CheckBoxValueChanged(app, src, event);
app.ReferencingDropDown.ValueChangedFcn = @(src, event) ReferencingDropDownValueChanged(app, src, event);
app.DelButton.ButtonPushedFcn = @(src, event) DelButtonPushed(app, src, event);
app.RunButton.ButtonPushedFcn = @(src, event) RunButtonPushed(app, src, event);
app.DetailedviewButton.ButtonPushedFcn = @(src, event) DetailedViewButtonPushed(app, src, event);
app.ApplyButton.ButtonPushedFcn = @(src, event) ApplyButtonPushed(app, src, event);


%% Start up
% Variable
app.UIFigure.UserData.DefaultScatterSize = 10;
app.UIFigure.UserData.HighlightedScatterSize = 50;
app.UIFigure.UserData.DefaultLineWidth = 0.2;
app.UIFigure.UserData.HighlightedLineWidth = 10;
app.UIFigure.UserData.MainApp.UIFigure.UserData.Curves = [];
app.UIFigure.UserData.MainApp.UIFigure.UserData.AddCurves = [];
app.UIFigure.UserData.CurrentPath = pwd;
app.UIFigure.UserData.RawCurves = [];
app.UIFigure.UserData.DisplayCurves = [];
app.UIFigure.UserData.CurrentLinePlot = [];
app.UIFigure.UserData.ScatterPlot = [];
app.UIFigure.UserData.DataType.mini = 'iMSPR-mini Data';
app.UIFigure.UserData.DataType.Pro = 'iMSPR-Pro Data';
app.UIFigure.UserData.DataType.Biacore = 'Biacore Data';

%% Function
% Callback
function DataAddMenuSelected(app, ~, event)
    
    app.UIFigure.UserData.AddCurves = [];

    if strcmp(event.Source.Text, app.UIFigure.UserData.DataType.mini)
        addApp = ui_add(app, app.UIFigure.UserData.DataType.mini);
    elseif strcmp(event.Source.Text, app.UIFigure.UserData.DataType.Pro)
        addApp = ui_add(app, app.UIFigure.UserData.DataType.Pro);
    elseif strcmp(event.Source.Text, app.UIFigure.UserData.DataType.Biacore)
        addApp = ui_add(app, app.UIFigure.UserData.DataType.Biacore);
    end
    
    waitfor(addApp.UIFigure);
    disp('Add app closed')
    
    if isempty(app.UIFigure.UserData.AddCurves)
        return
    end
    
    app.UIFigure.UserData.RawCurves = [app.UIFigure.UserData.RawCurves; app.UIFigure.UserData.AddCurves];
    app.UIFigure.UserData.DisplayCurves = app.UIFigure.UserData.RawCurves;
    AddTableData(app);
    CalculateDisplayCurves(app);
    AdjustBaseline(app);
    PlotCurves(app);
    SetPlotVisibility(app);
    SetSpinnerLimits(app);
end


function SortButtonPushed(app, ~, ~)
    if isempty(app.UITable.Data)
        return
    end
    
    tableData = app.UITable.Data;
    idxColumn = [tableData{:, 1}];
    [~, sortIdx] = sort(idxColumn);
    
    app.UITable.Data(sortIdx, :)
    app.UIFigure.UserData.RawCurves = app.UIFigure.UserData.RawCurves(sortIdx, :);
    app.UIFigure.UserData.DisplayCurves = app.UIFigure.UserData.DisplayCurves(sortIdx, :);
    app.UIFigure.UserData.CurrentLinePlot = app.UIFigure.UserData.CurrentLinePlot(sortIdx, :);
    
    app.UITable.Data = tableData(sortIdx, :);
end


function UITableCellEdit(app, ~, event)
    indices = event.Indices;
    newData = event.NewData;
    if indices(1, 2) == 2 % Display Column        
        CalculateDisplayCurves(app);
        AdjustBaseline(app);
        PlotCurves(app);
    end
    if indices(1, 2) == 3 % Display Column
        if newData
            set(app.UIFigure.UserData.CurrentLinePlot{indices(1, 1)}, 'Visible', 'On')
        else
            set(app.UIFigure.UserData.CurrentLinePlot{indices(1, 1)}, 'Visible', 'Off')
        end
    end
end


function CheckBoxValueChanged(app, ~, ~)
    if isempty(app.UITable.Data)
        return
    end
    value = app.CheckBox.Value;
    for i = 1:size(app.UITable.Data, 1)
        app.UITable.Data{i, 3} = value;
    end
    for i = 1:size(app.UIFigure.UserData.CurrentLinePlot, 1)
        set(app.UIFigure.UserData.CurrentLinePlot{i, 1}, 'Visible', app.UITable.Data{i, 3})
    end
end


function UITableCellSelection(app, ~, event)
    if isempty(event.Indices)
        return
    end
    indices = event.Indices;
    for i = 1:length(app.UIFigure.UserData.CurrentLinePlot)
        app.UIFigure.UserData.CurrentLinePlot{i, 1}.LineWidth = app.UIFigure.UserData.DefaultLineWidth;
    end
    if indices(1, 2) ~= 1
        return;
    end
    app.UIFigure.UserData.CurrentLinePlot{indices(1), 1}.LineWidth = app.UIFigure.UserData.HighlightedLineWidth;
    
    if isempty(app.UIFigure.UserData.ScatterPlot)
        return
    end
    app.UIFigure.UserData.ScatterPlot.SizeData = app.UIFigure.UserData.DefaultScatterSize;

    sizeData = ones(size(app.UIFigure.UserData.ScatterPlot.YData, 2), 1) * app.UIFigure.UserData.DefaultScatterSize;
    if size(sizeData, 1) < indices(1)
        return
    end
    sizeData(indices(1), 1) = app.UIFigure.UserData.HighlightedScatterSize;
    app.UIFigure.UserData.ScatterPlot.SizeData = sizeData;

end


function ReferencingDropDownValueChanged(app, ~, ~)
    CalculateDisplayCurves(app);
    AdjustBaseline(app);
    PlotCurves(app);
end


function DelButtonPushed(app, ~, ~)
    if isempty(app.UITable.Selection)
        return
    end

    indices = app.UITable.Selection;
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
    app.UITable.Data = reshape(tmpTableData, [], 3);
    PlotCurves(app);

    if isempty(app.UIFigure.UserData.ScatterPlot)
        return
    end

    if isempty(app.UIFigure.UserData.ScatterPlot.XData) || isempty(app.UIFigure.UserData.ScatterPlot.YData)
        return
    end

    app.UIFigure.UserData.ScatterPlot.XData = app.UIFigure.UserData.ScatterPlot.XData(tmpIdx);
    app.UIFigure.UserData.ScatterPlot.YData = app.UIFigure.UserData.ScatterPlot.YData(tmpIdx);
end


function RunButtonPushed(app, ~, ~)

    if isempty(app.UIFigure.UserData.DisplayCurves)
        return
    end    
    result = zeros(size(app.UIFigure.UserData.DisplayCurves, 1), 2);
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1)
        result(i, 1) = app.UITable.Data{i, 1};
        if strcmp(app.MethodButtonGroup.SelectedObject.Text(1), 'Δ') % Delta RU
            result(i, 2) =...
                app.UIFigure.UserData.DisplayCurves{i, 1}(app.EndPointSpinner.Value) - ...
                app.UIFigure.UserData.DisplayCurves{i, 1}(app.StartPointSpinner.Value);
        elseif strcmp(app.MethodButtonGroup.SelectedObject.Text(1), 'A') % Averaging
            result(i, 2) =...
                mean(app.UIFigure.UserData.DisplayCurves{i, 1}...
                (app.StartPointSpinner.Value:app.EndPointSpinner.Value));                
        elseif strcmp(app.MethodButtonGroup.SelectedObject.Text(1), 'D') % Drift
            x = app.StartPointSpinner.Value:app.EndPointSpinner.Value;
            y = app.UIFigure.UserData.DisplayCurves{i, 1}...
                (app.StartPointSpinner.Value:app.EndPointSpinner.Value);
            p = polyfit(x, y, 1);
            yfit = polyval(p, x);
            result(i, 2) = yfit(end) - yfit(1);
        end
    end

    positiveIndex = find(ismember(app.UITable.Data(:, 2), 'Positive')); 

    tmpResult = result(:, 2);
    if ~isempty(positiveIndex)
        if strcmp(app.NormalizationButtonGroup.SelectedObject.Text, 'P-T-P-T')
            for i = 1:size(positiveIndex, 1)
                if i == size(positiveIndex, 1)
                    tmpResult(positiveIndex(end):end) = tmpResult(positiveIndex(end):end)/tmpResult(positiveIndex(end));
                else
                    tmpResult(positiveIndex(i):positiveIndex(i+1)) =...
                        tmpResult(positiveIndex(i):positiveIndex(i+1))/tmpResult(positiveIndex(i));
                end
            end
            result(:, 2) = tmpResult;
        elseif strcmp(app.NormalizationButtonGroup.SelectedObject.Text, 'T-P-T-P')
            for i = 1:size(positiveIndex, 1)
                if i == 1
                    tmpResult(1:positiveIndex(1)) = tmpResult(1:positiveIndex(1)) / tmpResult(positiveIndex(1));
                else
                    tmpResult(positiveIndex(i-1):positiveIndex(i)) = tmpResult(positiveIndex(i-1):positiveIndex(i)) / tmpResult(positiveIndex(i));
                end
            end
            result(:, 2) = tmpResult;
        end
        
    end

    cla(app.PreviewUIAxes);
    app.UIFigure.UserData.ScatterPlot = scatter(app.PreviewUIAxes, result(:, 1), result(:, 2), 'filled', 'SizeData', app.UIFigure.UserData.DefaultScatterSize);

end


function DetailedViewButtonPushed(app, ~, ~)
    if isempty(app.UIFigure.UserData.ScatterPlot)
        return
    end
    detailApp = ui_detailed_view(app);
    waitfor(detailApp.UIFigure);
    disp('Detailed view exit')
end


function ApplyButtonPushed(app, ~, ~)
    AdjustBaseline(app);
    PlotCurves(app);
    SetPlotVisibility(app);
end


% Business logic
function PlotCurves(app)
    cla(app.SensorgramUIAxes);
    app.UIFigure.UserData.CurrentLinePlot = cell(size(app.UIFigure.UserData.DisplayCurves));
    
    hold(app.SensorgramUIAxes, 'On')
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1)        
        app.UIFigure.UserData.CurrentLinePlot{i, 1} =...
            plot(app.SensorgramUIAxes, ...
            1:length(app.UIFigure.UserData.DisplayCurves{i, 1}), ...
            app.UIFigure.UserData.DisplayCurves{i, 1}, 'LineWidth', app.UIFigure.UserData.DefaultLineWidth);                
    end
    hold(app.SensorgramUIAxes, 'Off')
end


function AddTableData(app)
    prevData = app.UITable.Data;
    if size(prevData, 1) >= size(app.UIFigure.UserData.DisplayCurves, 1)
        return
    end
    newCurves = app.UIFigure.UserData.DisplayCurves(size(prevData, 1)+1 : end);    

    if isempty(app.UITable.Data)
        newIdx = [1:size(app.UIFigure.UserData.DisplayCurves, 1)]';
                  
        newModeData    = cell(size(newIdx, 1), 1);
        newModeData(:) = {'Target'};  % Default value      

        newIsDisplay = true(size(app.UIFigure.UserData.DisplayCurves, 1), 1);
    else
        prevIdx = [prevData{:, 1}]';
        newIdx = [max(prevIdx)+1:...
            max(prevIdx) + size(newCurves, 1)]';        
                
        newModeData = cell(size(newIdx, 1), 1);        
        newModeData(:) = {'Target'};  % Default value              
        
        newIsDisplay = true(size(newCurves, 1), 1);        
    end

    newData = cat(2, num2cell(newIdx), newModeData, num2cell(newIsDisplay));
    mode = {'Target', 'Positive', 'Negative'};  
    columnname =   {'Index', 'Type', 'Display'};
    columnformat = {'numeric', mode, 'logical'};
    columneditable = [true, true, true]; 
    app.UITable.Data = [prevData; newData];
    app.UITable.ColumnName = columnname;
    app.UITable.ColumnFormat = columnformat;
    app.UITable.ColumnEditable = columneditable;
end


function CalculateDisplayCurves(app)
    if isempty(app.UITable.Data)
        return
    end
    
    negativeIndex = find(ismember(app.UITable.Data(:, 2), 'Negative'));
    if isempty(negativeIndex)
        return
    end
    app.UIFigure.UserData.DisplayCurves = app.UIFigure.UserData.RawCurves;

    if strcmp(app.ReferencingDropDown.Value, 'T-N-T-N')
        for i = 1:size(negativeIndex, 1)
            if i == 1
                for j = 1:negativeIndex(i)
                    app.UIFigure.UserData.DisplayCurves{j, 1} = app.UIFigure.UserData.RawCurves{j, 1} - app.UIFigure.UserData.RawCurves{negativeIndex(i), 1};
                end
            else
                for j = negativeIndex(i-1)+1:negativeIndex(i)
                    app.UIFigure.UserData.DisplayCurves{j, 1} = app.UIFigure.UserData.RawCurves{j, 1} - app.UIFigure.UserData.RawCurves{negativeIndex(i), 1};
                end
            end
        end
    elseif strcmp(app.ReferencingDropDown.Value, 'N-T-N-T')
        for i = 1:size(negativeIndex, 1)
            if i == size(negativeIndex, 1)
                for j = negativeIndex(i):size(app.UIFigure.UserData.DisplayCurves, 1)
                    app.UIFigure.UserData.DisplayCurves{j, 1} = app.UIFigure.UserData.RawCurves{j, 1} - app.UIFigure.UserData.RawCurves{negativeIndex(i), 1};
                end
            else
                for j = negativeIndex(i):negativeIndex(i+1)
                    app.UIFigure.UserData.DisplayCurves{j, 1} = app.UIFigure.UserData.RawCurves{j, 1} - app.UIFigure.UserData.RawCurves{negativeIndex(i), 1};
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
        app.UIFigure.UserData.DisplayCurves{i, 1} =...
            app.UIFigure.UserData.DisplayCurves{i, 1} -...
            app.UIFigure.UserData.DisplayCurves{i, 1}(app.BaselineSpinner.Value);
    end
end


function SetPlotVisibility(app)
    for i = 1:size(app.UIFigure.UserData.DisplayCurves, 1) 
        if ~isempty(app.UITable.Data)
            if app.UITable.Data{i, 3}
                set(app.UIFigure.UserData.CurrentLinePlot{i, 1}, 'Visible', 'on');
            else
                set(app.UIFigure.UserData.CurrentLinePlot{i, 1}, 'Visible', 'off');
            end
        end
    end
end


function SetSpinnerLimits(app)

    if isempty(app.UIFigure.UserData.DisplayCurves)
        return
    end

    if isempty(app.UIFigure.UserData.DisplayCurves{1, 1})
        return
    end

    minVal = 1;
    maxVal = size(app.UIFigure.UserData.DisplayCurves{1, 1}, 1);
    app.BaselineSpinner.Limits = [minVal, maxVal];
    app.StartPointSpinner.Limits = [minVal, maxVal];
    app.EndPointSpinner.Limits = [minVal, maxVal];
end
        