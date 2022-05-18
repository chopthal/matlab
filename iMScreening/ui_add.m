function app = ui_add(parentApp, dataType)

% Create StartUpUIFigure and hide until all components are created
app.UIFigure = uifigure(2);
clf(app.UIFigure);
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100 100 546 241];
app.UIFigure.Name = 'Add Data';

% Create MainGridLayout
app.MainGridLayout = uigridlayout(app.UIFigure);
app.MainGridLayout.ColumnWidth = {'1x'};
app.MainGridLayout.RowHeight = {'1x', '1x', '1x', 25};
app.MainGridLayout.ColumnSpacing = 5;
app.MainGridLayout.RowSpacing = 15;
app.MainGridLayout.Padding = [20 20 20 20];

% Create TargetDataGridLayout
app.TargetDataGridLayout = uigridlayout(app.MainGridLayout);
app.TargetDataGridLayout.ColumnWidth = {'1x', '3x'};
app.TargetDataGridLayout.RowHeight = {'1x'};
app.TargetDataGridLayout.Padding = [0 0 0 0];
app.TargetDataGridLayout.Layout.Row = 1;
app.TargetDataGridLayout.Layout.Column = 1;

% Create TargetDataButton
app.TargetDataButton = uibutton(app.TargetDataGridLayout, 'push');
app.TargetDataButton.Layout.Row = 1;
app.TargetDataButton.Layout.Column = 1;
app.TargetDataButton.Text = 'Target Data';

% Create Label
app.Label = uilabel(app.TargetDataGridLayout);
app.Label.BackgroundColor = [1 1 1];
app.Label.HorizontalAlignment = 'center';
app.Label.WordWrap = 'on';
app.Label.Layout.Row = 1;
app.Label.Layout.Column = 2;
app.Label.Text = '';

% Create RefDataGridLayout
app.RefDataGridLayout = uigridlayout(app.MainGridLayout);
app.RefDataGridLayout.ColumnWidth = {'1x', '3x'};
app.RefDataGridLayout.RowHeight = {'1x'};
app.RefDataGridLayout.Padding = [0 0 0 0];
app.RefDataGridLayout.Layout.Row = 2;
app.RefDataGridLayout.Layout.Column = 1;

% Create RefDataButton
app.RefDataButton = uibutton(app.RefDataGridLayout, 'push');
app.RefDataButton.Layout.Row = 1;
app.RefDataButton.Layout.Column = 1;
app.RefDataButton.Text = 'Ref. Data';

% Create Label_2
app.Label_2 = uilabel(app.RefDataGridLayout);
app.Label_2.BackgroundColor = [1 1 1];
app.Label_2.HorizontalAlignment = 'center';
app.Label_2.WordWrap = 'on';
app.Label_2.Layout.Row = 1;
app.Label_2.Layout.Column = 2;
app.Label_2.Text = '';

% Create LogFileGridLayout
app.LogFileGridLayout = uigridlayout(app.MainGridLayout);
app.LogFileGridLayout.ColumnWidth = {'1x', '3x'};
app.LogFileGridLayout.RowHeight = {'1x'};
app.LogFileGridLayout.Padding = [0 0 0 0];
app.LogFileGridLayout.Layout.Row = 3;
app.LogFileGridLayout.Layout.Column = 1;

% Create LogFileButton
app.LogFileButton = uibutton(app.LogFileGridLayout, 'push');
app.LogFileButton.Layout.Row = 1;
app.LogFileButton.Layout.Column = 1;
app.LogFileButton.Text = 'Log File';

% Create Label_3
app.Label_3 = uilabel(app.LogFileGridLayout);
app.Label_3.BackgroundColor = [1 1 1];
app.Label_3.HorizontalAlignment = 'center';
app.Label_3.WordWrap = 'on';
app.Label_3.Layout.Row = 1;
app.Label_3.Layout.Column = 2;
app.Label_3.Text = '';

% Create NextGridLayout
app.NextGridLayout = uigridlayout(app.MainGridLayout);
app.NextGridLayout.ColumnWidth = {'1x', 120};
app.NextGridLayout.RowHeight = {'1x'};
app.NextGridLayout.Padding = [0 0 0 0];
app.NextGridLayout.Layout.Row = 4;
app.NextGridLayout.Layout.Column = 1;

