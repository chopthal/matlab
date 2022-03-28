function app = ui_processing(parentApp, dataType)

% Create UIFigure and hide until all components are created
app.UIFigure = uifigure(3);
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100 100 826 511];
app.UIFigure.Name = 'iMDataProcessing';

% Create MainGridLayout
app.MainGridLayout = uigridlayout(app.UIFigure);
app.MainGridLayout.ColumnWidth = {'1x'};
app.MainGridLayout.RowHeight = {'1x', 70, 30};
app.MainGridLayout.ColumnSpacing = 5;
app.MainGridLayout.RowSpacing = 15;

% Create UIAxes
% app.UIAxes = uiaxes(app.MainGridLayout);
app.UIAxes = uiaxes(app.MainGridLayout);
title(app.UIAxes, 'Title')
xlabel(app.UIAxes, 'X')
ylabel(app.UIAxes, 'Y')
zlabel(app.UIAxes, 'Z')
app.UIAxes.Layout.Row = 1;
app.UIAxes.Layout.Column = 1;

% Create BottomGridLayout
app.BottomGridLayout = uigridlayout(app.MainGridLayout);
app.BottomGridLayout.ColumnWidth = {'1x', 100, 100, 100};
app.BottomGridLayout.RowHeight = {'1x'};
app.BottomGridLayout.Padding = [0 0 0 0];
app.BottomGridLayout.Layout.Row = 3;
app.BottomGridLayout.Layout.Column = 1;

% Create ResetButton
app.ResetButton = uibutton(app.BottomGridLayout, 'push');
app.ResetButton.Layout.Row = 1;
app.ResetButton.Layout.Column = 3;
app.ResetButton.Text = 'Reset';

% Create NextButton
app.NextButton = uibutton(app.BottomGridLayout, 'push');
app.NextButton.Layout.Row = 1;
app.NextButton.Layout.Column = 4;
app.NextButton.Text = 'Next';

% Create MidGridLayout
app.MidGridLayout = uigridlayout(app.MainGridLayout);
app.MidGridLayout.ColumnWidth = {'1x', '2x', 150, 150};
app.MidGridLayout.RowHeight = {'1x'};
app.MidGridLayout.ColumnSpacing = 5;
app.MidGridLayout.Padding = [0 0 0 0];
app.MidGridLayout.Layout.Row = 2;
app.MidGridLayout.Layout.Column = 1;

% Create AddtionalTimeBeforeEachInjectionsPanel
app.AddtionalTimeBeforeEachInjectionsPanel = uipanel(app.MidGridLayout);
app.AddtionalTimeBeforeEachInjectionsPanel.Title = 'Addtional time before each injections (s)';
app.AddtionalTimeBeforeEachInjectionsPanel.Layout.Row = 1;
app.AddtionalTimeBeforeEachInjectionsPanel.Layout.Column = 1;

% Create AddGridLayout
app.AddGridLayout = uigridlayout(app.AddtionalTimeBeforeEachInjectionsPanel);
app.AddGridLayout.ColumnWidth = {'1x'};
app.AddGridLayout.RowHeight = {'1x'};

% Create AddLabel
app.AddLabel = uilabel(app.AddGridLayout);
app.AddLabel.HorizontalAlignment = 'right';
app.AddLabel.Layout.Row = 1;
app.AddLabel.Layout.Column = 1;
app.AddLabel.Text = 'Add :';

% Create AddSpinner
app.AddSpinner = uispinner(app.AddGridLayout);
app.AddSpinner.ValueDisplayFormat = '%.0f';
app.AddSpinner.Layout.Row = 1;
app.AddSpinner.Layout.Column = 2;
app.AddSpinner.Limits = [0 10];

% Create stInjectionstartpointsPanel
app.stInjectionstartpointsPanel = uipanel(app.MidGridLayout);
app.stInjectionstartpointsPanel.Title = '1st Injection start point (s)';
app.stInjectionstartpointsPanel.Layout.Row = 1;
app.stInjectionstartpointsPanel.Layout.Column = 2;

% Create InjectionGridLayout
app.InjectionGridLayout = uigridlayout(app.stInjectionstartpointsPanel);
app.InjectionGridLayout.ColumnWidth = {'1x', '1x', '1x', '1x'};
app.InjectionGridLayout.RowHeight = {'1x'};

