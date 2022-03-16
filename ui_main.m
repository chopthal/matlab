close force all

%% Generate App
app = struct;
app.UIFigure = uifigure(1);
app.UIFigure.Visible = 'off';
app.UIFigure.Position = [100 100 406 518];
app.UIFigure.Name = 'iMCom';
app.UIFigure.UserData.PortObj = [];

% Create Menu
app.Menu = uimenu(app.UIFigure);
app.Menu.Text = 'Menu';

% Create ConnectMenu
app.ConnectMenu = uimenu(app.Menu);
app.ConnectMenu.Accelerator = 'n';
app.ConnectMenu.Text = 'Connect';

% Create DisconnectMenu
app.DisconnectMenu = uimenu(app.Menu);
app.DisconnectMenu.Accelerator = 'd';
app.DisconnectMenu.Text = 'Disconnect';

% Create RunMenu
app.RunMenu = uimenu(app.Menu);
app.RunMenu.Separator = 'on';
app.RunMenu.Accelerator = 'r';
app.RunMenu.Text = 'Run';

% Create SaveMenu
app.SaveMenu = uimenu(app.Menu);
app.SaveMenu.Separator = 'on';
app.SaveMenu.Accelerator = 's';
app.SaveMenu.Text = 'Save';

% Create LoadMenu
app.LoadMenu = uimenu(app.Menu);
app.LoadMenu.Accelerator = 'l';
app.LoadMenu.Text = 'Load';

% Create ExitMenu
app.ExitMenu = uimenu(app.Menu);
app.ExitMenu.Separator = 'on';
app.ExitMenu.Accelerator = 'q';
app.ExitMenu.Text = 'Exit';

% Create GridLayout
app.GridLayout = uigridlayout(app.UIFigure);
app.GridLayout.ColumnWidth = {'1x', 150};
app.GridLayout.RowHeight = {'3x', '2x'};

% Create TabGroup
app.TabGroup = uitabgroup(app.GridLayout);
app.TabGroup.Layout.Row = 2;
app.TabGroup.Layout.Column = [1 2];

% Create CMDTab
app.CMDTab = uitab(app.TabGroup);
app.CMDTab.Title = 'CMD';

% Create GridLayout5
app.GridLayout5 = uigridlayout(app.CMDTab);
app.GridLayout5.ColumnWidth = {'1x'};
app.GridLayout5.RowHeight = {'1x', 30};
app.GridLayout5.RowSpacing = 5;
app.GridLayout5.Padding = [0 0 0 5];

% Create TextArea
app.TextArea = uitextarea(app.GridLayout5);
app.TextArea.Editable = 'off';
app.TextArea.Layout.Row = 1;
app.TextArea.Layout.Column = 1;

% Create ClearButton
app.ClearButton = uibutton(app.GridLayout5, 'push');
app.ClearButton.Layout.Row = 2;
app.ClearButton.Layout.Column = 1;
app.ClearButton.Text = 'Clear';

% Create AddTab
app.AddTab = uitab(app.TabGroup);
app.AddTab.Title = 'Add';

% Create GridLayout6
app.GridLayout6 = uigridlayout(app.AddTab);
app.GridLayout6.ColumnWidth = {'1x'};
app.GridLayout6.RowHeight = {'1x', '1x', '1x'};
app.GridLayout6.ColumnSpacing = 5;
app.GridLayout6.RowSpacing = 5;
app.GridLayout6.Padding = [0 0 0 5];

% Create GridLayout7
app.GridLayout7 = uigridlayout(app.GridLayout6);
app.GridLayout7.ColumnWidth = {70, '1x'};
app.GridLayout7.RowHeight = {'1x'};
app.GridLayout7.ColumnSpacing = 5;
app.GridLayout7.RowSpacing = 0;
app.GridLayout7.Padding = [5 5 5 5];
app.GridLayout7.Layout.Row = 1;
app.GridLayout7.Layout.Column = 1;

