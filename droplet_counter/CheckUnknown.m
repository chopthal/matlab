function CheckUnknown(app)

FigUnk = figure(1);
cla(FigUnk)
FigUnk.MenuBar = 'none';
FigUnk.ToolBar = 'figure';
FigUnk.WindowStyle = 'normal';

% imshow(uint8(app.CropImg/2^8))

UnknownIdx = find(app.CntRes.ColorIdx == 0);

VisPitch = 5;
VisRadius = app.CntRes.Radius + VisPitch;

Ang = 0:0.03:2*pi+0.1;
app.UnknownImg = uint8(app.CropImg/2^8);

for i = 1:size(UnknownIdx, 1)
    
    for iii = 1:2

        xp = (VisRadius(UnknownIdx(i), 1)-iii+1) .* cos(Ang);
        yp = (VisRadius(UnknownIdx(i), 1)-iii+1) .* sin(Ang);

    %     figure(1)
    %     hold on
    %     plot(app.CntRes.Centers(UnknownIdx(i), 1) + xp,...
    %         app.CntRes.Centers(UnknownIdx(i), 2) + yp, 'Color', 'red')
    %     hold off

        % TODO : Out of Index, X, Y Diff also in CountDroplet.m
        visCirY = floor(app.CntRes.Centers(UnknownIdx(i), 2)+yp);
        visCirX = floor(app.CntRes.Centers(UnknownIdx(i), 1)+xp);
        
        visCirY(visCirY > size(app.ResultImg, 1)) = NaN;
        visCirY(visCirY <= 0) = NaN;

        visCirX(visCirX > size(app.ResultImg, 2)) = NaN;
        visCirX(visCirX <= 0) = NaN;

        for ii = 1:size(visCirY, 2)
            
            if isnan(visCirY(ii)) || isnan(visCirX(ii))
                
                continue
                
            end
            
            app.UnknownImg(visCirY(ii), visCirX(ii), 1) =...
                2^8-1;
            app.UnknownImg(visCirY(ii), visCirX(ii), 2) =...
                0;
            app.UnknownImg(visCirY(ii), visCirX(ii), 3) =...
                0;

        end
    
    end
    
end

imshow(app.UnknownImg)