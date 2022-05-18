% 2020. 10. 13
% ? -> iMeasy_Multi_v1.0.0

% eventdata -> event

% function escObject(eventdata, hObject)
function escObject(event)

% if isempty(eventdata)
% if isempty(event)
    
    set(event.Source, 'enable', 'off')
    set(event.Source, 'enable', 'off')
    pause(realmin)
    set(event.Source, 'enable', 'on')
    set(event.Source, 'enable', 'on') 
    
% else

%     if strcmp(event.Key, 'return') || strcmp(event.Key, 'escape')
%         
%         escClick(event)
% 
%     end

end

% function escClick(event)
% 
% set(event.Source, 'enable', 'off')
% set(event.Source, 'enable', 'off')
% pause(realmin)
% set(event.Source, 'enable', 'on')
% set(event.Source, 'enable', 'on') 