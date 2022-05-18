function SetButtonStatus(app, status)

% app.LoadButton
% app.CountButton
% app.SaveResultButton
% app.ShowUnknowns
% app.ROICheckBox
% app.ClearShapesButton
% 
% app.ROISettingMenu
% app.CircleMenu
% app.LineMenu
% app.RectangleMenu
% app.ROISettingMenu
% app.ConfigurationMenu
% 
% app.CountDropletMenu
% 
% app.FileMenu
% app.RunMenu
% app.ImageMenu
% app.HelpMenu

if strcmp(status, 'Initial')
    
    app.CountButton.Enable = 0;
    app.CountButton.Visible = 0;
    app.SaveResultButton.Enable = 0;
    app.SaveResultButton.Visible = 0;
    app.ROICheckBox.Enable = 0;
    app.ROICheckBox.Visible = 0;
    
    app.SaveResultMenu.Enable = 0;
    
    app.CountDropletMenu.Enable = 0;
    app.ROISettingMenu.Enable = 0;
    app.ConfigurationMenu.Enable = 0;
    app.MeasureMenu.Enable = 0;
    
    app.ShowUnknownsButton.Enable = 0;
    app.ShowUnknownsButton.Visible = 0;
    app.ClearShapesButton.Enable = 0;
    app.ClearShapesButton.Visible = 0;
    
    app.ShowUnknownsMenu.Enable = 0;
    
    app.Image.Enable = 0;
    app.Image.Visible = 0;
    
    app.ToClipboardButton.Enable = 0;
    app.ToClipboardButton.Visible = 0;
    app.SaveImageButton.Enable = 0;
    app.SaveImageButton.Visible = 0;
    
    for i = 1:8
        
        strCheck = sprintf('CheckBox_%d', i);
        app.(strCheck).Enable = 1;
        
        strImage = sprintf('Image_%d', i);
        app.(strImage).Enable = 1;
        
    end
    
    app.LoadButton.Enable = 1;
    app.LoadButton.Visible = 1;
        
    
elseif strcmp(status, 'Loaded')
    
    app.CountButton.Enable = 1;
    app.CountButton.Visible = 1;
    app.SaveResultButton.Enable = 0;
    app.SaveResultButton.Visible = 0;
    app.ROICheckBox.Enable = 1;
    app.ROICheckBox.Visible = 1;
    
    app.SaveResultMenu.Enable = 0;
    
    app.CountDropletMenu.Enable = 1;
    app.ROISettingMenu.Enable = 1;
    app.ConfigurationMenu.Enable = 1;
    app.MeasureMenu.Enable = 1;
    
    app.ShowUnknownsButton.Enable = 0;
    app.ShowUnknownsButton.Visible = 0;
    app.ClearShapesButton.Enable = 0;
    app.ClearShapesButton.Visible = 0;
    
    app.ShowUnknownsMenu.Enable = 0;
    
    app.Image.Enable = 1;
    app.Image.Visible = 1;
    
    app.ToClipboardButton.Enable = 1;
    app.ToClipboardButton.Visible = 1;
    app.SaveImageButton.Enable = 1;
    app.SaveImageButton.Visible = 1;
    
    for i = 1:8
        
        strCheck = sprintf('CheckBox_%d', i);
        app.(strCheck).Enable = 1;
        
        strImage = sprintf('Image_%d', i);
        app.(strImage).Enable = 1;
        
    end
    
    app.LoadButton.Enable = 1;
    app.LoadButton.Visible = 1;
    
elseif strcmp(status, 'ConfigurationOn')
    
    app.ConfigurationMenu.Enable = 0;
    
    app.LoadButton.Enable = 0;
    app.LoadButton.Visible = 0;
    
    app.ROICheckBox.Enable = 0;
    app.ROICheckBox.Visible = 0;
    
elseif strcmp(status, 'ConfigurationApply')
    
    app.ShowUnknownsButton.Visible = 0;
    app.ShowUnknownsButton.Enable = 0;
    app.SaveResultButton.Visible = 0;
    app.SaveResultButton.Enable = 0;
    
    app.SaveResultMenu.Enable = 0;
    app.ShowUnknownsMenu.Enable = 0;
    
    app.ClearShapesButton.Enable = 0;
    app.ClearShapesButton.Visible = 0;
    
elseif strcmp(status, 'ConfigurationOff')
    
    app.ConfigurationMenu.Enable = 1;
    
    app.LoadButton.Enable = 1;
    app.LoadButton.Visible = 1;
    
    app.ROICheckBox.Enable = 1;
    app.ROICheckBox.Visible = 1;
    
elseif strcmp(status, 'Counted')
    
    app.SaveResultButton.Enable = 1;
    app.SaveResultButton.Visible = 1;    
    
    app.SaveResultMenu.Enable = 1;
    
    app.ShowUnknownsButton.Enable = 1;
    app.ShowUnknownsButton.Visible = 1;
    
    app.ShowUnknownsMenu.Enable = 1;
    
elseif strcmp(status, 'MeasureOn')
    
    app.ClearShapesButton.Enable = 1;
    app.ClearShapesButton.Visible = 1;
    
elseif strcmp(status, 'MeasureOff')
    
    app.ClearShapesButton.Enable = 0;
    app.ClearShapesButton.Visible = 0;
    
end