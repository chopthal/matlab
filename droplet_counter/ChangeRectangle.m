function ChangeRectangle(src, event)

src.Position = round(event.CurrentPosition);

if event.CurrentPosition(1) == 0
    
    src.Position(1) = 1;
    
end

if event.CurrentPosition(2) == 0
    
    src.Position(2) = 1;
    
end

src.Selected = 0;

% disp(src.Position)




