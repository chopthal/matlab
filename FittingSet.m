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
app.UIGridMain.RowHeight = {'1x', 200, 50};
app.UIGridMain.ColumnWidth = {'1x'};

%% Fitting model panel
app.UIPanelFittingModel = uipanel(app.UIGridMain);
app.UIPanelFittingModel.Title = 'Fitting model';
app.UIPanelFittingModel.Layout.Row = 1; app.UIPanelFittingModel.Layout.Column = 1;
% Fitting model panel grid
app.UIGridFittingModel = uigridlayout(app.UIPanelFittingModel);
app.UIGridFittingModel.RowHeight = {25, 20, '1x'};
app.UIGridFittingModel.ColumnWidth = {'1x', '1x'};
% Dropdown
app.UIDropDownModel = uidropdown(app.UIGridFittingModel);
app.UIDropDownModel.Layout.Row = 1; app.UIDropDownModel.Layout.Column = [1, 2];
app.UIDropDownModel.Items = {'1:1 Standard Model (Langmuir Binding)';
    '1:1 Diffusion Model (Mass transport rate)'};
% app.UIDropDownModel.Items = {'1:1 Standard Model (Langmuir Binding)'};
% Label (Equation)
app.UILabelEquation = uilabel(app.UIGridFittingModel);
app.UILabelEquation.Layout.Row = 2; app.UILabelEquation.Layout.Column = 1;
app.UILabelEquation.Text = 'Equation';
app.UILabelEquation.VerticalAlignment = 'bottom';
app.UILabelEquation.HorizontalAlignment = 'center';
% Label (Model)
app.UILabelModel = uilabel(app.UIGridFittingModel);
app.UILabelModel.Layout.Row = 2; app.UILabelModel.Layout.Column = 2;
app.UILabelModel.Text = 'Model';
app.UILabelModel.VerticalAlignment = 'bottom';
app.UILabelModel.HorizontalAlignment = 'center';
% TextArea (description)
% app.UITextAreaDescription = uitextarea(app.UIGridFittingModel);
% app.UITextAreaDescription.Layout.Row = 3; app.UITextAreaDescription.Layout.Column = 1;
% app.UITextAreaDescription.Editable = false;

% Equation Image
app.UIImageEquation = uiimage(app.UIGridFittingModel);
app.UIImageEquation.Layout.Row = 3; app.UIImageEquation.Layout.Column = 1;
app.UIImageEquation.ImageSource = 'oneToOneStandardEquation.png';
% Model Image
app.UIImageModel = uiimage(app.UIGridFittingModel);
app.UIImageModel.Layout.Row = 3; app.UIImageModel.Layout.Column = 2;
app.UIImageModel.ImageSource = 'oneToOneStandardModel.png';

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
app.UIGridFittingParametersSetting.ColumnWidth = {80, '1x'};
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

%% Bottom Buttons
app.UIGridButton = uigridlayout(app.UIGridMain);
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
app.UIFigure.CloseRequestFcn = @(src, event) UIFigureCloseRequestFcn(src, event, app, MainApp);
app.UIButtonOK.ButtonPushedFcn = @(src, event) UIButtonOKButtonPushedFcn(src, event, app, MainApp);
app.UIButtonCancel.ButtonPushedFcn = @(src, event) UIFigureCloseRequestFcn(src, event, app, MainApp);
app.UIButtonDefault.ButtonPushedFcn = @(src, event) UIButtonDefaultButtonPushedFcn(src, event, app, MainApp);

% StartUp Function
currentModel = analyte(analyteNo).FittingVariable.FittingModel;

if strcmp(currentModel, 'OneToOneStandard')
    app.UIDropDownModel.Value = '1:1 Standard Model (Langmuir Binding)';
elseif strcmp(currentModel, 'OneToOneMassTransfer')
    app.UIDropDownModel.Value = '1:1 Diffusion Model (Mass transport rate)';
end

app.UIListBoxParameters.Items =...
    analyte(analyteNo).FittingVariable.(currentModel).Name;
app.UIListBoxParameters.Value = app.UIListBoxParameters.Items{1};
app.UIDropDownSettingType.Value = analyte(analyteNo).FittingVariable.(currentModel).Type{1};

% disp(analyteNo)
UIDropDownModelValueChanged([], [], app)
end

function UIDropDownModelValueChanged(src, event, app)

if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    currentModel = 'OneToOneStandard';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    currentModel = 'OneToOneMassTransfer';
end

app.UIImageEquation.ImageSource = sprintf('%sEquation.png', currentModel);
app.UIImageModel.ImageSource = sprintf('%sModel.png', currentModel);
app.UIListBoxParameters.Items =...
    app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name;

app.UIFigure.UserData.CurrentAnalyte.FittingVariable.FittingModel = currentModel;

UIListBoxParametersValueChanged([], [], app)

end

