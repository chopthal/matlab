function app = test_FittingSet(MainApp)

%% Get Analyte variable from MainApp
analyteNo = strcmp(MainApp.UIDropdownName.Items, MainApp.UIDropdownName.Value);
analyte = MainApp.UIFigure.UserData.Analyte;

%% Main Figure
app = struct;
app.UIFigure = uifigure;
app.UIFigure.Name = 'Fitting Set';
app.UIFigure.Visible = 'On';
app.UIFigure.WindowStyle = 'modal';
app.UIFigure.Position = [100, 100, 400, 500];
app.UIFigure.UserData.CurrentAnalyte = analyte(analyteNo);

% Main Grid
app.UIGridMain = uigridlayout(app.UIFigure);
app.UIGridMain.RowHeight = {'2x', '2x', 50};
% app.UIGridMain.ColumnWidth = {'1x', '1x'};
app.UIGridMain.ColumnWidth = {'1x'};

%% Fitting model panel
app.UIPanelFittingModel = uipanel(app.UIGridMain);
app.UIPanelFittingModel.Title = 'Fitting model';
app.UIPanelFittingModel.Layout.Row = 1; app.UIPanelFittingModel.Layout.Column = 1;
% Fitting model panel grid
app.UIGridFittingModel = uigridlayout(app.UIPanelFittingModel);
app.UIGridFittingModel.RowHeight = {'1x', '1x', '3x'};
app.UIGridFittingModel.ColumnWidth = {'1x'};
% Dropdown
app.UIDropDownModel = uidropdown(app.UIGridFittingModel);
app.UIDropDownModel.Layout.Row = 1; app.UIDropDownModel.Layout.Column = 1;
app.UIDropDownModel.Items = {'1:1 Standard Model (Langmuir Binding)';
    '1:1 Diffusion Model (Mass transport rate)'};
% Label (description)
app.UILabelDescription = uilabel(app.UIGridFittingModel);
app.UILabelDescription.Layout.Row = 2; app.UILabelDescription.Layout.Column = 1;
app.UILabelDescription.Text = 'Description';
app.UILabelDescription.VerticalAlignment = 'bottom';
% TextArea (description)
app.UITextAreaDescription = uitextarea(app.UIGridFittingModel);
app.UITextAreaDescription.Layout.Row = 3; app.UITextAreaDescription.Layout.Column = 1;
app.UITextAreaDescription.Editable = false;

%% Fitting parameters panel
app.UIPanelFittingParameters = uipanel(app.UIGridMain);
% app.UIPanelFittingParameters.Layout.Row = 1; app.UIPanelFittingParameters.Layout.Column = 2;
app.UIPanelFittingParameters.Layout.Row = 2; app.UIPanelFittingParameters.Layout.Column = 1;
app.UIPanelFittingParameters.Title = 'Fitting parameters';
% Fitting parameters grid
app.UIGridFIttingParameters = uigridlayout(app.UIPanelFittingParameters);
app.UIGridFIttingParameters.RowHeight = {'1x'};
app.UIGridFIttingParameters.ColumnWidth = {'2x', '3x'};
% ListBox
app.UIListBoxParameters = uilistbox(app.UIGridFIttingParameters);
app.UIListBoxParameters.Layout.Row = 1; app.UIListBoxParameters.Layout.Column = 1;
app.UIListBoxParameters.Items = {'kon'; 'koff'; 'Rmax'; 'BI'};
% Setting Panel
app.UIPanelFittingParametersSetting = uipanel(app.UIGridFIttingParameters);
app.UIPanelFittingParametersSetting.Layout.Row = 1; app.UIPanelFittingParametersSetting.Layout.Column = 2;
app.UIPanelFittingParametersSetting.Title = 'Setting';
% Setting grid
app.UIGridFittingParametersSetting = uigridlayout(app.UIPanelFittingParametersSetting);
app.UIGridFittingParametersSetting.RowHeight = {'1x', '1x', '1x', '1x'};
app.UIGridFittingParametersSetting.ColumnWidth = {'1x', '1x'};
% Type Label
app.UILabelSettingType = uilabel(app.UIGridFittingParametersSetting);
app.UILabelSettingType.Text = 'Type :';
app.UILabelSettingType.Layout.Row = 1; app.UILabelSettingType.Layout.Column = 1; 
% Type DropDown
app.UIDropDownSettingType = uidropdown(app.UIGridFittingParametersSetting);
app.UIDropDownSettingType.Items = {'Global', 'Local', 'Constant'};
app.UIDropDownSettingType.Layout.Row = 1; app.UIDropDownSettingType.Layout.Column = 2; 
% InitialValue Label
app.UILabelSettingInitialValue = uilabel(app.UIGridFittingParametersSetting);
app.UILabelSettingInitialValue.Text = 'Initial value :';
app.UILabelSettingInitialValue.Layout.Row = 2; app.UILabelSettingType.Layout.Column = 1; 
% InitialValue EditField
app.UIEditFieldSettingInitialValue = uieditfield(app.UIGridFittingParametersSetting, 'numeric');
app.UIEditFieldSettingInitialValue.Layout.Row = 2; app.UIDropDownSettingType.Layout.Column = 2; 
app.UIEditFieldSettingInitialValue.Value = 0;
% Negative CheckBox
app.UICheckBoxNegative = uicheckbox(app.UIGridFittingParametersSetting);
app.UICheckBoxNegative.Text = 'Allow negative value';
app.UICheckBoxNegative.Layout.Row = 3; app.UICheckBoxNegative.Layout.Column = [1 2];