% Create NameEditFieldLabel
app.AddNameEditFieldLabel = uilabel(app.GridLayout7);
app.AddNameEditFieldLabel.HorizontalAlignment = 'right';
app.AddNameEditFieldLabel.FontSize = 13;
app.AddNameEditFieldLabel.Layout.Row = 1;
app.AddNameEditFieldLabel.Layout.Column = 1;
app.AddNameEditFieldLabel.Text = 'Name :';

% Create NameEditField
app.AddNameEditField = uieditfield(app.GridLayout7, 'text');
app.AddNameEditField.FontSize = 13;
app.AddNameEditField.Layout.Row = 1;
app.AddNameEditField.Layout.Column = 2;

% Create GridLayout8
app.GridLayout8 = uigridlayout(app.GridLayout6);
app.GridLayout8.ColumnWidth = {70, '1x'};
app.GridLayout8.RowHeight = {'1x'};
app.GridLayout8.ColumnSpacing = 5;
app.GridLayout8.Padding = [5 5 5 5];
app.GridLayout8.Layout.Row = 2;
app.GridLayout8.Layout.Column = 1;

% Create ProtocolEditFieldLabel
app.AddProtocolEditFieldLabel = uilabel(app.GridLayout8);
app.AddProtocolEditFieldLabel.HorizontalAlignment = 'right';
app.AddProtocolEditFieldLabel.FontSize = 13;
app.AddProtocolEditFieldLabel.Layout.Row = 1;
app.AddProtocolEditFieldLabel.Layout.Column = 1;
app.AddProtocolEditFieldLabel.Text = 'Protocol :';

% Create ProtocolEditField
app.AddProtocolEditField = uieditfield(app.GridLayout8, 'text');
app.AddProtocolEditField.FontSize = 13;
app.AddProtocolEditField.Layout.Row = 1;
app.AddProtocolEditField.Layout.Column = 2;

% Create GridLayout9
app.GridLayout9 = uigridlayout(app.GridLayout6);
app.GridLayout9.ColumnWidth = {'1x'};
app.GridLayout9.RowHeight = {'1x'};
app.GridLayout9.Padding = [10 5 10 5];
app.GridLayout9.Layout.Row = 3;
app.GridLayout9.Layout.Column = 1;

% Create AddButton
app.AddButton = uibutton(app.GridLayout9, 'push');
app.AddButton.FontSize = 13;
app.AddButton.Layout.Row = 1;
app.AddButton.Layout.Column = 1;
app.AddButton.Text = 'Add';

% Create EditTab
app.EditTab = uitab(app.TabGroup);
app.EditTab.Title = 'Edit';

% Create GridLayout6
app.GridLayoutEditTabMain = uigridlayout(app.EditTab);
app.GridLayoutEditTabMain.ColumnWidth = {'1x'};
app.GridLayoutEditTabMain.RowHeight = {'1x', '1x', '1x'};
app.GridLayoutEditTabMain.ColumnSpacing = 5;
app.GridLayoutEditTabMain.RowSpacing = 5;
app.GridLayoutEditTabMain.Padding = [0 0 0 5];

% Create GridLayout7
app.GridLayoutEditTabName = uigridlayout(app.GridLayoutEditTabMain);
app.GridLayoutEditTabName.ColumnWidth = {70, '1x'};
app.GridLayoutEditTabName.RowHeight = {'1x'};
app.GridLayoutEditTabName.ColumnSpacing = 5;
app.GridLayoutEditTabName.RowSpacing = 0;
app.GridLayoutEditTabName.Padding = [5 5 5 5];
app.GridLayoutEditTabName.Layout.Row = 1;
app.GridLayoutEditTabName.Layout.Column = 1;

