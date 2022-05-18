function ConfigValueSet(app, event)

if strcmp(event.Source.Tag(4:6), 'Sld')
    
    EventObj = sprintf('%sSlider', event.Source.Tag(1:3));
    TgtObj = sprintf('%sEditField', event.Source.Tag(1:3));
    
    app.(EventObj).Value = round(event.Value);
    app.(TgtObj).Value = num2str(round(event.Value));
    
else
    
    EventObj = sprintf('%sEditField', event.Source.Tag(1:3));    
    TgtObj = sprintf('%sSlider', event.Source.Tag(1:3));
    TgtVal = floor(str2double(event.Value));
        
    if TgtVal > app.(TgtObj).Limits(2)
        
        TgtVal = app.(TgtObj).Limits(2);
        
        app.(EventObj).Value = num2str(TgtVal);
        app.(TgtObj).Value = TgtVal;
        
    elseif TgtVal < app.(TgtObj).Limits(1)
        
        TgtVal = app.(TgtObj).Limits(1);
        
        app.(EventObj).Value = num2str(TgtVal);
        app.(TgtObj).Value = TgtVal;
        
    else
        
        app.(EventObj).Value = num2str(TgtVal);        
        app.(TgtObj).Value = TgtVal;
        
    end
    
end