function SaveImage(app, status)

tmpFig = figure;
tmpFig.Visible = 0;
tmpFig.WindowState = 'maximized';
tmpAxes = axes(tmpFig);

curImg = app.UIAxes.Children;
copyobj(curImg, tmpAxes);

tmpAxes.XLim = app.UIAxes.XLim;
tmpAxes.YLim = app.UIAxes.YLim;
tmpAxes.ZLim = app.UIAxes.ZLim;
tmpAxes.DataAspectRatio = app.UIAxes.DataAspectRatio;

tmpAxes.XLim = app.UIAxes.XLim;
tmpAxes.YLim = app.UIAxes.YLim;

tmpAxes.Colormap = app.UIAxes.Colormap;
tmpAxes.YDir = 'reverse';

tmpAxes.XTick = [];
tmpAxes.YTick = [];
axis(tmpAxes, 'off')

tmpImg = findobj(tmpAxes, 'type', 'Image');

if isempty(tmpImg)
    
    return
    
end

tmpFig.PaperUnits = 'inches';
tmpFig.PaperPosition = [tmpFig.Position(1), tmpFig.Position(2), size(tmpImg.CData, 2)/100, size(tmpImg.CData, 1)/100];

if strcmp(status, 'SaveImage')

    [fileName, pathName] = uiputfile(...
    {'*.png', 'PNG File';...
    '*.jpg', 'JPG File'}, 'File Selection', 'ResultImage.png');

    if fileName == 0

        return

    end
    
    print(tmpFig, fullfile(pathName, fileName), '-dpng', '-r100')
    
else
    
    print(tmpFig, '-clipboard', '-dbitmap')
    
end

close(tmpFig)