% Create NameEditFieldLabel
app.EditNameEditFieldLabel = uilabel(app.GridLayoutEditTabName);
app.EditNameEditFieldLabel.HorizontalAlignment = 'right';
app.EditNameEditFieldLabel.FontSize = 13;
app.EditNameEditFieldLabel.Layout.Row = 1;
app.EditNameEditFieldLabel.Layout.Column = 1;
app.EditNameEditFieldLabel.Text = 'Name :';

% Create NameEditField
app.EditNameEditField = uieditfield(app.GridLayoutEditTabName, 'text');
app.EditNameEditField.FontSize = 13;
app.EditNameEditField.Layout.Row = 1;
app.EditNameEditField.Layout.Column = 2;

% Create GridLayout8
app.GridLayoutEditTabProtocol = uigridlayout(app.GridLayoutEditTabMain);
app.GridLayoutEditTabProtocol.ColumnWidth = {70, '1x'};
app.GridLayoutEditTabProtocol.RowHeight = {'1x'};
app.GridLayoutEditTabProtocol.ColumnSpacing = 5;
app.GridLayoutEditTabProtocol.Padding = [5 5 5 5];
app.GridLayoutEditTabProtocol.Layout.Row = 2;
app.GridLayoutEditTabProtocol.Layout.Column = 1;

% Create ProtocolEditFieldLabel
app.EditProtocolEditFieldLabel = uilabel(app.GridLayoutEditTabProtocol);
app.EditProtocolEditFieldLabel.HorizontalAlignment = 'right';
app.EditProtocolEditFieldLabel.FontSize = 13;
app.EditProtocolEditFieldLabel.Layout.Row = 1;
app.EditProtocolEditFieldLabel.Layout.Column = 1;
app.EditProtocolEditFieldLabel.Text = 'Protocol :';

% Create ProtocolEditField
app.EditProtocolEditField = uieditfield(app.GridLayoutEditTabProtocol, 'text');
app.EditProtocolEditField.FontSize = 13;
app.EditProtocolEditField.Layout.Row = 1;
app.EditProtocolEditField.Layout.Column = 2;

% Create GridLayout9
app.GridLayoutEditTabApplyButton = uigridlayout(app.GridLayoutEditTabMain);
app.GridLayoutEditTabApplyButton.ColumnWidth = {'1x'};
app.GridLayoutEditTabApplyButton.RowHeight = {'1x'};
app.GridLayoutEditTabApplyButton.Padding = [10 5 10 5];
app.GridLayoutEditTabApplyButton.Layout.Row = 3;
app.GridLayoutEditTabApplyButton.Layout.Column = 1;

% Create ApplyButton
app.ApplyButton = uibutton(app.GridLayoutEditTabApplyButton, 'push');
app.ApplyButton.FontSize = 13;
app.ApplyButton.Layout.Row = 1;
app.ApplyButton.Layout.Column = 1;
app.ApplyButton.Text = 'Apply';

% Create GridLayout2
app.GridLayout2 = uigridlayout(app.GridLayout);
app.GridLayout2.ColumnWidth = {'1x'};
app.GridLayout2.RowHeight = {30, '1x'};
app.GridLayout2.ColumnSpacing = 5;
app.GridLayout2.RowSpacing = 0;
app.GridLayout2.Layout.Row = 1;
app.GridLayout2.Layout.Column = 1;

% Create GridLayout3
app.GridLayout3 = uigridlayout(app.GridLayout2);
app.GridLayout3.ColumnWidth = {'1x', 25, 25, 25};
app.GridLayout3.RowHeight = {25};
app.GridLayout3.ColumnSpacing = 2;
app.GridLayout3.RowSpacing = 0;
app.GridLayout3.Padding = [0 0 0 0];
app.GridLayout3.Layout.Row = 1;
app.GridLayout3.Layout.Column = 1;

% Create Button
app.DelButton = uibutton(app.GridLayout3, 'push');
app.DelButton.FontSize = 15;
app.DelButton.FontWeight = 'bold';
app.DelButton.Layout.Row = 1;
app.DelButton.Layout.Column = 2;
app.DelButton.Text = '-';

