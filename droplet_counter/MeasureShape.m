function MeasureShape(app, event)

delete(app.Shape)
delete(findobj(app.UIAxes, 'Type', 'Text'))

if strcmp(event.Source.Tag, 'MeasureCircle')
    
    app.Shape = drawcircle(app.UIAxes);
    app.Shape.Tag = 'Circle';
    app.Shape.Deletable = 0;
    app.ShapeAction = addlistener(app.Shape, 'ROIMoved', @ChangeShape);
    
    RadiusStr = strcat('R =', {' '}, num2str(app.Shape.Radius));
    MeasureText = text(app.Shape.Center(1), app.Shape.Center(2)+app.Shape.Radius+5, RadiusStr, 'Parent', app.Shape.Parent,...
        'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
elseif strcmp(event.Source.Tag, 'MeasureLine')
    
    app.Shape = drawline(app.UIAxes);
    app.Shape.Tag = 'Line';
    app.Shape.Deletable = 0;
    app.ShapeAction = addlistener(app.Shape, 'ROIMoved', @ChangeShape);
    
    LineLength = sqrt((app.Shape.Position(2, 1) - app.Shape.Position(1, 1)).^2 + (app.Shape.Position(2, 2) - app.Shape.Position(1, 2)).^2);
    LengthStr = strcat('L =', {' '}, num2str(LineLength));
    MeasureText = text(app.Shape.Position(2, 1), app.Shape.Position(2, 2)+5, LengthStr, 'Parent', app.Shape.Parent,...
        'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    
else
    
    app.Shape = drawrectangle(app.UIAxes);
    app.Shape.Tag = 'Rectangle';
    app.Shape.Deletable = 0;
    app.ShapeAction = addlistener(app.Shape, 'ROIMoved', @ChangeShape);
    
    WidthStr = strcat('W =', {' '}, num2str(app.Shape.Position(1, 3)));
    HeightStr = strcat('H =', {' '}, num2str(app.Shape.Position(1, 4)));    
    WidthText = text(app.Shape.Position(1, 1) + app.Shape.Position(1, 3)/2, app.Shape.Position(1, 2) + app.Shape.Position(1, 4)...
        + 5 + 22, WidthStr, 'Parent', app.Shape.Parent, 'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold',...
        'HorizontalAlignment', 'center');    
    HeightText = text(app.Shape.Position(1, 1) + app.Shape.Position(1, 3)+5, app.Shape.Position(1, 2) + app.Shape.Position(1, 4)/2 +...
        5, HeightStr, 'Parent', app.Shape.Parent, 'Color', 'Red', 'FontSize', 20, 'FontWeight', 'bold',...
        'HorizontalAlignment', 'center');
    
end

SetButtonStatus(app, 'MeasureOn')