function CountDroplet(app)

progFig = app.DropletCounterUIFigure;
progWindow = uiprogressdlg(progFig, 'Title', 'Please Wait', ...
    'Message', 'Counting the Droplets...', 'Cancelable', 'on');
pause(0.5)

progWindow.Message = 'Getting the Image data...';

if progWindow.CancelRequested == 1
    
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;
    
end

if app.ROICheckBox.Value == 0

    app.CropImg = app.TgtImg;

else

    app.CropImg = uint16(zeros(app.ROIRect.Position(4)+1, app.ROIRect.Position(3)+1));

    for i = 1:3

        app.CropImg(:, :, i) = app.TgtImg(app.ROIRect.Position(2):app.ROIRect.Position(2)+...
            app.ROIRect.Position(4), app.ROIRect.Position(1):app.ROIRect.Position(1)...
            +app.ROIRect.Position(3), i);

    end

end

VisPitch = 5; % Visible Circle Pitch (pixel)
NoColors = 8;

for i = 1:NoColors

    app.img.Color16bit{i} = uint16(app.img.Color{i}) * 2^8;

end

try

    GrayImg = rgb2gray(uint8(app.CropImg / 2^8));

catch

    disp('RGB to Gray process is failed!')
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;

end

DiaMin = app.MinEditField.Value;
DiaMax = app.MaxEditField.Value;
Sensitivity = app.SenEditField.Value;

progWindow.Value = 0.1;
progWindow.Message = 'Counting Dropets from the image data...';

if progWindow.CancelRequested == 1
    
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;
    
end

[app.CntRes.Centers, app.CntRes.Radius, ~] = imfindcircles(GrayImg, [DiaMin DiaMax],...
    'ObjectPolarity', 'dark', 'Sensitivity', Sensitivity);
% [Centers, Radius, ~] = imfindcircles(GrayImg, [DiaMin DiaMax],...
%     'ObjectPolarity', 'bright', 'Sensitivity', Sensitivity);

if isempty(app.CntRes.Radius)

    disp('No Droplets!')
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;

end

progWindow.Value = 0.3;
progWindow.Message = 'Analyzing the Counted Droplets...';

if progWindow.CancelRequested == 1
    
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;
    
end

VisRadius = app.CntRes.Radius + VisPitch;

delete(findobj(app.UIAxes, 'Type', 'Line'))

[XGrid, YGrid] = meshgrid(1:size(app.CropImg, 2), 1:size(app.CropImg, 1));

RedValue = zeros(size(app.CntRes.Radius, 1), 1);
GreenValue = zeros(size(app.CntRes.Radius, 1), 1);
BlueValue = zeros(size(app.CntRes.Radius, 1), 1);

for i=1:size(app.CntRes.Radius, 1)

    MaskCircle = (XGrid-app.CntRes.Centers(i,1)).^2 + (YGrid-app.CntRes.Centers(i,2)).^2 <= app.CntRes.Radius(i).^2;

    RedRaw = app.CropImg(:,:,1);
    GreenRaw = app.CropImg(:,:,2);
    BlueRaw = app.CropImg(:,:,3);
    RedValue(i, 1) = mean(RedRaw(MaskCircle));
    GreenValue(i, 1) = mean(GreenRaw(MaskCircle));
    BlueValue(i, 1) = mean(BlueRaw(MaskCircle));   

    progWindow.Value = progWindow.Value + 0.5/size(app.CntRes.Radius, 1);
    
    if progWindow.CancelRequested == 1
    
        SetButtonStatus(app, 'Loaded')
        close(progWindow)
        return;

    end

end  

RGBValue = [RedValue GreenValue BlueValue];

CheckValue = zeros(NoColors, 1);

for i = 1:NoColors

    CheckStr = sprintf('CheckBox_%d', i);
    CheckValue(i, 1) = app.(CheckStr).Value;

end

app.CntRes.CountColor = zeros(NoColors, 1);
TextReset(app)
app.CntRes.ColorIdx = zeros(size(RGBValue, 1), 1);

progWindow.Value = 0.8;
progWindow.Message = 'Counting colors of Droplets...';

if progWindow.CancelRequested == 1
    
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;
    
end

for i=1:size(RGBValue, 1)

    for ii = 1:NoColors % Distinguish colors in only selected Colors (checkbox).

        if CheckValue(ii, 1) == 0

            continue

        else

            if (RGBValue(i, 1) >= app.img.Color16bit{ii}(1, 1) - app.img.Color16bit{ii}(1, 2))...
                    && (RGBValue(i, 1) <= app.img.Color16bit{ii}(1, 1) + app.img.Color16bit{ii}(1, 2)) % Check Red value

                if (RGBValue(i, 2) >= app.img.Color16bit{ii}(2, 1) - app.img.Color16bit{ii}(2, 2))...
                        && (RGBValue(i, 2) <= app.img.Color16bit{ii}(2, 1) + app.img.Color16bit{ii}(2, 2)) % Check Green value

                    if (RGBValue(i, 3) >= app.img.Color16bit{ii}(3, 1) - app.img.Color16bit{ii}(3, 2))...
                        && (RGBValue(i, 3) <= app.img.Color16bit{ii}(3, 1) + app.img.Color16bit{ii}(3, 2)) % Check Blue value

                       app.CntRes.CountColor(ii, 1) = app.CntRes.CountColor(ii, 1) + 1; % Color ii count +1
                       app.CntRes.ColorIdx(i, 1) = ii;

                    end

                end

            end

        end

    end

end

progWindow.Value = 0.9;

if progWindow.CancelRequested == 1
    
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;
    
end

if app.ROICheckBox.Value == 1

    VisCenters(:, 1) = app.CntRes.Centers(:, 1) + app.ROIRect.Position(1);
    VisCenters(:, 2) = app.CntRes.Centers(:, 2) + app.ROIRect.Position(2);

else

    VisCenters(:, 1) = app.CntRes.Centers(:, 1);
    VisCenters(:, 2) = app.CntRes.Centers(:, 2);

end

Ang = 0:0.1:2*pi+0.1;

for i = 1:size(app.CntRes.ColorIdx, 1)

    xp = VisRadius(i, 1) .* cos(Ang);
    yp = VisRadius(i, 1) .* sin(Ang);

    if app.CntRes.ColorIdx(i, 1) ~= 0

        hold(app.UIAxes, 'on')
        plot(app.UIAxes, VisCenters(i, 1) + xp, VisCenters(i, 2) + yp, 'Color', app.img.Color{app.CntRes.ColorIdx(i, 1)}(:, 1)')
        hold(app.UIAxes, 'off')

    end

end

for i = 1:NoColors

    LabelName = sprintf('Label_%d', i);
    app.(LabelName).Text = num2str(app.CntRes.CountColor(i, 1));

end

if progWindow.CancelRequested == 1
    
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;
    
end

CountColored = sum(app.CntRes.CountColor);
app.CntRes.CountUnknown = size(RGBValue, 1) - sum(app.CntRes.CountColor);
app.CntRes.CountTotal = CountColored + app.CntRes.CountUnknown;

app.Label_9.Text = num2str(app.CntRes.CountUnknown);
app.Label_10.Text = num2str(app.CntRes.CountTotal);
    
% app.ShowUnknownsButton.Visible = 'on';

if progWindow.CancelRequested == 1
    
    SetButtonStatus(app, 'Loaded')
    close(progWindow)
    return;
    
end

SetButtonStatus(app, 'Counted')
% close(progWindow)