% Create TargetLabel
app.TargetLabel = uilabel(app.InjectionGridLayout);
app.TargetLabel.HorizontalAlignment = 'right';
app.TargetLabel.Layout.Row = 1;
app.TargetLabel.Layout.Column = 1;
app.TargetLabel.Text = 'Target :';

% Create TargetSpinner
app.TargetSpinner = uispinner(app.InjectionGridLayout);
app.TargetSpinner.ValueDisplayFormat = '%.0f';
app.TargetSpinner.Layout.Row = 1;
app.TargetSpinner.Layout.Column = 2;
app.TargetSpinner.Limits = [1 inf];

% Create RefSpinnerLabel
app.RefSpinnerLabel = uilabel(app.InjectionGridLayout);
app.RefSpinnerLabel.HorizontalAlignment = 'right';
app.RefSpinnerLabel.Layout.Row = 1;
app.RefSpinnerLabel.Layout.Column = 3;
app.RefSpinnerLabel.Text = 'Ref. :';

% Create RefSpinner
app.RefSpinner = uispinner(app.InjectionGridLayout);
app.RefSpinner.ValueDisplayFormat = '%.0f';
app.RefSpinner.Layout.Row = 1;
app.RefSpinner.Layout.Column = 4;
app.RefSpinner.Limits = [1 inf];

% Create ApplyButton
app.ApplyButton = uibutton(app.MidGridLayout, 'push');
app.ApplyButton.Layout.Row = 1;
app.ApplyButton.Layout.Column = 3;
app.ApplyButton.Text = 'Apply';

% Create TargetRefButton
app.TargetRefButton = uibutton(app.MidGridLayout, 'push');
app.TargetRefButton.Layout.Row = 1;
app.TargetRefButton.Layout.Column = 4;
app.TargetRefButton.Text = 'Target - Ref.';

% Variable
app.UIFigure.UserData.LogData = [];
app.UIFigure.UserData.referenceX = [];
app.UIFigure.UserData.referenceY = [];
app.UIFigure.UserData.referenceY = [];

% Define Callback
app.ResetButton.ButtonPushedFcn = @(src, event) ResetButtonPushed(app, src, event);
app.NextButton.ButtonPushedFcn = @(src, event) NextButtonPushed(app, src, event);
app.ApplyButton.ButtonPushedFcn = @(src, event) ApplyButtonPushed(app, src, event);
app.TargetRefButton.ButtonPushedFcn = @(src, event) TargetRefButtonPushed(app, src, event);
app.UIFigure.CloseRequestFcn = @(src, event) UIFigureCloseRequestFcn(app, src, event);
app.AddSpinner.ValueChangedFcn = @(src, event) AddSpinnerValueChanged(app, src, event);
app.TargetSpinner.ValueChangedFcn = @(src, event) AddSpinnerValueChanged(app, src, event);
app.RefSpinner.ValueChangedFcn = @(src, event) AddSpinnerValueChanged(app, src, event);

%% Start up

if strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.mini)
    % iMSPR-mini Data
    % UI Setting
    app.stInjectionstartpointsPanel.Title = '1st Injection start point (s)';
    app.AddtionalTimeBeforeEachInjectionsPanel.Enable = 'on';
    app.TargetLabel.Text = 'Target :';
    app.RefSpinnerLabel.Text = 'Ref :';
    app.TargetRefButton.Enable = 'on';    
    % Data        
    app.UIFigure.UserData.targetX{1, 1} = parentApp.UIFigure.UserData.TargetData.data(:, 1);
    app.UIFigure.UserData.targetY{1, 1} = parentApp.UIFigure.UserData.TargetData.data(:, 2);
    app.UIFigure.UserData.targetY{1, 1} = app.UIFigure.UserData.targetY{1, 1} - app.UIFigure.UserData.targetY{1, 1}(1);    
    app.UIFigure.UserData.LogData = parentApp.UIFigure.UserData.LogData;
    app.UIFigure.UserData.referenceX{1, 1} = parentApp.UIFigure.UserData.ReferenceData.data(:, 1);
    app.UIFigure.UserData.referenceY{1, 1} = parentApp.UIFigure.UserData.ReferenceData.data(:, 2);
    app.UIFigure.UserData.referenceY{1, 1} = app.UIFigure.UserData.referenceY{1, 1} - app.UIFigure.UserData.referenceY{1, 1}(1);

