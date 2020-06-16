function ConfigApply(app)

if app.MainApp.ROICheckBox.Value == 0
    
    app.MainApp.CropImg = app.MainApp.TgtImgOrg;
    
else
    
    app.MainApp.CropImg = uint16(zeros(app.MainApp.ROIRect.Position(4)+1, app.MainApp.ROIRect.Position(3)+1));
    
    for i = 1:3

        app.MainApp.CropImg(:, :, i) = app.MainApp.TgtImgOrg(app.MainApp.ROIRect.Position(2):app.MainApp.ROIRect.Position(2)+...
            app.MainApp.ROIRect.Position(4), app.MainApp.ROIRect.Position(1):app.MainApp.ROIRect.Position(1)...
            +app.MainApp.ROIRect.Position(3), i);

    end
    
end

BrtDiff = app.BrtSlider.Value - app.MainApp.BrightnessInit;
ConDiff = app.ConSlider.Value / app.MainApp.ContrastInit;

ProcImg = app.MainApp.CropImg * ConDiff + BrtDiff*2^8;

if app.MainApp.ROICheckBox.Value == 1


    for i = 1:3

        app.MainApp.TgtImg(app.MainApp.ROIRect.Position(2):app.MainApp.ROIRect.Position(2)+...
                    app.MainApp.ROIRect.Position(4), app.MainApp.ROIRect.Position(1):app.MainApp.ROIRect.Position(1)...
                    +app.MainApp.ROIRect.Position(3), i) = ProcImg(:, :, i); 

    end
    
    app.MainApp.ROIPosition = app.MainApp.ROIRect.Position;
    
else
    
    app.MainApp.TgtImg = ProcImg;

end

imshow(app.MainApp.TgtImg, 'Parent', app.MainApp.UIAxes)

if app.MainApp.ROICheckBox.Value == 1

    MakeROIRectangle(app.MainApp)
    
end

app.MainApp.Brightness = app.BrtSlider.Value;
app.MainApp.Contrast = app.ConSlider.Value;

TextReset(app.MainApp)
SetButtonStatus(app.MainApp, 'ConfigurationApply')