% Create Button_2
app.UpButton = uibutton(app.GridLayout3, 'push');
app.UpButton.FontSize = 15;
app.UpButton.FontWeight = 'bold';
app.UpButton.Layout.Row = 1;
app.UpButton.Layout.Column = 3;
app.UpButton.Text = '▲';

% Create Button_3
app.DownButton = uibutton(app.GridLayout3, 'push');
app.DownButton.FontSize = 15;
app.DownButton.FontWeight = 'bold';
app.DownButton.Layout.Row = 1;
app.DownButton.Layout.Column = 4;
app.DownButton.Text = '▼';

% Create ListBox
app.ListBox = uilistbox(app.GridLayout2);
app.ListBox.FontSize = 13;
app.ListBox.Layout.Row = 2;
app.ListBox.Layout.Column = 1;

% Create GridLayout4
app.GridLayout4 = uigridlayout(app.GridLayout);
app.GridLayout4.ColumnWidth = {'1x'};
app.GridLayout4.RowHeight = {40, '1x', 40, 40, 60};
app.GridLayout4.Layout.Row = 1;
app.GridLayout4.Layout.Column = 2;

% Create SaveButton
app.SaveButton = uibutton(app.GridLayout4, 'push');
app.SaveButton.Layout.Row = 3;
app.SaveButton.Layout.Column = 1;
app.SaveButton.Text = 'Save';

% Create LoadButton
app.LoadButton = uibutton(app.GridLayout4, 'push');
app.LoadButton.Layout.Row = 4;
app.LoadButton.Layout.Column = 1;
app.LoadButton.Text = 'Load';

% Create RunButton
app.RunButton = uibutton(app.GridLayout4, 'push');
app.RunButton.Layout.Row = 5;
app.RunButton.Layout.Column = 1;
app.RunButton.Text = 'Run';

% Create Panel
app.Panel = uipanel(app.GridLayout4);
app.Panel.BorderType = 'none';
app.Panel.Layout.Row = 1;
app.Panel.Layout.Column = 1;

% Create StatusLabel
app.StatusLabel = uilabel(app.Panel);
app.StatusLabel.HorizontalAlignment = 'right';
app.StatusLabel.Position = [34 10 46 22];
app.StatusLabel.Text = 'Status :';

% Create StatusLamp
app.StatusLamp = uilamp(app.Panel);
app.StatusLamp.Position = [95 10 20 20];

% Show the figure after all components are created
app.UIFigure.Visible = 'on';

%% Variable
app.UIFigure.UserData.Items = struct;
app.UIFigure.UserData.Items.Name = cell(1, 1);
app.UIFigure.UserData.Items.Protocol = cell(1, 1);
app.UIFigure.UserData.PortObj = [];
app.UIFigure.UserData.LampColor.Red = [255 0 0]/255;
app.UIFigure.UserData.LampColor.Orange = [255 255 0]/255;
app.UIFigure.UserData.LampColor.Green = [0 255 0]/255;
app.UIFigure.UserData.SetPath = 'icluebio/iMCom/prev_setting';
app.UIFigure.UserData.SetFile = 'prevset.mat';
app.UIFigure.UserData.PrevSetPath = '';

%% Add Callback function
% UI
app.UIFigure.CloseRequestFcn = @(src, event) UIFigureCloseRequestFcn(app, src, event);
app.AddButton.ButtonPushedFcn = @(src, event) AddButtonPushedFcn(app, src, event);
app.ApplyButton.ButtonPushedFcn = @(src, event) ApplyButtonPushedFcn(app, src, event);
app.ListBox.ValueChangedFcn = @(src, event) ListBoxValueChangedFcn(app, src, event);
app.RunButton.ButtonPushedFcn = @(src, event) RunButtonPushedFcn(app, src, event);
app.ClearButton.ButtonPushedFcn = @(src, event) ClearButtonPushedFcn(app, src, event);
app.SaveButton.ButtonPushedFcn = @(src, event) SaveButtonPushedFcn(app, src, event);
app.LoadButton.ButtonPushedFcn = @(src, event) LoadButtonPushedFcn(app, src, event);
app.DelButton.ButtonPushedFcn = @(src, event) DelButtonPushedFcn(app, src, event); 
app.UpButton.ButtonPushedFcn = @(src, event) UpButtonPushedFcn(app, src, event); 
app.DownButton.ButtonPushedFcn = @(src, event) DownButtonPushedFcn(app, src, event); 