%% Tab Group
% app.UITabGroupVariable = uitabgroup(app.UIGridMain);
% app.UITabGroupVariable.Layout.Row = 2; app.UITabGroupVariable.Layout.Column = [1 2];
% % Global Tab
% app.UITabVariableGlobal = uitab(app.UITabGroupVariable);
% app.UITabVariableGlobal.Title = 'Global';
% app.UIGridVariableGlobal = uigridlayout(app.UITabVariableGlobal);
% app.UIGridVariableGlobal.RowHeight = {'1x'};
% app.UIGridVariableGlobal.ColumnWidth = {'1x'};
% app.UITableGlobal = uitable(app.UIGridVariableGlobal);
% app.UITableGlobal.Layout.Row = 1; app.UITableGlobal.Layout.Column = 1;
% % Local Tab
% app.UITabVariableLocal = uitab(app.UITabGroupVariable);
% app.UITabVariableLocal.Title = 'Local';
% app.UIGridVariableLocal = uigridlayout(app.UITabVariableLocal);
% app.UIGridVariableLocal.RowHeight = {'1x'};
% app.UIGridVariableLocal.ColumnWidth = {'1x'};
% app.UITableLocal = uitable(app.UIGridVariableLocal);
% app.UITableLocal.Layout.Row = 1; app.UITableLocal.Layout.Column = 1;
% % Constant Tab
% app.UITabVariableConstant = uitab(app.UITabGroupVariable);
% app.UITabVariableConstant.Title = 'Constant';
% app.UIGridVariableConstant = uigridlayout(app.UITabVariableConstant);
% app.UIGridVariableConstant.RowHeight = {'1x'};
% app.UIGridVariableConstant.ColumnWidth = {'1x'};
% app.UITableConstant = uitable(app.UIGridVariableConstant);
% app.UITableConstant.Layout.Row = 1; app.UITableConstant.Layout.Column = 1;

%% Bottom Buttons
app.UIGridButton = uigridlayout(app.UIGridMain);
% app.UIGridButton.Layout.Row = 3; app.UIGridButton.Layout.Column = [1 2];
app.UIGridButton.Layout.Row = 3; app.UIGridButton.Layout.Column = 1;
app.UIGridButton.RowHeight = {30};
app.UIGridButton.ColumnWidth = {'1x', 80, 80, 80};
app.UIGridButton.ColumnSpacing = 5;
app.UIGridButton.Padding = [10 0 0 10];
% Default Button
app.UIButtonDefault = uibutton(app.UIGridButton);
app.UIButtonDefault.Layout.Row = 1; app.UIButtonDefault.Layout.Column = 2;
app.UIButtonDefault.Text = 'Default';
% OK Button
app.UIButtonOK = uibutton(app.UIGridButton);
app.UIButtonOK.Layout.Row = 1; app.UIButtonOK.Layout.Column = 3;
app.UIButtonOK.Text = 'OK';
% Cancel Button
app.UIButtonCancel = uibutton(app.UIGridButton);
app.UIButtonCancel.Layout.Row = 1; app.UIButtonCancel.Layout.Column = 4;
app.UIButtonCancel.Text = 'Cancel';

%% Callback Functions
app.UIDropDownModel.ValueChangedFcn = @(src, event) UIDropDownModelValueChanged(src, event, app);
app.UIListBoxParameters.ValueChangedFcn = @(src, event) UIListBoxParametersValueChanged(src, event, app);
app.UIDropDownSettingType.ValueChangedFcn = @(src, event) UIDropDownSettingTypeValueChanged(src, event, app);
app.UIEditFieldSettingInitialValue.ValueChangedFcn = @(src, event) UIEditFieldSettingInitialValueValueChanged(src, event, app);
app.UICheckBoxNegative.ValueChangedFcn = @(src, event) UICheckBoxNegativeValueChanged(src, event, app);
app.UIFigure.CloseRequestFcn = @(src, event) UIFigureCloseRequestFcn(src, event, app);
app.UIButtonOK.ButtonPushedFcn = @(src, event) UIButtonOKButtonPushedFcn(src, event, app, MainApp);
app.UIButtonCancel.ButtonPushedFcn = @(src, event) UIFigureCloseRequestFcn(src, event, app);