% Create NextButton
app.NextButton = uibutton(app.NextGridLayout, 'push');
app.NextButton.Layout.Row = 1;
app.NextButton.Layout.Column = 2;
app.NextButton.Text = 'Next';

% Variable
app.UIFigure.UserData.ProcessApp = [];
app.UIFigure.UserData.TargetData = [];
app.UIFigure.UserData.ReferenceData = [];
app.UIFigure.UserData.LogData = [];
app.UIFigure.UserData.MainApp = parentApp;


% Define Callback
app.TargetDataButton.ButtonPushedFcn = @(src, event)LoadButtonPushed(app, src, event);
app.RefDataButton.ButtonPushedFcn = @(src, event)LoadButtonPushed(app, src, event);
app.LogFileButton.ButtonPushedFcn = @(src, event)LoadButtonPushed(app, src, event);

app.NextButton.ButtonPushedFcn = @(src, event)NextButtonPushed(app, src, event);
app.UIFigure.CloseRequestFcn = @(src, event)UIFigureCloseRequest(app, src, event);

%% Start up
if isdeployed; app.UIFigure.WindowStyle = 'modal'; end
if strcmp(dataType, parentApp.UIFigure.UserData.DataType.mini)
    app.RefDataButton.Enable = 'on';
    app.LogFileButton.Enable = 'on';
elseif strcmp(dataType, parentApp.UIFigure.UserData.DataType.Pro)
    app.RefDataButton.Enable = 'off';
    app.LogFileButton.Enable = 'off';
    app.TargetDataButton.Text = 'Select a folder';
else
    app.RefDataButton.Enable = 'off';
    app.LogFileButton.Enable = 'off';
end
WindowPositionToCenter(app.UIFigure, parentApp.UIFigure)
% Show the figure after all components are created
app.UIFigure.Visible = 'on';


%% Function
% Callback
    function LoadButtonPushed(app, ~, event)        
        if strcmp(dataType, parentApp.UIFigure.UserData.DataType.Pro)
            pathName = uigetdir(parentApp.UIFigure.UserData.CurrentPath, 'Please select a parent folder.');
            figure(app.UIFigure);
            if isequal(pathName, 0); return; end
            file = '';
            screeningData = parsingScreeningInfo(pathName);
            if isempty(screeningData)
                return
            end
            loadedData.data = screeningData.Data;            
        else
            [file, pathName] = uigetfile('*.txt', 'Please select a txt file.', parentApp.UIFigure.UserData.CurrentPath);
            figure(app.UIFigure);
            if isequal(file, 0); return; end
            loadedData = importdata(fullfile(pathName, file));
        end
        
        if strcmp(event.Source.Text, 'Ref. Data')
            app.UIFigure.UserData.ReferenceData = loadedData;
            app.Label_2.Text = fullfile(pathName, file);
        elseif strcmp(event.Source.Text, 'Log File')
            app.UIFigure.UserData.LogData = loadedData;
            app.Label_3.Text = fullfile(pathName, file);
        else
            app.UIFigure.UserData.TargetData = loadedData;
            app.Label.Text = fullfile(pathName, file);
        end
        
        parentApp.UIFigure.UserData.CurrentPath = pathName;
    end
    
    function NextButtonPushed(app, ~, ~)
        if strcmp(dataType, parentApp.UIFigure.UserData.DataType.mini)
            if isempty(app.Label.Text) || isempty(app.Label_2.Text) || isempty(app.Label_3.Text)
                return                
            end
        else
            if isempty(app.Label.Text)
                return                
            end
        end
        
        app.UIFigure.Visible = 'off';
        app.UIFigure.UserData.ProcessApp = ui_processing(app, dataType);
        waitfor(app.UIFigure.UserData.ProcessApp.UIFigure);
        app.UIFigure.UserData.ProcessApp = [];
        disp('Processing app closed')
        app.UIFigure.Visible = 'on';
    
        if ~isempty(parentApp.UIFigure.UserData.AddCurves)
            UIFigureCloseRequest(app, [], [])
        end
    end

    function UIFigureCloseRequest(app, ~, ~)
        delete(app.UIFigure)
    end
end