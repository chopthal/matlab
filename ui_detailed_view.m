function app = ui_detailed_view(parentApp)

% Create UIFigure and hide until all components are created
app.UIFigure = uifigure(4);
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100 100 1092 695];
app.UIFigure.Name = 'Detailed view';    

% Create GridLayout
app.GridLayout = uigridlayout(app.UIFigure);
app.GridLayout.ColumnWidth = {'1x'};

% Create UIAxes
app.UIAxes = uiaxes(app.GridLayout);
xlabel(app.UIAxes, 'Index')
ylabel(app.UIAxes, 'RU')
zlabel(app.UIAxes, 'Z')
app.UIAxes.Layout.Row = 1;
app.UIAxes.Layout.Column = 1;

% Create GridLayout2
app.GridLayout2 = uigridlayout(app.GridLayout);
app.GridLayout2.ColumnWidth = {350, '1x'};
app.GridLayout2.RowHeight = {'1x'};
app.GridLayout2.Padding = [0 0 0 0];
app.GridLayout2.Layout.Row = 2;
app.GridLayout2.Layout.Column = 1;

% Create SettingPanel
app.SettingPanel = uipanel(app.GridLayout2);
app.SettingPanel.Title = 'Setting';
app.SettingPanel.Layout.Row = 1;
app.SettingPanel.Layout.Column = 1;

% Create GridLayout4
app.GridLayout4 = uigridlayout(app.SettingPanel);
app.GridLayout4.ColumnWidth = {'1x'};
app.GridLayout4.RowHeight = {150, '1x', 30};
app.GridLayout4.Padding = [0 0 0 0];

% Create MarkerPanel
app.MarkerPanel = uipanel(app.GridLayout4);
app.MarkerPanel.Title = 'Marker';
app.MarkerPanel.Layout.Row = 1;
app.MarkerPanel.Layout.Column = 1;

% Create GridLayout5
app.GridLayout5 = uigridlayout(app.MarkerPanel);
app.GridLayout5.ColumnWidth = {'1x', '1x', '1x', '1x'};
app.GridLayout5.RowHeight = {28, 28, 28, '1x'};
app.GridLayout5.RowSpacing = 3;

% Create MarkerSizeLabel
app.MarkerSizeLabel = uilabel(app.GridLayout5);
app.MarkerSizeLabel.HorizontalAlignment = 'right';
app.MarkerSizeLabel.Layout.Row = 1;
app.MarkerSizeLabel.Layout.Column = 1;
app.MarkerSizeLabel.Text = 'Marker Size:';

% Create MarkerSizeSpinner
app.MarkerSizeSpinner = uispinner(app.GridLayout5);
app.MarkerSizeSpinner.Layout.Row = 1;
app.MarkerSizeSpinner.Layout.Column = 2;
app.MarkerSizeSpinner.Value = 10;

% Create MarkerLabel
app.MarkerLabel = uilabel(app.GridLayout5);
app.MarkerLabel.HorizontalAlignment = 'right';
app.MarkerLabel.Layout.Row = 2;
app.MarkerLabel.Layout.Column = 1;
app.MarkerLabel.Text = 'Marker:';

% Create MarkerColorButton
app.MarkerColorButton = uibutton(app.GridLayout5, 'push');
app.MarkerColorButton.BackgroundColor = [0 0 0];
app.MarkerColorButton.Layout.Row = 2;
app.MarkerColorButton.Layout.Column = 2;
app.MarkerColorButton.Text = '';

% Create NegativeLabel
app.NegativeLabel = uilabel(app.GridLayout5);
app.NegativeLabel.HorizontalAlignment = 'right';
app.NegativeLabel.Layout.Row = 3;
app.NegativeLabel.Layout.Column = 1;
app.NegativeLabel.Text = 'Negative:';

% Create NegativeColorButton
app.NegativeColorButton = uibutton(app.GridLayout5, 'push');
app.NegativeColorButton.BackgroundColor = [1 0 0];
app.NegativeColorButton.Layout.Row = 3;
app.NegativeColorButton.Layout.Column = 2;
app.NegativeColorButton.Text = '';

