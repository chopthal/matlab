function CheckUnknown(app)

FigUnk = figure(1);
cla(FigUnk)
FigUnk.MenuBar = 'none';
FigUnk.ToolBar = 'figure';
FigUnk.WindowStyle = 'normal';

imshow(uint8(app.CropImg/2^8))

UnknownIdx = find(app.CntRes.ColorIdx == 0);

VisPitch = 5;
VisRadius = app.CntRes.Radius + VisPitch;

Ang = 0:0.1:2*pi+0.1;

for i = 1:size(UnknownIdx, 1)
    
    xp = VisRadius(UnknownIdx(i), 1) .* cos(Ang);
    yp = VisRadius(UnknownIdx(i), 1) .* sin(Ang);

    figure(1)
    hold on
    plot(app.CntRes.Centers(UnknownIdx(i), 1) + xp,...
        app.CntRes.Centers(UnknownIdx(i), 2) + yp, 'Color', 'red')
    hold off
    
end