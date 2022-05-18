function ChangeShape(src, event)

% delete(src.Parent.MeasureText)

delete(findobj(src.Parent, 'Type', 'Text'))

if strcmp(event.Source.Tag, 'Circle')
    
    RadiusStr = strcat('R =', {' '}, num2str(src.Radius));
    MeasureText = text(src.Center(1), src.Center(2)+src.Radius+5, RadiusStr, 'Parent', src.Parent,...
        'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
elseif strcmp(event.Source.Tag, 'Line')
    
    LineLength = sqrt((src.Position(2, 1) - src.Position(1, 1)).^2 + (src.Position(2, 2) - src.Position(1, 2)).^2);
    LengthStr = strcat('L =', {' '}, num2str(LineLength));
    MeasureText = text(src.Position(2, 1), src.Position(2, 2)+5, LengthStr, 'Parent', src.Parent,...
        'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

elseif strcmp(event.Source.Tag, 'Rectangle')
    
    WidthStr = strcat('W =', {' '}, num2str(src.Position(1, 3)));
    HeightStr = strcat('H =', {' '}, num2str(src.Position(1, 4)));    
    WidthText = text(src.Position(1, 1) + src.Position(1, 3)/2, src.Position(1, 2) + src.Position(1, 4)...
        + 5 + 22, WidthStr, 'Parent', src.Parent, 'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold',...
        'HorizontalAlignment', 'center');    
    HeightText = text(src.Position(1, 1) + src.Position(1, 3)+5, src.Position(1, 2) + src.Position(1, 4)/2 +...
        5, HeightStr, 'Parent', src.Parent, 'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold',...
        'HorizontalAlignment', 'center');
    
end