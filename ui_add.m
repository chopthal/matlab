function app = ui_add(parentApp)

% Create StartUpUIFigure and hide until all components are created
app.UIFigure = uifigure(2);
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

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

% Variable
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


%% Function
% Callback
    function LoadButtonPushed(app, ~, event)
        [file, path] = uigetfile('*.txt', 'Please select a txt file.', parentApp.UIFigure.UserData.CurrentPath);
        
        if isequal(file, 0)
            return
        end
        
        tmpData = importdata(fullfile(path, file));
        
        if strcmp(event.Source.Text, 'Target Data')
            app.UIFigure.UserData.TargetData = tmpData;
            app.Label.Text = fullfile(path, file);
        elseif strcmp(event.Source.Text, 'Ref. Data')
            app.UIFigure.UserData.ReferenceData = tmpData;
            app.Label_2.Text = fullfile(path, file);
        elseif strcmp(event.Source.Text, 'Log File')
            app.UIFigure.UserData.LogData = tmpData;
            app.Label_3.Text = fullfile(path, file);
        end
        
        parentApp.UIFigure.UserData.CurrentPath = path;
    end
    
    function NextButtonPushed(app, ~, ~)
        if isempty(app.Label.Text) || isempty(app.Label_2.Text) || isempty(app.Label_3.Text)
            return                
        end
        
        app.UIFigure.Visible = 'off';
        processingApp = ui_processing(app);
        waitfor(processingApp.UIFigure);
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