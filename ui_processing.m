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
app.MidGridLayout.ColumnWidth = {'1x', 150, 150};
app.MidGridLayout.RowHeight = {'1x'};
app.MidGridLayout.ColumnSpacing = 5;
app.MidGridLayout.Padding = [0 0 0 0];
app.MidGridLayout.Layout.Row = 2;
app.MidGridLayout.Layout.Column = 1;

% Create stInjectionstartpointsPanel
app.stInjectionstartpointsPanel = uipanel(app.MidGridLayout);
app.stInjectionstartpointsPanel.Title = '1st Injection start point (s)';
app.stInjectionstartpointsPanel.Layout.Row = 1;
app.stInjectionstartpointsPanel.Layout.Column = 1;

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
app.ApplyButton.Layout.Column = 2;
app.ApplyButton.Text = 'Apply';

% Create TargetRefButton
app.TargetRefButton = uibutton(app.MidGridLayout, 'push');
app.TargetRefButton.Layout.Row = 1;
app.TargetRefButton.Layout.Column = 3;
app.TargetRefButton.Text = 'Target - Ref.';

% Variable

% Define Callback
app.ResetButton.ButtonPushedFcn = @(src, event) ResetButtonPushed(app, src, event);
app.NextButton.ButtonPushedFcn = @(src, event) NextButtonPushed(app, src, event);
app.ApplyButton.ButtonPushedFcn = @(src, event) ApplyButtonPushed(app, src, event);
app.TargetRefButton.ButtonPushedFcn = @(src, event) TargetRefButtonPushed(app, src, event);
app.UIFigure.CloseRequestFcn = @(src, event) UIFigureCloseRequestFcn(app, src, event);

%% Start up

if strcmp(dataType, parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.DataType.mini)
    % iMSPR-mini Data
    % UI Setting
    app.stInjectionstartpointsPanel.Title = '1st Injection start point (s)';
    app.TargetLabel = 'Target :';
    app.RefSpinnerLabel = 'Ref :';
    app.TargetRefButton.Enable = 'on';
    app.TargetRefButton.Visible = 'on';
    % Data

else
    % Others (Biacore, iMSPR-Pro Data)
    % UI Setting
    app.stInjectionstartpointsPanel.Title = 'Range of interest (s)';
    app.TargetLabel = 'Start :';
    app.RefSpinnerLabel = 'End :';
    app.TargetRefButton.Enable = 'off';
    app.TargetRefButton.Visible = 'off';
    % Data

end

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

app.UIFigure.UserData.targetX = parentApp.UIFigure.UserData.TargetData.data(:, 1);

for col = 1:size(parentApp.UIFigure.UserData.TargetData.data, 2)
    %TODO
end

app.UIFigure.UserData.targetY = parentApp.UIFigure.UserData.TargetData.data(:, 2);
app.UIFigure.UserData.targetY = app.UIFigure.UserData.targetY - app.UIFigure.UserData.targetY(1);

app.UIFigure.UserData.LogData = parentApp.UIFigure.UserData.LogData;
app.UIFigure.UserData.referenceX = parentApp.UIFigure.UserData.ReferenceData.data(:, 1);
app.UIFigure.UserData.referenceY = parentApp.UIFigure.UserData.ReferenceData.data(:, 2);
app.UIFigure.UserData.referenceY = app.UIFigure.UserData.referenceY - app.UIFigure.UserData.referenceY(1);

ResetButtonPushed(app, [], []);
parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.AddCurves = [];

%% Function
    % Callback
    function ResetButtonPushed(app, ~, ~)
        app.UIFigure.UserData.targetYShifted = app.UIFigure.UserData.targetY;

        app.UIFigure.UserData.referenceYShifted = app.UIFigure.UserData.referenceY;
        app.UIFigure.UserData.ProcessedY = [];
        SetLimitsOfSpinners(app);
        
        cla(app.UIAxes)
        plot(app.UIAxes, app.UIFigure.UserData.targetYShifted)
        hold(app.UIAxes, 'on')
        plot(app.UIAxes, app.UIFigure.UserData.referenceYShifted)
        legend(app.UIAxes, 'Target', 'Reference')
    end
    
    
    function NextButtonPushed(app, ~, ~)
        if isempty(app.UIFigure.UserData.ProcessedY)
            return
        end
    
        curves = SplitCurve(app);
        parentApp.UIFigure.UserData.MainApp.UIFigure.UserData.AddCurves = curves;
        
        UIFigureCloseRequestFcn(app, [], []);
    end
    
    
    function ApplyButtonPushed(app, ~, ~)
        gap = app.RefSpinner.Value - app.TargetSpinner.Value;
                    
        app.UIFigure.UserData.targetYShifted = app.UIFigure.UserData.targetY;
        app.UIFigure.UserData.referenceYShifted = app.UIFigure.UserData.referenceY;
        
        if gap >= 0 % Ref is right than Target
            app.UIFigure.UserData.targetYShifted(end-gap+1:end) = [];
            app.UIFigure.UserData.referenceYShifted(1:gap) = [];
        else % Ref is left than Target
            app.UIFigure.UserData.targetYShifted(1:abs(gap)) = [];
            app.UIFigure.UserData.referenceYShifted(end-abs(gap)+1:end) = [];
        end

        SetLimitsOfSpinners(app);
        
        cla(app.UIAxes)
        plot(app.UIAxes, app.UIFigure.UserData.targetYShifted)
        hold(app.UIAxes, 'on')
        plot(app.UIAxes, app.UIFigure.UserData.referenceYShifted)
        legend(app.UIAxes, 'Target', 'Reference')
    end
    
    
    function TargetRefButtonPushed(app, ~, ~)
        app.UIFigure.UserData.ProcessedY = app.UIFigure.UserData.targetYShifted - app.UIFigure.UserData.referenceYShifted;
                    
        cla(app.UIAxes)
        plot(app.UIAxes, app.UIFigure.UserData.ProcessedY)    
    end
    
    
    function UIFigureCloseRequestFcn(app, ~, ~)
        delete(app.UIFigure);
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
        stabilizationEndTime = stabilizationEndTime - tmpStartTime + correctedInjectionStartTime;
        
        % Cut data from InjectionStart to StabilizationEnd
        cyclePeriod = round(mean(stabilizationEndTime - injectionStartTime));
        
        for i = 1:size(injectionStartTime, 1)
            if size(app.UIFigure.UserData.ProcessedY, 1) < injectionStartTime(i)+cyclePeriod
                app.UIFigure.UserData.ProcessedY(size(app.UIFigure.UserData.ProcessedY, 1)+1 : injectionStartTime(i)+cyclePeriod) = nan;
            end
            periodDiffY{i, 1} = app.UIFigure.UserData.ProcessedY(injectionStartTime(i) : injectionStartTime(i)+cyclePeriod);    
            periodDiffY{i, 1} = periodDiffY{i, 1} - periodDiffY{i, 1}(1);
        
        end
    
        curves = periodDiffY;
    
    end


    function SetLimitsOfSpinners(app)
        app.TargetSpinner.Limits(2) = length(app.UIFigure.UserData.targetYShifted);
        app.RefSpinner.Limits(2) = length(app.UIFigure.UserData.referenceYShifted);        
    end

    

end