elseif strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.Biacore)
    % Biacore Data
    % UI Setting
    app.stInjectionstartpointsPanel.Title = 'Range of interest (s)';
    app.TargetLabel.Text = 'Start :';
    app.RefSpinnerLabel.Text = 'End :';
    app.AddtionalTimeBeforeEachInjectionsPanel.Enable = 'off';
    app.TargetRefButton.Enable = 'off';    
    % Data
    for col = 1:size(parentApp.UIFigure.UserData.TargetData.data, 2)/2
        app.UIFigure.UserData.targetX{col, 1} = parentApp.UIFigure.UserData.TargetData.data(:, col);
        app.UIFigure.UserData.targetY{col, 1} = parentApp.UIFigure.UserData.TargetData.data(:, 2*col);
        app.UIFigure.UserData.targetY{col, 1} =...
            app.UIFigure.UserData.targetY{col, 1} - app.UIFigure.UserData.targetY{col, 1}(1);
        app.UIFigure.UserData.referenceX = app.UIFigure.UserData.targetX{col, 1};
        app.UIFigure.UserData.referenceY{col, 1} = zeros(size(app.UIFigure.UserData.targetY{col, 1}));    
        
    end
end

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

if mod(size(parentApp.UIFigure.UserData.TargetData.data, 2), 2) == 1
    disp('Invalid Data')
end

ResetButtonPushed(app, [], []);
parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.AddCurves = [];