% Menu
app.ConnectMenu.MenuSelectedFcn = @(src, event) ConnectMenuSelectedFcn(app, src, event);
app.DisconnectMenu.MenuSelectedFcn = @(src, event) DisconnectMenuSelectedFcn(app, src, event);
app.RunMenu.MenuSelectedFcn = @(src, event) RunButtonPushedFcn(app, src, event);
app.SaveMenu.MenuSelectedFcn = @(src, event) SaveButtonPushedFcn(app, src, event);
app.LoadMenu.MenuSelectedFcn = @(src, event) LoadButtonPushedFcn(app, src, event);
app.ExitMenu.MenuSelectedFcn = @(src, event) ExitButtonPushedFcn(app, src, event);
%% Start up
app.ListBox.Items = {''};
app.StatusLamp.Color = app.UIFigure.UserData.LampColor.Red;

tmp0 = ctfroot;
tmp1 = split(tmp0, ':');
currentPath = strcat(tmp1{1}, ':');
prevSetFolder = fullfile(currentPath, app.UIFigure.UserData.SetPath);
app.UIFigure.UserData.PrevSetPath = fullfile(currentPath, app.UIFigure.UserData.SetPath, app.UIFigure.UserData.SetFile);
disp(app.UIFigure.UserData.PrevSetPath)
% if isdeployed
    if ~exist(prevSetFolder, 'dir')
        mkdir(prevSetFolder)
    end   
% end
if exist(app.UIFigure.UserData.PrevSetPath, 'file')
    try
        loaded = load(app.UIFigure.UserData.PrevSetPath);
        app.UIFigure.UserData.Items = loaded.items;
        RenewDropDown(app, 1);
    catch
        disp('Loading Error!')
    end
end


%% Function
% Callback
function ConnectMenuSelectedFcn(app, ~, ~)
    connectApp = ui_connect(app);
    uiwait(connectApp.UIFigure);
    if isempty(app.UIFigure.UserData.PortObj)
        app.StatusLamp.Color = app.UIFigure.UserData.LampColor.Red;
        return;
    end
    if ~isvalid(app.UIFigure.UserData.PortObj)
        app.StatusLamp.Color = app.UIFigure.UserData.LampColor.Red;
        return;
    end    
    app.StatusLamp.Color = app.UIFigure.UserData.LampColor.Orange;
    testProtocol = '$D#NAME';
    uidlg = uiprogressdlg(app.UIFigure, "Cancelable", 'off', 'Indeterminate', 'on', 'Title', 'Communication check', 'Message', "Testing communication status...");
    writeline(app.UIFigure.UserData.PortObj, testProtocol);
    response = readline(app.UIFigure.UserData.PortObj);
    if ~isempty(response)
        app.StatusLamp.Color = app.UIFigure.UserData.LampColor.Green;
    end
    newValue = sprintf('%s     [%s]', 'Connected!', datestr(now, 'HH:MM:SS.FFF'));
    prevValue = app.TextArea.Value;
    if ~isempty(prevValue); newValue = [newValue; prevValue]; end
    app.TextArea.Value = newValue;
    close(uidlg);
end


