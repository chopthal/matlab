% 2020. 09. 29

%  FS100_Player_v1_5_0 -> iMeasy_Multi_v1.0.0

% handles -> app

% function slider_Prop(tgt)
function slider_Prop(app, tgt)

% global MAIN_handles cur_Channel;
global cur_Channel;

eval(sprintf('global Ch%d_%s;', cur_Channel, tgt));

% handles = MAIN_handles;
sldStr = sprintf('slider_%s', tgt);
editStr = sprintf('edit_%s', tgt);

if strcmp(tgt, 'Gamma')
    
    temp = round(get(app.(sldStr), 'Value') * 10) / 10;    
%     eval(sprintf('temp = get(handles.slider_%s, ''Value'');', tgt));
    
else
    
    temp = round(get(app.(sldStr), 'Value'));
%     eval(sprintf('temp = round(get(handles.slider_%s, ''Value''));', tgt));
    
end
    
% temp_val = temp;

set(app.(sldStr), 'Value', temp)
set(app.(editStr), 'Value', temp)
% eval(sprintf('set(handles.slider_%s, ''Value'', temp);', tgt));
% eval(sprintf('set(handles.edit_%s, ''String'', temp_val);', tgt));

eval(sprintf('Ch%d_%s = temp;', cur_Channel, tgt));
% Ch_set(cur_Channel);
Ch_set(app, cur_Channel);
    
% disp_Cam_Prop_inform(tgt, temp);
disp_Cam_Prop_inform(app, tgt, temp, cur_Channel);


