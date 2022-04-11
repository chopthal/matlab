function app = ui_move_curve(parentApp)

% Create UIFigure and hide until all components are created
app.UIFigure = uifigure('Visible', 'off');
app.UIFigure.Position = [100 100 380 115];
app.UIFigure.Name = 'Curve move';

% Create OKButton
app.OKButton = uibutton(app.UIFigure, 'push');
app.OKButton.Position = [152 22 100 22];
app.OKButton.Text = 'OK';

% Create CancelButton
app.CancelButton = uibutton(app.UIFigure, 'push');
app.CancelButton.Position = [256 22 100 22];
app.CancelButton.Text = 'Cancel';

% Create XEditFieldLabel
app.XEditFieldLabel = uilabel(app.UIFigure);
app.XEditFieldLabel.HorizontalAlignment = 'right';
app.XEditFieldLabel.Position = [25 69 25 22];
app.XEditFieldLabel.Text = 'X :';

% Create XEditField
app.XEditField = uieditfield(app.UIFigure, 'numeric');
app.XEditField.Position = [65 69 100 22];

% Create YEditFieldLabel
app.YEditFieldLabel = uilabel(app.UIFigure);
app.YEditFieldLabel.HorizontalAlignment = 'right';
app.YEditFieldLabel.Position = [208 69 25 22];
app.YEditFieldLabel.Text = 'Y :';

% Create YEditField
app.YEditField = uieditfield(app.UIFigure, 'numeric');
app.YEditField.Position = [248 69 100 22];

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

% Start-up
WindowPositionToCenter(app.UIFigure, parentApp.UIFigure)
parentApp.UIFigure.UserData.MoveCurve = [];
app.UIFigure.UserData.ParentApp = parentApp;

% Callback
app.OKButton.ButtonPushedFcn = @(src, event) OKButtonPushed(app, src, event);


%% Function
% Callback
    function OKButtonPushed(app, ~, ~)
        app.UIFigure.UserData.ParentApp.UIFigure.UserData.MoveCurve = [app.XEditField.Value, app.YEditField.Value];
        delete(app.UIFigure);
    end

end