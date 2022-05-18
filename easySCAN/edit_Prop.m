% 2020. 10. 23

% FS100_Player_v1_5_0 -> iMeasy_Multi_v1.0.0

% handles -> app
% Valid Check : round

% function edit_Prop(tgt)
function edit_Prop(app, tgt)

% global MAIN_app cur_Channel;
global cur_Channel;

eval(sprintf('global %sRange;', tgt));
eval(sprintf('global Ch%d_%s;', cur_Channel, tgt));

% app = MAIN_app;

eval(sprintf('Ch_Prop = Ch%d_%s;', cur_Channel, tgt));
eval(sprintf('PropRange = %sRange;', tgt));

editStr = sprintf('edit_%s', tgt);
temp = get(app.(editStr), 'Value');
% eval(sprintf('temp = get(app.edit_%s, ''String'');', tgt));
% temp = str2double(temp);

% if isnan(temp)||(temp==Ch_Prop)
if temp==Ch_Prop
    
%     set(app.(editStr), 'Value', Ch_Prop)
%     eval(sprintf('set(app.edit_%s, ''String'', Ch_Prop);', tgt));    
    return;

end

if ~strcmp(tgt, 'Gamma')
    
    temp = round(temp);
    
else
    
    temp = round(temp * 10) / 10;
    
end

if temp<PropRange(1)
    
    temp = PropRange(1);
    
elseif PropRange(2)<temp
    
    temp = PropRange(2);    
   
end

sliderStr = sprintf('slider_%s', tgt);
set(app.(editStr), 'Value', temp)
set(app.(sliderStr), 'Value', temp)
% eval(sprintf('set(app.edit_%s, ''String'', temp);', tgt));
% eval(sprintf('set(app.slider_%s, ''Value'', temp);', tgt));
eval(sprintf('Ch%d_%s = temp;', cur_Channel, tgt));
% Ch_set(cur_Channel);
Ch_set(app, cur_Channel);

disp_Cam_Prop_inform(app, tgt, temp, cur_Channel);