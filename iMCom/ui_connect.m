function app = ui_connect(MainApp)

app = struct;

% Create UIFigure and hide until all components are created
app.UIFigure = uifigure(2);
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100 100 472 206];
app.UIFigure.Name = 'Connect';
app.UIFigure.Resize = 'off';
app.UIFigure.WindowStyle = 'modal';

% Create GridLayout
app.GridLayout = uigridlayout(app.UIFigure);
app.GridLayout.ColumnWidth = {'1x'};
app.GridLayout.RowHeight = {30, 30, 30, 30, 25};

% Create GridLayout2
app.GridLayout2 = uigridlayout(app.GridLayout);
app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', '1x'};
app.GridLayout2.RowHeight = {'1x'};
app.GridLayout2.Padding = [0 0 0 0];
app.GridLayout2.Layout.Row = 1;
app.GridLayout2.Layout.Column = 1;

% Create PortDropDownLabel
app.PortDropDownLabel = uilabel(app.GridLayout2);
app.PortDropDownLabel.HorizontalAlignment = 'right';
app.PortDropDownLabel.Layout.Row = 1;
app.PortDropDownLabel.Layout.Column = 1;
app.PortDropDownLabel.Text = 'Port :';

% Create PortDropDown
app.PortDropDown = uidropdown(app.GridLayout2);
app.PortDropDown.Items = {'COM1'};
app.PortDropDown.Layout.Row = 1;
app.PortDropDown.Layout.Column = 2;
app.PortDropDown.Value = 'COM1';

% Create StopBitsbitDropDownLabel
app.StopBitsbitDropDownLabel = uilabel(app.GridLayout2);
app.StopBitsbitDropDownLabel.HorizontalAlignment = 'right';
app.StopBitsbitDropDownLabel.Layout.Row = 1;
app.StopBitsbitDropDownLabel.Layout.Column = 3;
app.StopBitsbitDropDownLabel.Text = 'StopBits (bit) :';

% Create StopBitsbitDropDown
app.StopBitsbitDropDown = uidropdown(app.GridLayout2);
app.StopBitsbitDropDown.Items = {'1', '1.5', '2'};
app.StopBitsbitDropDown.Layout.Row = 1;
app.StopBitsbitDropDown.Layout.Column = 4;
app.StopBitsbitDropDown.Value = '1';

% Create GridLayout2_2
app.GridLayout2_2 = uigridlayout(app.GridLayout);
app.GridLayout2_2.ColumnWidth = {'1x', '1x', '1x', '1x'};
app.GridLayout2_2.RowHeight = {'1x'};
app.GridLayout2_2.Padding = [0 0 0 0];
app.GridLayout2_2.Layout.Row = 2;
app.GridLayout2_2.Layout.Column = 1;

% Create BaudRateEditFieldLabel
app.BaudRateEditFieldLabel = uilabel(app.GridLayout2_2);
app.BaudRateEditFieldLabel.HorizontalAlignment = 'right';
app.BaudRateEditFieldLabel.Layout.Row = 1;
app.BaudRateEditFieldLabel.Layout.Column = 1;
app.BaudRateEditFieldLabel.Text = 'BaudRate :';

% Create BaudRateEditField
app.BaudRateEditField = uieditfield(app.GridLayout2_2, 'numeric');
app.BaudRateEditField.Limits = [110 921600];
app.BaudRateEditField.RoundFractionalValues = 'on';
app.BaudRateEditField.ValueDisplayFormat = '%.0f';
app.BaudRateEditField.Layout.Row = 1;
app.BaudRateEditField.Layout.Column = 2;
app.BaudRateEditField.Value = 9600;

% Create FlowControlDropDownLabel
app.FlowControlDropDownLabel = uilabel(app.GridLayout2_2);
app.FlowControlDropDownLabel.HorizontalAlignment = 'right';
app.FlowControlDropDownLabel.Layout.Row = 1;
app.FlowControlDropDownLabel.Layout.Column = 3;
app.FlowControlDropDownLabel.Text = 'FlowControl :';

% Create FlowControlDropDown
app.FlowControlDropDown = uidropdown(app.GridLayout2_2);
app.FlowControlDropDown.Items = {'none', 'hardware', 'software'};
app.FlowControlDropDown.Layout.Row = 1;
app.FlowControlDropDown.Layout.Column = 4;
app.FlowControlDropDown.Value = 'none';

% Create GridLayout2_3
app.GridLayout2_3 = uigridlayout(app.GridLayout);
app.GridLayout2_3.ColumnWidth = {'1x', '1x', '1x', '1x'};
app.GridLayout2_3.RowHeight = {'1x'};
app.GridLayout2_3.Padding = [0 0 0 0];
app.GridLayout2_3.Layout.Row = 3;
app.GridLayout2_3.Layout.Column = 1;

% Create DataBitsbitDropDownLabel
app.DataBitsbitDropDownLabel = uilabel(app.GridLayout2_3);
app.DataBitsbitDropDownLabel.HorizontalAlignment = 'right';
app.DataBitsbitDropDownLabel.Layout.Row = 1;
app.DataBitsbitDropDownLabel.Layout.Column = 1;
app.DataBitsbitDropDownLabel.Text = 'DataBits (bit) :';

% Create DataBitsbitDropDown
app.DataBitsbitDropDown = uidropdown(app.GridLayout2_3);
app.DataBitsbitDropDown.Items = {'8', '7', '6', '5'};
app.DataBitsbitDropDown.Layout.Row = 1;
app.DataBitsbitDropDown.Layout.Column = 2;
app.DataBitsbitDropDown.Value = '8';

