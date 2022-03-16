% Create UIFigure and hide until all components are created
app.UIFigure = uifigure('Visible', 'off');
app.UIFigure.Position = [100 100 1083 665];
app.UIFigure.Name = 'MATLAB App';

% Create FileMenu
app.FileMenu = uimenu(app.UIFigure);
app.FileMenu.Text = 'File';

% Create SaveProjectMenu
app.SaveProjectMenu = uimenu(app.FileMenu);
app.SaveProjectMenu.Text = 'Save Project';

% Create LoadProjectMenu
app.LoadProjectMenu = uimenu(app.FileMenu);
app.LoadProjectMenu.Text = 'Load Project';

% Create ExitMenu
app.ExitMenu = uimenu(app.FileMenu);
app.ExitMenu.Separator = 'on';
app.ExitMenu.Text = 'Exit';

% Create DataMenu
app.DataMenu = uimenu(app.UIFigure);
app.DataMenu.Text = 'Data';

% Create AddMenu
app.AddMenu = uimenu(app.DataMenu);
app.AddMenu.Text = 'Add';

% Create iMSPRminiDataMenu
app.iMSPRminiDataMenu = uimenu(app.AddMenu);
app.iMSPRminiDataMenu.Text = 'iMSPR-mini Data';

% Create iMSPRProDataMenu
app.iMSPRProDataMenu = uimenu(app.AddMenu);
app.iMSPRProDataMenu.Text = 'iMSPR-Pro Data';

% Create BiacoreDataMenu
app.BiacoreDataMenu = uimenu(app.AddMenu);
app.BiacoreDataMenu.Text = 'Biacore Data';

% Create ExportMenu
app.ExportMenu = uimenu(app.DataMenu);
app.ExportMenu.Text = 'Export';

% Create DisplayedSensorgramsMenu
app.DisplayedSensorgramsMenu = uimenu(app.ExportMenu);
app.DisplayedSensorgramsMenu.Text = 'Displayed Sensorgram(s)';

% Create AllSensorgramsMenu
app.AllSensorgramsMenu = uimenu(app.ExportMenu);
app.AllSensorgramsMenu.Text = 'All Sensorgrams';

% Create AboutMenu
app.AboutMenu = uimenu(app.UIFigure);
app.AboutMenu.Text = 'About';

% Create HelpMenu
app.HelpMenu = uimenu(app.AboutMenu);
app.HelpMenu.Text = 'Help';

% Create VersionMenu
app.VersionMenu = uimenu(app.AboutMenu);
app.VersionMenu.Text = 'Version';

% Create WebsiteMenu
app.WebsiteMenu = uimenu(app.AboutMenu);
app.WebsiteMenu.Text = 'Website';

% Create MainGridLayout
app.MainGridLayout = uigridlayout(app.UIFigure);
app.MainGridLayout.ColumnWidth = {'1x', 300};
app.MainGridLayout.RowHeight = {'1x'};
app.MainGridLayout.ColumnSpacing = 20;
app.MainGridLayout.RowSpacing = 0;
app.MainGridLayout.Padding = [20 20 20 20];

% Create RightGridLayout
app.RightGridLayout = uigridlayout(app.MainGridLayout);
app.RightGridLayout.ColumnWidth = {'1x'};
app.RightGridLayout.RowHeight = {35, '1x'};
app.RightGridLayout.ColumnSpacing = 0;
app.RightGridLayout.RowSpacing = 0;
app.RightGridLayout.Padding = [0 5 0 5];
app.RightGridLayout.Layout.Row = 1;
app.RightGridLayout.Layout.Column = 2;

% Create TableButtonGridLayout
app.TableButtonGridLayout = uigridlayout(app.RightGridLayout);
app.TableButtonGridLayout.ColumnWidth = {100, '1x', 25, 25, 25, 30};
app.TableButtonGridLayout.RowHeight = {25};
app.TableButtonGridLayout.ColumnSpacing = 5;
app.TableButtonGridLayout.RowSpacing = 0;
app.TableButtonGridLayout.Padding = [0 0 0 0];
app.TableButtonGridLayout.Layout.Row = 1;
app.TableButtonGridLayout.Layout.Column = 1;

% Create CheckBox
app.CheckBox = uicheckbox(app.TableButtonGridLayout);
app.CheckBox.Text = '';
app.CheckBox.Layout.Row = 1;
app.CheckBox.Layout.Column = 6;

% Create DownButton
app.DownButton = uibutton(app.TableButtonGridLayout, 'push');
app.DownButton.Layout.Row = 1;
app.DownButton.Layout.Column = 5;
app.DownButton.Text = '▼';

% Create UpButton
app.UpButton = uibutton(app.TableButtonGridLayout, 'push');
app.UpButton.Layout.Row = 1;
app.UpButton.Layout.Column = 4;
app.UpButton.Text = '▲';

