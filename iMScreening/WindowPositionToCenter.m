function WindowPositionToCenter(fig, parentFig)
    scrPos = get(0, 'ScreenSize');
    try
        parentPos = parentFig.Position;
    catch
        parentPos = scrPos;
    end
    defFigPos = fig.Position;    

    x0 = round(parentPos(1) + (parentPos(3) - defFigPos(3))/2);
    y0 = round(parentPos(2) + (parentPos(4) - defFigPos(4))/2);
    x1 = x0 + defFigPos(3);
    y1 = y0 + defFigPos(4);
    
    if x0 > 0 && x1 <= scrPos(3) && y0 > 0 && y1 <= scrPos(4)
        fig.Position(1) = round(parentPos(1) + (parentPos(3) - defFigPos(3))/2);
        fig.Position(2) = round(parentPos(2) + (parentPos(4) - defFigPos(4))/2);
    else
        WindowPositionToCenter(fig, []);
    end
end