% StartUp Function
app.UIDropDownModel.Value = app.UIDropDownModel.Items{1};
app.UIListBoxParameters.Items =...
    analyte(analyteNo).FittingVariable.(analyte(analyteNo).FittingVariable.FittingModel).Name;
app.UIListBoxParameters.Value = app.UIListBoxParameters.Items{1};
app.UIDropDownSettingType.Value = analyte(analyteNo).FittingVariable.OneToOneStandard.Type{1};


disp(analyteNo)
UIDropDownModelValueChanged([], [], app)
UIListBoxParametersValueChanged([], [], app)
end

function UIDropDownModelValueChanged(src, event, app)

if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    app.UITextAreaDescription.Value = '1:1 Standard Model (Langmuir Binding)';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    app.UITextAreaDescription.Value = '1:1 Diffusion Model (Mass transport rate)';
end

UIListBoxParametersValueChanged([], [], app)

end

function UIListBoxParametersValueChanged(src, event, app)

if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    currentModel = 'OneToOneStandard';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    currentModel = 'OneToOneMassTransfer';
end

currentAnalyte = app.UIFigure.UserData.CurrentAnalyte;

% currentModel = currentAnalyte.FittingVariable.FittingModel;
currentType = currentAnalyte.FittingVariable.(currentModel).Type{...
    contains(currentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)};
currentInitialValue = currentAnalyte.FittingVariable.(currentModel).InitialValue{...
    contains(currentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)}(1);
% currentType = 'Constant';

app.UIEditFieldSettingInitialValue.Value = currentInitialValue;

if strcmp(app.UIListBoxParameters.Value, 'BI')
    app.UIDropDownSettingType.Items = {'Local', 'None'};        
    if strcmp(currentType, 'Constant')
        currentType = 'None';
    end
%     app.UICheckBoxNegative.Enable = 1;
else
    app.UIDropDownSettingType.Items = {'Global', 'Local', 'Constant'};
%     app.UICheckBoxNegative.Enable = 0;
end

app.UIDropDownSettingType.Value = currentType;

UIDropDownSettingTypeValueChanged([], [], app)
    
end

function UIDropDownSettingTypeValueChanged(src, event, app)

if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    currentModel = 'OneToOneStandard';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    currentModel = 'OneToOneMassTransfer';
end

currentType = app.UIDropDownSettingType.Value;
currentLowerBound = app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).LowerBound{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)}(1);
if strcmp(currentType, 'None')
    currentType = 'Constant';
    app.UIEditFieldSettingInitialValue.Enable = 0;
else
    app.UIEditFieldSettingInitialValue.Enable = 1;
end

if strcmp(app.UIListBoxParameters.Value, 'BI') && ~strcmp(app.UIDropDownSettingType.Value, 'None')
    app.UICheckBoxNegative.Enable = 1;
else    
    app.UICheckBoxNegative.Enable = 0;
end

if currentLowerBound < 0
    app.UICheckBoxNegative.Value = 1;
    app.UIEditFieldSettingInitialValue.Limits = [-inf inf];
else
    app.UICheckBoxNegative.Value = 0;
    app.UIEditFieldSettingInitialValue.Limits = [0 inf];
end

app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Type{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name,...
    app.UIListBoxParameters.Value)} = ...
    currentType;

disp(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Type)

end

function UIEditFieldSettingInitialValueValueChanged(src, event, app)

if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    currentModel = 'OneToOneStandard';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    currentModel = 'OneToOneMassTransfer';
end

currentValue = app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).InitialValue{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name,...
    app.UIListBoxParameters.Value)};
newValue = ones(size(currentValue)) * app.UIEditFieldSettingInitialValue.Value;

app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).InitialValue{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name,...
    app.UIListBoxParameters.Value)} = newValue;

disp(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).InitialValue{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name,...
    app.UIListBoxParameters.Value)})

end

function UICheckBoxNegativeValueChanged(src, event, app)

% Use BI Only
if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    currentModel = 'OneToOneStandard';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    currentModel = 'OneToOneMassTransfer';
end

currentLowerBound = app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).LowerBound{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)};
if app.UICheckBoxNegative.Value == 1
    newLowerBound = -inf(size(currentLowerBound));
    app.UIEditFieldSettingInitialValue.Limits = [-inf inf];
else
    newLowerBound = zeros(size(currentLowerBound));
    app.UIEditFieldSettingInitialValue.Limits = [0 inf];
end
app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).LowerBound{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)} = ...
    newLowerBound;

disp(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).LowerBound{...
    contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)})

end

function UIButtonOKButtonPushedFcn(src, event, app, MainApp)

currentAnalyte = app.UIFigure.UserData.CurrentAnalyte;
setappdata(MainApp.UIFigure, 'currentAnalyte', currentAnalyte);

UIFigureCloseRequestFcn([], [], app)

end

function UIFigureCloseRequestFcn(src, event, app)

delete(app.UIFigure)

end