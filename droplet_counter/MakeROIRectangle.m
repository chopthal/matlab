function MakeROIRectangle(app)

ROIVal = app.ROICheckBox.Value;

if ROIVal == 1

    if isempty(app.TgtImg)

        app.ROICheckBox.Value = 0;
        return

    end

    ImgSize = size(app.TgtImg);

    if isempty(app.ROIPosition) || app.ROIPosition(3) > ImgSize(2) || app.ROIPosition(4) > ImgSize(1)

        app.ROIPosition = round([ImgSize(2)*0.1, ImgSize(1)*0.1, ImgSize(2)*0.8, ImgSize(1)*0.8]);

    end

%                 app.ROIRect = drawrectangle(app.UIAxes, 'Label', 'SelectROI', 'Color',...
%                     [0 0 0], 'Deletable', 0, 'DrawingArea', [0, 0, ImgSize(2), ImgSize(1)],...
%                     'Position', app.ROIPosition, 'FaceAlpha', 0);
    app.ROIRect = drawrectangle(app.UIAxes, 'Color',...
        [0 0 0], 'Deletable', 0, 'DrawingArea', [0, 0, ImgSize(2), ImgSize(1)],...
        'Position', app.ROIPosition, 'FaceAlpha', 0);

    app.ROIAction = addlistener(app.ROIRect, 'ROIMoved', @ChangeRectangle);


else

    app.ROIPosition = app.ROIRect.Position;
    delete(app.ROIRect)
    app.ROIRect = [];
    delete(app.ROIAction)

end