%% Function
    % Callback
    function ResetButtonPushed(app, ~, ~)
        app.UIFigure.UserData.targetYApplied = app.UIFigure.UserData.targetY;
        app.UIFigure.UserData.referenceYApplied = app.UIFigure.UserData.referenceY;
        app.UIFigure.UserData.ProcessedY = [];
        SetLimitsOfSpinners(app);      
        PlotData(app);
        
        if strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.Biacore)
            lenData = zeros(size(parentApp.UIFigure.UserData.TargetData.data, 2)/2, 1);
            for i = 1:size(app.UIFigure.UserData.targetX, 1)
                lenData = length(app.UIFigure.UserData.targetX{col, 1});
            end
            app.RefSpinner.Value = max(lenData);
        end
    end
    
    
    function NextButtonPushed(app, ~, ~)
        if isempty(app.UIFigure.UserData.ProcessedY)
            return
        end
        
        if strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.mini)
            curves = SplitCurve(app);
        elseif strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.Biacore)
            curves = app.UIFigure.UserData.targetYApplied;
        end
        
        parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.AddCurves = curves;        
        UIFigureCloseRequestFcn(app, [], []);
    end
    
    
    function ApplyButtonPushed(app, ~, ~)
        app.UIFigure.UserData.targetYApplied = app.UIFigure.UserData.targetY;
        app.UIFigure.UserData.referenceYApplied = app.UIFigure.UserData.referenceY;

        if strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.mini)
            gap = app.RefSpinner.Value - app.TargetSpinner.Value;
            if gap >= 0 % Ref is right than Target
                app.UIFigure.UserData.targetYApplied{1, 1}(end-gap+1:end) = [];
                app.UIFigure.UserData.referenceYApplied{1, 1}(1:gap) = [];
            else % Ref is left than Target
                app.UIFigure.UserData.targetYApplied{1, 1}(1:abs(gap)) = [];
                app.UIFigure.UserData.referenceYApplied{1, 1}(end-abs(gap)+1:end) = [];
            end
        elseif strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.Biacore)
            startPoint = app.TargetSpinner.Value;
            endPoint = app.RefSpinner.Value;
            if startPoint >= endPoint
                uialert(app.UIFigure, 'Start should be earlier than End!', 'Error');
                return
            end

            for i = 1:size(app.UIFigure.UserData.targetYApplied, 1)
                app.UIFigure.UserData.targetYApplied{i, 1} =...
                app.UIFigure.UserData.targetYApplied{i, 1}(startPoint:endPoint);
                app.UIFigure.UserData.referenceYApplied{i, 1} =...
                    app.UIFigure.UserData.referenceYApplied{i, 1}(startPoint:endPoint);
            end
            app.UIFigure.UserData.ProcessedY = app.UIFigure.UserData.targetYApplied;
        end                 
        PlotData(app);
    end
    
    
    function TargetRefButtonPushed(app, ~, ~)
        app.UIFigure.UserData.ProcessedY{1, 1} = app.UIFigure.UserData.targetYApplied{1, 1} - app.UIFigure.UserData.referenceYApplied{1, 1};
                    
        cla(app.UIAxes)
        plot(app.UIAxes, app.UIFigure.UserData.ProcessedY{1, 1})    
    end
    
    
    function UIFigureCloseRequestFcn(app, ~, ~)
        delete(app.UIFigure);
    end

    
    function AddSpinnerValueChanged(app, ~, ~)
        value = min(app.TargetSpinner.Value, app.RefSpinner.Value);
        if app.AddSpinner.Value >= value
            uialert(app.UIFigure, 'Add should be smaller than Target and Ref!', 'Error');
            app.AddSpinner.Value = value - 1;
        end
    end


    % Business logic
    % TODO
    function curves = SplitCurve(app)
    
        curves = [];
    
        timingData = parentApp.UIFigure.UserData.LogData;
        divideString = ' : ';
        tmpEvent = split(timingData, divideString);
        
        [x, ~] = find(ismember(tmpEvent, 'Injection Start'));
        tmpTimeStr = tmpEvent(x, 2);
        
        injectionStartTime = zeros(size(tmpTimeStr));
        for i = 1:size(tmpTimeStr, 1)
            tmpSplit = split(tmpTimeStr{i, 1}, ' ');
            injectionStartTime(i) = str2double(tmpSplit{1});
        end
        
        [x, ~] = find(ismember(tmpEvent, 'Stabilization End'));
        tmpTimeStr = tmpEvent(x, 2);
        
        stabilizationEndTime = zeros(size(tmpTimeStr));
        for i = 1:size(tmpTimeStr, 1)
            tmpSplit = split(tmpTimeStr{i, 1}, ' ');
            stabilizationEndTime(i) = str2double(tmpSplit{1});
        end
        
        if size(injectionStartTime, 1) ~= size(stabilizationEndTime, 1); return; end
        
        correctedInjectionStartTime = app.TargetSpinner.Value;
        tmpStartTime = injectionStartTime(1);
        injectionStartTime = injectionStartTime - tmpStartTime + correctedInjectionStartTime;
        injectionStartTime = injectionStartTime - app.AddSpinner.Value;
        stabilizationEndTime = stabilizationEndTime - tmpStartTime + correctedInjectionStartTime;
        
        % Cut data from InjectionStart to StabilizationEnd
        cyclePeriod = round(mean(stabilizationEndTime - injectionStartTime));
        
        for i = 1:size(injectionStartTime, 1)
            if size(app.UIFigure.UserData.ProcessedY{1, 1}, 1) < injectionStartTime(i)+cyclePeriod
                app.UIFigure.UserData.ProcessedY{1, 1}...
                    (size(app.UIFigure.UserData.ProcessedY, 1)+1 : injectionStartTime(i)+cyclePeriod)...
                    = nan;
            end
            periodDiffY{i, 1} = app.UIFigure.UserData.ProcessedY{1, 1}(injectionStartTime(i)...
                : injectionStartTime(i)+cyclePeriod);    
            periodDiffY{i, 1} = periodDiffY{i, 1} - periodDiffY{i, 1}(1);
        
        end
    
        curves = periodDiffY;
    
    end


    function SetLimitsOfSpinners(app)
        maxCandTarget = zeros(size(app.UIFigure.UserData.targetYApplied, 1), 1);
        maxCandRef = zeros(size(app.UIFigure.UserData.targetYApplied, 1), 1);
        for i = 1:size(app.UIFigure.UserData.targetYApplied, 1)
            maxCandTarget(i) = length(app.UIFigure.UserData.targetYApplied{i, 1});
            maxCandRef(i) = length(app.UIFigure.UserData.referenceYApplied{i, 1});        
        end

        app.TargetSpinner.Limits(2) = max(maxCandTarget);
        app.RefSpinner.Limits(2) = max(maxCandRef);
    end

    
    function PlotData(app)
        cla(app.UIAxes);        
        for i = 1:size(app.UIFigure.UserData.targetYApplied, 1)
            hold(app.UIAxes, 'on')
            plot(app.UIAxes, app.UIFigure.UserData.targetYApplied{i, 1})
            hold(app.UIAxes, 'on')    
            if strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.mini)
                plot(app.UIAxes, app.UIFigure.UserData.referenceYApplied{i, 1})
                legend(app.UIAxes, 'Target', 'Reference')
            end
        end    
        hold(app.UIAxes, 'off');
    end
end
