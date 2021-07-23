% 2020. 09. 29

% FS100_Player_v1_5_0 -> iMeasy_Multi_v1.0.0

% handles -> app

% function disp_Cam_Prop_inform(tgt, val)
function disp_Cam_Prop_inform(app, tgt, val, cur_Channel)

% global MAIN_handles cur_Channel;
% handles = MAIN_handles;

val = num2str(val);

radStr = sprintf('radiobutton_Ch%d', cur_Channel);
str1 = get(app.(radStr), 'Text');
tgtStr = sprintf('slider_%s', tgt);
str2 = get(app.(tgtStr), 'Tag');
% txtStr = sprintf('text_%s', tgt);
% str2 = get(app.(txtStr), 'Text');
prvStr = sprintf('Preview: %s,   %s: %s', str1, str2, val);
set(app.text_Status, 'Text', prvStr)

% eval(sprintf('str1 = get(handles.radiobutton_Ch%d, ''String'');', cur_Channel));
% eval(sprintf('str2 = get(handles.text_%s, ''String'');', tgt));
% eval(sprintf('set(handles.text_Status, ''String'', ''Preview: %s,   %s: %s'');', str1, str2, val));

