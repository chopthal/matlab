function app = ui_processing(parentApp)

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
app.UIAxes = axes(app.MainGridLayout);
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
app.MidGridLayout.ColumnWidth = {'1x', '4x', 100, 100};
app.MidGridLayout.RowHeight = {'1x'};
app.MidGridLayout.ColumnSpacing = 5;
app.MidGridLayout.Padding = [0 0 0 0];
app.MidGridLayout.Layout.Row = 2;
app.MidGridLayout.Layout.Column = 1;

% Create BaselinesPanel
app.BaselinesPanel = uipanel(app.MidGridLayout);
app.BaselinesPanel.Title = 'Base line (s)';
app.BaselinesPanel.Layout.Row = 1;
app.BaselinesPanel.Layout.Column = 1;

% Create BaseLineGridLayout
app.BaseLineGridLayout = uigridlayout(app.BaselinesPanel);
app.BaseLineGridLayout.ColumnWidth = {'1x'};
app.BaseLineGridLayout.RowHeight = {'1x'};

% Create BaseLineSpinner
app.BaseLineSpinner = uispinner(app.BaseLineGridLayout);
app.BaseLineSpinner.ValueDisplayFormat = '%.0f';
app.BaseLineSpinner.Layout.Row = 1;
app.BaseLineSpinner.Layout.Column = 1;

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

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

% Variable

% Define Callback
app.ResetButton.ButtonPushedFcn = @(src, event) ResetButtonPushed(app, src, event);
app.NextButton.ButtonPushedFcn = @(src, event) NextButtonPushed(app, src, event);
app.ApplyButton.ButtonPushedFcn = @(src, event) ApplyButtonPushed(app, src, event);
app.TargetRefButton.ButtonPushedFcn = @(src, event) TargetRefButtonPushed(app, src, event);

%% Start up
app.UIFigure.UserData.LogData = parentApp.UIFigure.UserData.LogData;

app.UIFigure.UserData.targetX = parentApp.UIFigure.UserData.TargetData.data(:, 1);
app.UIFigure.UserData.targetY = parentApp.UIFigure.UserData.TargetData.data(:, 2);
app.UIFigure.UserData.targetY = app.UIFigure.UserData.targetY - app.UIFigure.UserData.targetY(1);
app.UIFigure.UserData.referenceX = parentApp.UIFigure.UserData.ReferenceData.data(:, 1);
app.UIFigure.UserData.referenceY = parentApp.UIFigure.UserData.ReferenceData.data(:, 2);
app.UIFigure.UserData.referenceY = app.UIFigure.UserData.referenceY - app.UIFigure.UserData.referenceY(1);

plot(app.UIAxes, app.UIFigure.UserData.targetX, app.UIFigure.UserData.targetY)
hold(app.UIAxes, 'on')
plot(app.UIAxes, app.UIFigure.UserData.referenceX, app.UIFigure.UserData.referenceY)
legend(app.UIAxes, 'Target', 'Reference')


%% Function
% Callback
function ResetButtonPushed(app, ~, ~)
    app.UIFigure.UserData.targetYShifted = app.UIFigure.UserData.targetY;
    app.UIFigure.UserData.referenceYShifted = app.UIFigure.UserData.referenceY;
    app.UIFigure.UserData.DiffY = [];
    
    cla(app.UIAxes)
    plot(app.UIAxes, app.UIFigure.UserData.targetYShifted)
    hold(app.UIAxes, 'on')
    plot(app.UIAxes, app.UIFigure.UserData.referenceYShifted)
    legend(app.UIAxes, 'Target', 'Reference')
end


function NextButtonPushed(app, ~, ~)
    if isempty(app.UIFigure.UserData.DiffY)
        return
    end
    
    UI_iMScreening_Evaluate(app)
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
    
    cla(app.UIAxes)
    plot(app.UIAxes, app.UIFigure.UserData.targetYShifted)
    hold(app.UIAxes, 'on')
    plot(app.UIAxes, app.UIFigure.UserData.referenceYShifted)
    legend(app.UIAxes, 'Target', 'Reference')
end


function TargetRefButtonPushed(app, ~, ~)
    app.UIFigure.UserData.DiffY = app.UIFigure.UserData.targetYShifted - app.UIFigure.UserDatapp.referenceYShifted;
                
    cla(app.UIAxes)
    plot(app.UIAxes, app.UIFigure.UserData.DiffY)    
end

    

end