% Create PositiveLabel
app.PositiveLabel = uilabel(app.GridLayout5);
app.PositiveLabel.HorizontalAlignment = 'right';
app.PositiveLabel.Layout.Row = 2;
app.PositiveLabel.Layout.Column = 3;
app.PositiveLabel.Text = 'Positive:';

% Create PositiveColorButton
app.PositiveColorButton = uibutton(app.GridLayout5, 'push');
app.PositiveColorButton.BackgroundColor = [0 0 1];
app.PositiveColorButton.Layout.Row = 2;
app.PositiveColorButton.Layout.Column = 4;
app.PositiveColorButton.Text = '';

% Create ThresholdLabel
app.ThresholdLabel = uilabel(app.GridLayout5);
app.ThresholdLabel.HorizontalAlignment = 'right';
app.ThresholdLabel.Layout.Row = 3;
app.ThresholdLabel.Layout.Column = 3;
app.ThresholdLabel.Text = '> Threshold:';

% Create ThresholdColorButton
app.ThresholdColorButton = uibutton(app.GridLayout5, 'push');
app.ThresholdColorButton.BackgroundColor = [0 1 0];
app.ThresholdColorButton.Layout.Row = 3;
app.ThresholdColorButton.Layout.Column = 4;
app.ThresholdColorButton.Text = '';

% Create ThresholdPanel
app.ThresholdPanel = uipanel(app.GridLayout4);
app.ThresholdPanel.Title = 'Threshold';
app.ThresholdPanel.Layout.Row = 2;
app.ThresholdPanel.Layout.Column = 1;

% Create GridLayout6
app.GridLayout6 = uigridlayout(app.ThresholdPanel);
app.GridLayout6.ColumnWidth = {'1x', '1x', '1x', '1x'};
app.GridLayout6.RowHeight = {28, '1x'};

% Create RUEditFieldLabel
app.RUEditFieldLabel = uilabel(app.GridLayout6);
app.RUEditFieldLabel.HorizontalAlignment = 'right';
app.RUEditFieldLabel.Layout.Row = 1;
app.RUEditFieldLabel.Layout.Column = 1;
app.RUEditFieldLabel.Text = 'RU';

% Create RUEditField
app.RUEditField = uieditfield(app.GridLayout6, 'numeric');
app.RUEditField.Layout.Row = 1;
app.RUEditField.Layout.Column = 2;

% Create ThresholdLineColorButton
app.ThresholdLineColorButton = uibutton(app.GridLayout6, 'push');
app.ThresholdLineColorButton.BackgroundColor = [0 0 0];
app.ThresholdLineColorButton.Layout.Row = 1;
app.ThresholdLineColorButton.Layout.Column = 4;
app.ThresholdLineColorButton.Text = '';

% Create LineColorLabel
app.LineColorLabel = uilabel(app.GridLayout6);
app.LineColorLabel.Layout.Row = 1;
app.LineColorLabel.Layout.Column = 3;
app.LineColorLabel.Text = 'Line Color:';

% Create ApplyButton
app.ApplyButton = uibutton(app.GridLayout4, 'push');
app.ApplyButton.Layout.Row = 3;
app.ApplyButton.Layout.Column = 1;
app.ApplyButton.Text = 'Apply';

% Create GridLayout3
app.GridLayout3 = uigridlayout(app.GridLayout2);
app.GridLayout3.ColumnWidth = {'1x'};
app.GridLayout3.RowHeight = {'1x', 30};
app.GridLayout3.Padding = [0 0 0 0];
app.GridLayout3.Layout.Row = 1;
app.GridLayout3.Layout.Column = 2;

% Create UITable
app.UITable = uitable(app.GridLayout3);
app.UITable.ColumnName = {'Index'; 'ID'; 'Result'; 'Type'; 'Remark'};
app.UITable.RowName = {};
app.UITable.Layout.Row = 1;
app.UITable.Layout.Column = 1;