% Create DelButton
app.DelButton = uibutton(app.TableButtonGridLayout, 'push');
app.DelButton.Layout.Row = 1;
app.DelButton.Layout.Column = 3;
app.DelButton.Text = '-';

% Create Renum123Button
app.Renum123Button = uibutton(app.TableButtonGridLayout, 'push');
app.Renum123Button.Layout.Row = 1;
app.Renum123Button.Layout.Column = 1;
app.Renum123Button.Text = 'Renum (1,2,3...)';

% Create UITable
app.UITable = uitable(app.RightGridLayout);
app.UITable.ColumnName = {'Index'; 'Type'; 'Display'};
app.UITable.RowName = {};
app.UITable.Layout.Row = 2;
app.UITable.Layout.Column = 1;

% Create LeftGridLayout
app.LeftGridLayout = uigridlayout(app.MainGridLayout);
app.LeftGridLayout.ColumnWidth = {'1x'};
app.LeftGridLayout.ColumnSpacing = 0;
app.LeftGridLayout.RowSpacing = 0;
app.LeftGridLayout.Padding = [0 0 0 0];
app.LeftGridLayout.Layout.Row = 1;
app.LeftGridLayout.Layout.Column = 1;

% Create TopGridLayout
app.TopGridLayout = uigridlayout(app.LeftGridLayout);
app.TopGridLayout.ColumnWidth = {'1x'};
app.TopGridLayout.RowHeight = {30, '1x'};
app.TopGridLayout.ColumnSpacing = 0;
app.TopGridLayout.RowSpacing = 0;
app.TopGridLayout.Padding = [0 0 0 0];
app.TopGridLayout.Layout.Row = 1;
app.TopGridLayout.Layout.Column = 1;

% Create SensorgramUIAxes
app.SensorgramUIAxes = uiaxes(app.TopGridLayout);
title(app.SensorgramUIAxes, 'Sensorgram')
xlabel(app.SensorgramUIAxes, 'Time (s)')
ylabel(app.SensorgramUIAxes, 'Signal (RU)')
zlabel(app.SensorgramUIAxes, 'Z')
app.SensorgramUIAxes.Layout.Row = 2;
app.SensorgramUIAxes.Layout.Column = 1;

% Create ReferencingGridLayout
app.ReferencingGridLayout = uigridlayout(app.TopGridLayout);
app.ReferencingGridLayout.ColumnWidth = {'1x', 150, 200};
app.ReferencingGridLayout.RowHeight = {'1x'};
app.ReferencingGridLayout.ColumnSpacing = 5;
app.ReferencingGridLayout.RowSpacing = 0;
app.ReferencingGridLayout.Padding = [0 0 0 0];
app.ReferencingGridLayout.Layout.Row = 1;
app.ReferencingGridLayout.Layout.Column = 1;

% Create ReferencingDropDownLabel
app.ReferencingDropDownLabel = uilabel(app.ReferencingGridLayout);
app.ReferencingDropDownLabel.HorizontalAlignment = 'right';
app.ReferencingDropDownLabel.Layout.Row = 1;
app.ReferencingDropDownLabel.Layout.Column = 2;
app.ReferencingDropDownLabel.Text = 'Referencing :';

% Create ReferencingDropDown
app.ReferencingDropDown = uidropdown(app.ReferencingGridLayout);
app.ReferencingDropDown.Items = {'None', 'N-S-N-S', 'S-N-S-N'};
app.ReferencingDropDown.Layout.Row = 1;
app.ReferencingDropDown.Layout.Column = 3;
app.ReferencingDropDown.Value = 'None';

% Create BottomGridLayout
app.BottomGridLayout = uigridlayout(app.LeftGridLayout);
app.BottomGridLayout.ColumnWidth = {220, 40, '1x'};
app.BottomGridLayout.RowHeight = {'1x'};
app.BottomGridLayout.ColumnSpacing = 5;
app.BottomGridLayout.RowSpacing = 0;
app.BottomGridLayout.Padding = [5 5 5 5];
app.BottomGridLayout.Layout.Row = 2;
app.BottomGridLayout.Layout.Column = 1;

% Create RunButton
app.RunButton = uibutton(app.BottomGridLayout, 'push');
app.RunButton.Layout.Row = 1;
app.RunButton.Layout.Column = 2;
app.RunButton.Text = '>>';

% Create PreviewGridLayout
app.PreviewGridLayout = uigridlayout(app.BottomGridLayout);
app.PreviewGridLayout.ColumnWidth = {'1x'};
app.PreviewGridLayout.RowHeight = {'1x', 35};
app.PreviewGridLayout.ColumnSpacing = 0;
app.PreviewGridLayout.RowSpacing = 5;
app.PreviewGridLayout.Padding = [0 0 0 0];
app.PreviewGridLayout.Layout.Row = 1;
app.PreviewGridLayout.Layout.Column = 3;