function AddButtonPushedFcn(app, ~, ~)
    name = app.AddNameEditField.Value;
    protocol = app.AddProtocolEditField.Value;

    isExist = find(strcmp(app.ListBox.Items, name));
    if isExist
        uialert(app.UIFigure, "Existing name cannot be used.", "Error")
        return
    end

    if isempty(name)
        uialert(app.UIFigure, "Name is required!", "Not enough information")
        return
    end

    if  isempty(protocol)
        uialert(app.UIFigure, "Protocol is required!", "Not enough information")
        return
    end
    
    addIdx = length(app.UIFigure.UserData.Items.Name) + 1;        
    if ~isempty(app.UIFigure.UserData.Items.Name)
        if isempty(app.UIFigure.UserData.Items.Name{1})
            addIdx = length(app.UIFigure.UserData.Items.Name);
        end
    end
    
    app.UIFigure.UserData.Items.Name{1, addIdx} = name;
    app.UIFigure.UserData.Items.Protocol{1, addIdx} = protocol;
    
    RenewDropDown(app, name);
end


function ApplyButtonPushedFcn(app, ~, ~)
    if isempty(app.ListBox.Items); return; end
    name = app.EditNameEditField.Value;
    protocol = app.EditProtocolEditField.Value;
    editIdx = find(strcmp(app.ListBox.Items, app.ListBox.Value));

    isExist = find(strcmp(app.ListBox.Items, name));    
    if sum(isExist)>1 && isequal(editIdx, isExist)
        uialert(app.UIFigure, "Existing name cannot be used.", "Error")
        return
    end

    if isempty(name)
        uialert(app.UIFigure, "Name is required!", "Not enough information")
        return
    end

    if  isempty(protocol)
        uialert(app.UIFigure, "Protocol is required!", "Not enough information")
        return
    end    
    
    app.UIFigure.UserData.Items.Name{1, editIdx} = name;
    app.UIFigure.UserData.Items.Protocol{1, editIdx} = protocol;
    
    RenewDropDown(app, name);
end


function ListBoxValueChangedFcn(app, ~, ~)
    if isempty(app.ListBox.Items)
        app.EditNameEditField.Value = '';
        app.EditProtocolEditField.Value = '';
        return;
    end
    idx = find(strcmp(app.ListBox.Items, app.ListBox.Value));    
    name = app.UIFigure.UserData.Items.Name{idx};
    protocol = app.UIFigure.UserData.Items.Protocol{idx};    
    app.EditNameEditField.Value = name;
    app.EditProtocolEditField.Value = protocol;
end


function RunButtonPushedFcn(app, ~, ~)
    if isempty(app.ListBox.Items); return; end
    idx = strcmp(app.ListBox.Items, app.ListBox.Value);
    name = app.UIFigure.UserData.Items.Name{idx};
    protocol = app.UIFigure.UserData.Items.Protocol{idx};     

    if isempty(name); return; end
    if  isempty(protocol); return; end

    uidlg = uiprogressdlg(app.UIFigure, "Cancelable", 'off', 'Indeterminate', 'on', 'Title', 'Communication', 'Message', "Communicating with COM Port");
    
    try
        writeline(app.UIFigure.UserData.PortObj, protocol);
        response = readline(app.UIFigure.UserData.PortObj);
    catch    
        close(uidlg)
        uialert(app.UIFigure, "Check the connection!", "Connection Error");
        return
    end
    
    if isempty(response); response = 'No Response'; end    
    close(uidlg);
    newValue = sprintf('%s     [%s]', response, datestr(now, 'HH:MM:SS.FFF'));
    prevValue = app.TextArea.Value;
    if ~isempty(prevValue); newValue = [newValue; prevValue]; end
    app.TextArea.Value = newValue;
end


function ClearButtonPushedFcn(app, ~, ~)
    app.TextArea.Value = '';
end


function SaveButtonPushedFcn(app, ~, ~)
    [file, path] = uiputfile('protocols.mat');    
    if isequal(file, 0) || isequal(path, 0); return; end    
    items = app.UIFigure.UserData.Items;
    save(fullfile(path, file), 'items');