% Create TimeoutsEditFieldLabel
app.TimeoutsEditFieldLabel = uilabel(app.GridLayout2_3);
app.TimeoutsEditFieldLabel.HorizontalAlignment = 'right';
app.TimeoutsEditFieldLabel.Layout.Row = 1;
app.TimeoutsEditFieldLabel.Layout.Column = 3;
app.TimeoutsEditFieldLabel.Text = 'Timeout (s) :';

% Create TimeoutsEditField
app.TimeoutsEditField = uieditfield(app.GridLayout2_3, 'numeric');
app.TimeoutsEditField.Layout.Row = 1;
app.TimeoutsEditField.Layout.Column = 4;
app.TimeoutsEditField.Value = 1;

% Create GridLayout2_4
app.GridLayout2_4 = uigridlayout(app.GridLayout);
app.GridLayout2_4.ColumnWidth = {'1x', '1x', '1x', '1x'};
app.GridLayout2_4.RowHeight = {'1x'};
app.GridLayout2_4.Padding = [0 0 0 0];
app.GridLayout2_4.Layout.Row = 4;
app.GridLayout2_4.Layout.Column = 1;

% Create ParityDropDownLabel
app.ParityDropDownLabel = uilabel(app.GridLayout2_4);
app.ParityDropDownLabel.HorizontalAlignment = 'right';
app.ParityDropDownLabel.Layout.Row = 1;
app.ParityDropDownLabel.Layout.Column = 1;
app.ParityDropDownLabel.Text = 'Parity :';

% Create ParityDropDown
app.ParityDropDown = uidropdown(app.GridLayout2_4);
app.ParityDropDown.Items = {'none', 'even', 'odd'};
app.ParityDropDown.Layout.Row = 1;
app.ParityDropDown.Layout.Column = 2;
app.ParityDropDown.Value = 'none';

% Create TerminatorDropDownLabel
app.TerminatorDropDownLabel = uilabel(app.GridLayout2_4);
app.TerminatorDropDownLabel.HorizontalAlignment = 'right';
app.TerminatorDropDownLabel.Layout.Row = 1;
app.TerminatorDropDownLabel.Layout.Column = 3;
app.TerminatorDropDownLabel.Text = 'Terminator :';

% Create TerminatorDropDown
app.TerminatorDropDown = uidropdown(app.GridLayout2_4);
app.TerminatorDropDown.Items = {'LF', 'CR', 'CR/LF'};
app.TerminatorDropDown.Layout.Row = 1;
app.TerminatorDropDown.Layout.Column = 4;
app.TerminatorDropDown.Value = 'LF';

% Create GridLayout5
app.GridLayout5 = uigridlayout(app.GridLayout);
app.GridLayout5.ColumnWidth = {'1x', 100, 100};
app.GridLayout5.RowHeight = {'1x'};
app.GridLayout5.Padding = [0 0 0 0];
app.GridLayout5.Layout.Row = 5;
app.GridLayout5.Layout.Column = 1;

% Create OKButton
app.OKButton = uibutton(app.GridLayout5, 'push');
app.OKButton.Layout.Row = 1;
app.OKButton.Layout.Column = 2;
app.OKButton.Text = 'OK';

% Create CancelButton
app.CancelButton = uibutton(app.GridLayout5, 'push');
app.CancelButton.Layout.Row = 1;
app.CancelButton.Layout.Column = 3;
app.CancelButton.Text = 'Cancel';

% Show the figure after all components are created
[x, y] = CalculateUIPosition;
app.UIFigure.Position(1) = x;
app.UIFigure.Position(2) = y;
app.UIFigure.Visible = 'on';

%% Callbacks
app.OKButton.ButtonPushedFcn = @(src, event) OKButtonPushedFcn(app, event, src);
app.UIFigure.CloseRequestFcn = @(src, event) UIFigureCloseRequestFcn(app, event, src);
app.CancelButton.ButtonPushedFcn = @(src, event) UIFigureCloseRequestFcn(app, event, src);

%% Start up
portList = serialportlist("available");
app.PortDropDown.Items = portList;


%% Functions
    function OKButtonPushedFcn(app, ~, ~)
    
    portObj = [];
    
    delete(instrfind)
    try
        delete(app.portObj);
    end
    
    try
        portName = app.PortDropDown.Value;
        baudRate = app.BaudRateEditField.Value;
        
        stopBits = app.StopBitsbitDropDown.Value;
        flowControl = app.FlowControlDropDown.Value;
        dataBits = app.DataBitsbitDropDown.Value;
        timeout = app.TimeoutsEditField.Value;
        parity = app.ParityDropDown.Value;
        terminator = app.TerminatorDropDown.Value;
        
        portObj = serialport(portName, baudRate);
        portObj.StopBits = str2double(stopBits);
        portObj.FlowControl = flowControl;
        portObj.DataBits = str2double(dataBits);
        portObj.Timeout = timeout;
        portObj.Parity = parity;
        configureTerminator(portObj, terminator);
    catch
        uialert(app.UIFigure, "Connection Failed", "Connection Error")
        return
    end
    
    MainApp.UIFigure.UserData.PortObj = portObj;
    UIFigureCloseRequestFcn(app, [], [])
    
    end
    
    function UIFigureCloseRequestFcn(app, ~, ~)
        delete(app.UIFigure);
    end

    
    function [x, y] = CalculateUIPosition
        parentPosition = MainApp.UIFigure.Position;
        w = app.UIFigure.Position(3);
        h = app.UIFigure.Position(4);
        x = parentPosition(1) + round(parentPosition(3)/2 - w/2);
        y = parentPosition(2) + round(parentPosition(4)/2 - h/2);
    end

end