% Create PreviewUIAxes
app.PreviewUIAxes = uiaxes(app.PreviewGridLayout);
title(app.PreviewUIAxes, 'Preview')
xlabel(app.PreviewUIAxes, 'Index')
ylabel(app.PreviewUIAxes, 'Result (RU)')
zlabel(app.PreviewUIAxes, 'Z')
app.PreviewUIAxes.Layout.Row = 1;
app.PreviewUIAxes.Layout.Column = 1;

% Create DetailedviewButton
app.DetailedviewButton = uibutton(app.PreviewGridLayout, 'push');
app.DetailedviewButton.Layout.Row = 2;
app.DetailedviewButton.Layout.Column = 1;
app.DetailedviewButton.Text = 'Detailed view';

% Create SettingGridLayout
app.SettingGridLayout = uigridlayout(app.BottomGridLayout);
app.SettingGridLayout.ColumnWidth = {'1x', 100};
app.SettingGridLayout.RowHeight = {25, 25, '3x', '2x'};
app.SettingGridLayout.ColumnSpacing = 5;
app.SettingGridLayout.RowSpacing = 5;
app.SettingGridLayout.Padding = [0 0 0 0];
app.SettingGridLayout.Layout.Row = 1;
app.SettingGridLayout.Layout.Column = 1;

% Create StartPointSpinnerLabel
app.StartPointSpinnerLabel = uilabel(app.SettingGridLayout);
app.StartPointSpinnerLabel.HorizontalAlignment = 'right';
app.StartPointSpinnerLabel.Layout.Row = 1;
app.StartPointSpinnerLabel.Layout.Column = 1;
app.StartPointSpinnerLabel.Text = 'Start Point :';

% Create StartPointSpinner
app.StartPointSpinner = uispinner(app.SettingGridLayout);
app.StartPointSpinner.ValueDisplayFormat = '%.0f';
app.StartPointSpinner.Layout.Row = 1;
app.StartPointSpinner.Layout.Column = 2;

% Create EndPointSpinnerLabel
app.EndPointSpinnerLabel = uilabel(app.SettingGridLayout);
app.EndPointSpinnerLabel.HorizontalAlignment = 'right';
app.EndPointSpinnerLabel.Layout.Row = 2;
app.EndPointSpinnerLabel.Layout.Column = 1;
app.EndPointSpinnerLabel.Text = 'End Point :';

% Create EndPointSpinner
app.EndPointSpinner = uispinner(app.SettingGridLayout);
app.EndPointSpinner.ValueDisplayFormat = '%.0f';
app.EndPointSpinner.Layout.Row = 2;
app.EndPointSpinner.Layout.Column = 2;

% Create MethodButtonGroup
app.MethodButtonGroup = uibuttongroup(app.SettingGridLayout);
app.MethodButtonGroup.Title = 'Method';
app.MethodButtonGroup.Layout.Row = 3;
app.MethodButtonGroup.Layout.Column = [1 2];

% Create RUYendYstartButton
app.RUYendYstartButton = uiradiobutton(app.MethodButtonGroup);
app.RUYendYstartButton.Text = 'ΔRU (Yend - Ystart)';
app.RUYendYstartButton.Position = [11 97 127 22];
app.RUYendYstartButton.Value = true;

% Create AveragingYstartYendButton
app.AveragingYstartYendButton = uiradiobutton(app.MethodButtonGroup);
app.AveragingYstartYendButton.Text = 'Averaging (Ystart ~ Yend)';
app.AveragingYstartYendButton.Position = [11 75 159 22];

% Create DriftLinearfitButton
app.DriftLinearfitButton = uiradiobutton(app.MethodButtonGroup);
app.DriftLinearfitButton.Text = 'Drift (Linear fit)';
app.DriftLinearfitButton.Position = [11 53 101 22];

% Create NormalizationButtonGroup
app.NormalizationButtonGroup = uibuttongroup(app.SettingGridLayout);
app.NormalizationButtonGroup.Title = 'Normalization';
app.NormalizationButtonGroup.Layout.Row = 4;
app.NormalizationButtonGroup.Layout.Column = [1 2];

% Create NoneButton
app.NoneButton = uiradiobutton(app.NormalizationButtonGroup);
app.NoneButton.Text = 'None';
app.NoneButton.Position = [11 49 58 22];
app.NoneButton.Value = true;

% Create byPositiveButton
app.byPositiveButton = uiradiobutton(app.NormalizationButtonGroup);
app.byPositiveButton.Text = 'by Positive';
app.byPositiveButton.Position = [11 27 80 22];

% Show the figure after all components are created
app.UIFigure.Visible = 'on';
        