end


function LoadButtonPushedFcn(app, ~, ~)
    [file, path] = uigetfile('*.mat');    
    if isequal(file, 0) || isequal(path, 0); return; end    
    loadData = load(fullfile(path, file));    
    if ~isfield(loadData, 'items'); return; end    
    if ~isfield(loadData.items, 'Name') || ~isfield(loadData.items, 'Protocol'); return; end    
    if isempty(loadData.items.Name) || isempty(loadData.items.Protocol); return; end    
    app.UIFigure.UserData.Items = loadData.items;
    RenewDropDown(app, 1);
end


function DelButtonPushedFcn(app, ~, ~)
    if isempty(app.ListBox.Items); return; end
    idx = find(strcmp(app.ListBox.Items, app.ListBox.Value));
    currentValue = [];
    app.UIFigure.UserData.Items.Name(idx) = [];
    app.UIFigure.UserData.Items.Protocol(idx) = [];
    
    if idx > length(app.UIFigure.UserData.Items.Name)
        idx = length(app.UIFigure.UserData.Items.Name);
    end
    
    if idx ~= 0; currentValue = app.UIFigure.UserData.Items.Name{idx}; end
    RenewDropDown(app, currentValue);
end


function UpButtonPushedFcn(app, ~, ~)
    if isempty(app.ListBox.Items); return; end
    idx = find(strcmp(app.ListBox.Items, app.ListBox.Value));
    if idx <= 1; return; end
    fieldNames = fieldnames(app.UIFigure.UserData.Items);
    
    for i=1:length(fieldNames)
        fieldName = fieldNames{i};
        upper = app.UIFigure.UserData.Items.(fieldName)(1:idx-2);
        lower = app.UIFigure.UserData.Items.(fieldName)(idx+1:end);
        med1 = app.UIFigure.UserData.Items.(fieldName)(idx-1);
        med2 = app.UIFigure.UserData.Items.(fieldName)(idx);
        newItems = [upper, med2, med1, lower];
        app.UIFigure.UserData.Items.(fieldName) = newItems;
    end
    RenewDropDown(app, idx-1);
end


function DownButtonPushedFcn(app, ~, ~)
    if isempty(app.ListBox.Items); return; end
    idx = find(strcmp(app.ListBox.Items, app.ListBox.Value));
    if idx >= length(app.ListBox.Items); return; end
    fieldNames = fieldnames(app.UIFigure.UserData.Items);
    
    for i=1:length(fieldNames)
        fieldName = fieldNames{i};
        upper = app.UIFigure.UserData.Items.(fieldName)(1:idx-1);
        lower = app.UIFigure.UserData.Items.(fieldName)(idx+2:end);
        med1 = app.UIFigure.UserData.Items.(fieldName)(idx+1);
        med2 = app.UIFigure.UserData.Items.(fieldName)(idx);
        newItems = [upper, med1, med2, lower];
        app.UIFigure.UserData.Items.(fieldName) = newItems;
    end
    RenewDropDown(app, idx-1);
end


function DisconnectMenuSelectedFcn(app, ~, ~)
    if isempty(app.UIFigure.UserData.PortObj); return; end
    delete(app.UIFigure.UserData.PortObj);
end


function UIFigureCloseRequestFcn(app, ~, ~)    
    try    
        items = app.UIFigure.UserData.Items;
        save(app.UIFigure.UserData.PrevSetPath, 'items');
    catch
        disp('Saving Error!');
    end
    delete(instrfind);
    delete(app.UIFigure);
    close force all;
end


function ExitButtonPushedFcn(app, ~, ~)
    UIFigureCloseRequestFcn(app, [], []);
end


% Business logic

function RenewDropDown(app, currentValue)
    app.ListBox.Items = app.UIFigure.UserData.Items.Name;
    try
        app.ListBox.Value = currentValue;
    catch       
    end
    ListBoxValueChangedFcn(app, [], []);
end