% Create GridLayout7
app.GridLayout7 = uigridlayout(app.GridLayout3);
app.GridLayout7.ColumnWidth = {'1x', 150};
app.GridLayout7.RowHeight = {'1x'};
app.GridLayout7.Padding = [0 0 0 0];
app.GridLayout7.Layout.Row = 2;
app.GridLayout7.Layout.Column = 1;

% Create ExportDataButton
app.ExportDataButton = uibutton(app.GridLayout7, 'push');
app.ExportDataButton.Layout.Row = 1;
app.ExportDataButton.Layout.Column = 2;
app.ExportDataButton.Text = 'Export Data';

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

% Callback
app.MarkerColorButton.ButtonPushedFcn = @(src, event) ColorButtonPushed(app, src, event);
app.NegativeColorButton.ButtonPushedFcn = @(src, event) ColorButtonPushed(app, src, event);
app.PositiveColorButton.ButtonPushedFcn = @(src, event) ColorButtonPushed(app, src, event);
app.ThresholdColorButton.ButtonPushedFcn = @(src, event) ColorButtonPushed(app, src, event);
app.ThresholdLineColorButton.ButtonPushedFcn = @(src, event) ColorButtonPushed(app, src, event);
app.ApplyButton.ButtonPushedFcn = @(src, event) ApplyButtonPushed(app, src, event);
app.UITable.CellSelectionCallback = @(src, event) UITableCellSelection(app, src, event);
app.ExportDataButton.ButtonPushedFcn = @(src, event) ExportDataButtonPushed(app, src, event);

%% Start up
if isdeployed; app.UIFigure.WindowStyle = 'modal'; end

xData = parentApp.UIFigure.UserData.ScatterPlot.XData;
yData = parentApp.UIFigure.UserData.ScatterPlot.YData;

cla(app.UIAxes)
app.UIFigure.UserData.ScatterPlot = scatter(app.UIAxes, xData, yData, 'filled', 'SizeData', 5);
app.RUEditField.Value = mean(yData);
app.UIFigure.UserData.ThresholdLine = yline(app.UIAxes, mean(yData), 'LineWidth', 2, 'LineStyle', ':');

ApplyButtonPushed(app, [], [])