function UIListBoxParametersValueChanged(src, event, app)

if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    currentModel = 'OneToOneStandard';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    currentModel = 'OneToOneMassTransfer';
end

currentAnalyte = app.UIFigure.UserData.CurrentAnalyte;
currentType = currentAnalyte.FittingVariable.(currentModel).Type{...
    contains(currentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)};
currentInitialValue = currentAnalyte.FittingVariable.(currentModel).InitialValue{...
    contains(currentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value)}(1);

app.UIEditFieldSettingInitialValue.Limits = [-inf, inf];
app.UIEditFieldSettingInitialValue.Value = currentInitialValue;

if strcmp(app.UIListBoxParameters.Value, 'BI')
    app.UIDropDownSettingType.Items = {'Local', 'None'};        
    if strcmp(currentType, 'Constant')
        currentType = 'None';
    end
else
    app.UIDropDownSettingType.Items = {'Global', 'Local', 'Constant'};
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
variableIdx = contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value);
currentLowerBound = app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).LowerBound{variableIdx};
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

if currentLowerBound(1) < 0
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

UIEditFieldSettingInitialValueValueChanged([], [], app)

end


function UIEditFieldSettingInitialValueValueChanged(src, event, app)

UICheckBoxNegativeValueChanged([], [], app)

end

function UICheckBoxNegativeValueChanged(src, event, app)

if strcmp(app.UIDropDownModel.Value, '1:1 Standard Model (Langmuir Binding)')
    currentModel = 'OneToOneStandard';
elseif strcmp(app.UIDropDownModel.Value, '1:1 Diffusion Model (Mass transport rate)')
    currentModel = 'OneToOneMassTransfer';
end
variableIdx = contains(app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Name, app.UIListBoxParameters.Value);

if app.UICheckBoxNegative.Value == 1
    app.UIEditFieldSettingInitialValue.Limits = [-inf inf];
else
    app.UIEditFieldSettingInitialValue.Limits = [0 inf];
end

[newInitialValue, newLowerBound, newUpperBound] = SetFitParameterRange(app.UIFigure.UserData.CurrentAnalyte, currentModel,...
    app.UIListBoxParameters.Value, app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).Type{variableIdx},...
    app.UIEditFieldSettingInitialValue.Value, app.UICheckBoxNegative.Value);
app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).InitialValue{variableIdx} = newInitialValue;
app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).LowerBound{variableIdx} = newLowerBound;
app.UIFigure.UserData.CurrentAnalyte.FittingVariable.(currentModel).UpperBound{variableIdx} = newUpperBound;
    
    function [newInitialValue, newLowerBound, newUpperBound] =...
        SetFitParameterRange(currentAnalyte, currentModel, variable, type, initialValue, allowNegative)
    % Ex : SetFitParameterRange(analyte(analyteNo), 'OneToOneStandard', 'BI', 'Local', 0, 1)
        boundScale = 1e8;
        variableIdx = contains(currentAnalyte.FittingVariable.(currentModel).Name, variable);
        unitValue = ones(size(currentAnalyte.FittingVariable.(currentModel).InitialValue{variableIdx}));
        newInitialValue = unitValue * initialValue;

        if strcmp(type, 'Constant')
            if strcmp(variable, 'BI')
                newInitialValue = 0;
            end
            newLowerBound = newInitialValue;
            newUpperBound = newInitialValue;
        else
            if strcmp(variable, 'BI')
                if allowNegative
                    newLowerBound = -unitValue * inf;
                else
                    newLowerBound = unitValue * 0;            
                end 
                newUpperBound = unitValue * inf;
            else
                newLowerBound = newInitialValue / boundScale;
                newUpperBound = newInitialValue * boundScale; 
            end
        end
    end

end

function UIButtonDefaultButtonPushedFcn(src, event, app, MainApp)

analyteNo = strcmp(MainApp.UIDropdownName.Items, MainApp.UIDropdownName.Value);
analyte = MainApp.UIFigure.UserData.Analyte;
app.UIFigure.UserData.CurrentAnalyte.FittingVariable = analyte(analyteNo).DefaultFittingVariable;

app.UIDropDownModel.Value = app.UIDropDownModel.Items{1};
app.UIListBoxParameters.Value = app.UIListBoxParameters.Items{1};

UIDropDownModelValueChanged([], [], app)
UIListBoxParametersValueChanged([], [], app)

end

function UIButtonOKButtonPushedFcn(src, event, app, MainApp)

currentAnalyte = app.UIFigure.UserData.CurrentAnalyte;
setappdata(MainApp.UIFigure, 'currentAnalyte', currentAnalyte);

delete(app.UIFigure)

end

function UIFigureCloseRequestFcn(src, event, app, MainApp)

currentAnalyte = [];
setappdata(MainApp.UIFigure, 'currentAnalyte', currentAnalyte);

delete(app.UIFigure)

end