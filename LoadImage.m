function LoadImage(app, FullName)

try
                    
    if ~isempty(app.ROIRect)

        app.ROIPosition = app.ROIRect.Position;

    end
    
    app.TgtImg = [];
    app.TgtImg = imread(FullName);
    
    if isa(app.TgtImg, 'double')
        
%         app.TgtImg = uint16(app.TgtImg) * 2^16 ;
        app.TgtImg = im2uint16(app.TgtImg);
        
    elseif isa(app.TgtImg, 'uint8')
        
%         app.TgtImg = uint16(app.TgtImg) * 2^8;
        app.TgtImg = im2uint16(app.TgtImg);
        
    elseif isa(app.TgtImg, 'uint16')
        
        app.TgtImg = app.TgtImg;
        
    end
    
    imshow(app.TgtImg, 'Parent', app.UIAxes)

    app.ROICheckBox.Value = 0;
    delete(app.ROIRect)
    app.ROIRect = [];
    delete(app.ROIAction)
    
    app.ShowUnknownsButton.Visible = 'off';
    app.TgtImgOrg = app.TgtImg;
    TextReset(app)
    
    SetButtonStatus(app, 'Loaded')

catch

    disp('Cannot read the file.')

end