%% Function
% Callback
    function ApplyButtonPushed(app, ~, ~)
        % Set Marker size
        app.UIFigure.UserData.ScatterPlot.SizeData = app.MarkerSizeSpinner.Value;
        
        % Set threshold line position and color
        app.UIFigure.UserData.ThresholdLine.Color = app.ThresholdLineColorButton.BackgroundColor;
        app.UIFigure.UserData.ThresholdLine.LineWidth = 2;
        app.UIFigure.UserData.ThresholdLine.Value = app.RUEditField.Value;
        
        % Set marker colors
        app.UIFigure.UserData.ScatterPlot.MarkerFaceColor = 'flat';            
        app.UIFigure.UserData.ScatterPlot.CData = ones(size(app.UIFigure.UserData.ScatterPlot.YData, 2), 3).*app.MarkerColorButton.BackgroundColor;
        
        for i = 1:size(app.UIFigure.UserData.ScatterPlot.YData, 2)
            if app.UIFigure.UserData.ScatterPlot.YData(i) >= app.UIFigure.UserData.ThresholdLine.Value
                app.UIFigure.UserData.ScatterPlot.CData(i, :) = app.ThresholdColorButton.BackgroundColor;
            end
            if strcmp(parentApp.UITable.Data{i, strcmp(parentApp.UITable.ColumnName, 'Type')}, 'Positive')
                app.UIFigure.UserData.ScatterPlot.CData(i, :) = app.PositiveColorButton.BackgroundColor;
            elseif strcmp(parentApp.UITable.Data{i, strcmp(parentApp.UITable.ColumnName, 'Type')}, 'Negative')
                app.UIFigure.UserData.ScatterPlot.CData(i, :) = app.NegativeColorButton.BackgroundColor;
            end
        end
        
        % Scatter Plot DataTip
        tmpIdx = [parentApp.UITable.Data{:, strcmp(parentApp.UITable.ColumnName, 'Index')}]';        
        tmpResult = round(app.UIFigure.UserData.ScatterPlot.YData'*100)/100;        
        tmpResult = cellstr(num2str(tmpResult, '%.2f'));
        tmpType = parentApp.UITable.Data(:, strcmp(parentApp.UITable.ColumnName, 'Type'));
        
        targetIdx = strcmp(tmpType, 'Target');

        tmpID = zeros(size(tmpIdx, 1), 1);
        tmpTargetID = 1:sum(targetIdx);
        tmpID(targetIdx) = tmpTargetID;

        % TODO : sort w/o Negative, positive
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(1).Label = 'Index';
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(2).Label = 'ID';
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(3).Label = 'Res';
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(4).Label = 'Type';
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(1).Value = tmpIdx;
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(2).Value = tmpID;
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(3).Value = tmpResult;
        app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(4).Value = tmpType;
        
        % Display table data
        Index = tmpIdx(app.UIFigure.UserData.ScatterPlot.YData >= app.UIFigure.UserData.ThresholdLine.Value);
        ID = tmpID(app.UIFigure.UserData.ScatterPlot.YData >= app.UIFigure.UserData.ThresholdLine.Value);
        Result = tmpResult(app.UIFigure.UserData.ScatterPlot.YData >= app.UIFigure.UserData.ThresholdLine.Value);
        Type = tmpType(app.UIFigure.UserData.ScatterPlot.YData >= app.UIFigure.UserData.ThresholdLine.Value); 

        Remark = cell(size(Index)); Remark(:, :) = {''};
        tableData = table(Index, ID, Result, Type, Remark);
        app.UITable.Data = tableData;
        app.UITable.ColumnEditable = [false, false, false, false, true];
        alignRight = uistyle('HorizontalAlignment', 'right');
        addStyle(app.UITable, alignRight);

    end


    function ColorButtonPushed(~, ~, event)
        setColor = uisetcolor(event.Source.BackgroundColor, 'Select a color');
        if isequal(setColor, 0); return; end
        event.Source.BackgroundColor = setColor;
    end


    function UITableCellSelection(app, ~, event)
        %TODO : miss matched points with selected row
        if isempty(event.Indices); return; end
        sizeData = ones(size(app.UIFigure.UserData.ScatterPlot.YData)) * app.MarkerSizeSpinner.Value;
        for i = 1:size(event.Indices, 1)
            if event.Indices(i, 2) ~= 1; continue; end
            selectedIndex = app.UITable.Data.Index(event.Indices(i, 1));
%             selectedOrder = app.UIFigure.UserData.ScatterPlot.XData(app.UIFigure.UserData.ScatterPlot.XData == selectedIndex);            
            xMatchedIdx = find(app.UIFigure.UserData.ScatterPlot.XData == selectedIndex);
            yMatchedIdx = find(strcmp(app.UIFigure.UserData.ScatterPlot.DataTipTemplate.DataTipRows(3).Value,...
                    app.UITable.Data{selectedIndex, 3}))';            
            matchedIdx = xMatchedIdx(xMatchedIdx == yMatchedIdx);

            for ii = xMatchedIdx
                yMatchedIdx == ii
            end
            sizeData(matchedIdx) = app.MarkerSizeSpinner.Value * 5;

        end
        app.UIFigure.UserData.ScatterPlot.SizeData = sizeData;        
    end


    function ExportDataButtonPushed(app, ~, ~)
        selPath = uigetdir(parentApp.UIFigure.UserData.CurrentPath, 'Save folder');
        
        if isequal(selPath, 0); return; end
        formatOut = 'yymmddHHMMSS';
        dateStr = datestr(now, formatOut);
        extension = 'txt';
        
        fileName = strcat('Processed_curve', dateStr, '.', extension);
        fullFile = fullfile(selPath, fileName);
        writetable(app.UITable.Data, fullFile, 'Delimiter', 'tab')
    end
    
end