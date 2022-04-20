% 2021. 08. 09

% easySCAN_v1.1.0 -> easySCAN_v2.0.0

% 

function main_button_Enable(app, on_off)

% global cur_Chip NoofChip NoofChannel;
global CurrentChip ChipInform NoofChannel;

NoofChip = size(ChipInform, 2);

set(app.pushbutton_connect, 'Enable', on_off);

for i = 1:NoofChannel
    
    radioStr = sprintf('radiobutton_Ch%d', i);
    set(app.(radioStr), 'Enable', on_off)

end

set(app.radiobutton_Off, 'Enable', on_off);

if get(app.radiobutton_Off, 'Value') ~= 1

    set(app.slider_Exp, 'Enable', on_off);
    set(app.ExposureSliderLabel, 'Enable', on_off);
    set(app.edit_Exp, 'Enable', on_off);
    
    set(app.slider_Gamma, 'Enable', on_off);
    set(app.GammaSliderLabel, 'Enable', on_off);
    set(app.edit_Gamma, 'Enable', on_off);
    
    set(app.slider_Gain, 'Enable', on_off);
    set(app.GainSliderLabel, 'Enable', on_off);
    set(app.edit_Gain, 'Enable', on_off);
    
    set(app.slider_Inten, 'Enable', on_off);
    set(app.LEDSliderLabel, 'Enable', on_off);
    set(app.edit_Inten, 'Enable', on_off);
    
end

set(app.popupmenu_chip, 'Enable', on_off);

% % if cur_Chip~=(NoofChip+1)
% if CurrentChip~=(NoofChip+1)
%     
% %     eval(sprintf('global C%d_NoofChamb;', cur_Chip));
% %     eval(sprintf('C_NoofChamb = C%d_NoofChamb;', cur_Chip));
%     C_NoofChamb = ChipInform(CurrentChip).ChamberNum(1) * ChipInform(CurrentChip).ChamberNum(2);
%     
% %     for i = 1:C_NoofChamb
%     for chambNo = 1:C_NoofChamb
%         
% %         toggleStr = sprintf('togglebutton_C%d_Chamb%d', cur_Chip, i);
%         toggleStr = sprintf('togglebutton_C%d_Chamb%d', CurrentChip, chambNo);
%         set(app.(toggleStr), 'Enable', on_off)
%         
%     end
%     
% end 

set(app.pushbutton_Set_Folder, 'Enable', on_off);
set(app.pushbutton_Open, 'Enable', on_off);
set(app.listbox_StageUnit, 'Enable', on_off);
set(app.pushbutton_X_left, 'Enable', on_off);
set(app.pushbutton_X_right, 'Enable', on_off);
set(app.pushbutton_Y_up, 'Enable', on_off);
set(app.pushbutton_Y_down, 'Enable', on_off);
set(app.pushbutton_AF, 'Enable', on_off);
set(app.pushbutton_Z_in, 'Enable', on_off);
set(app.pushbutton_Z_out, 'Enable', on_off);

set(app.edit_Range, 'Enable', on_off);
set(app.RangeLabel, 'Enable', on_off);
set(app.DefaultButton, 'Enable', on_off);

if strcmp(on_off, 'on')
    
    if CurrentChip == (NoofChip+1)
        
        set(app.checkbox_withAF, 'Enable', 'off');
        set(app.pushbutton_RunSave, 'Enable', 'off');
        set(app.edit_RefZ, 'Enable', 'off');
        set(app.RefZLabel, 'Enable', 'off');      
        set(app.pushbutton_Ref, 'Enable', 'off');
        
    elseif CurrentChip == 1
        
        set(app.checkbox_withAF, 'Enable', 'on');
        set(app.pushbutton_RunSave, 'Enable', 'on');
        set(app.edit_RefZ, 'Enable', 'on');
        set(app.RefZLabel, 'Enable', 'on');        
        set(app.pushbutton_Ref, 'Enable', 'on');
        
    else
        
        set(app.checkbox_withAF, 'Enable', 'off');
        set(app.pushbutton_RunSave, 'Enable', 'on');
        set(app.edit_RefZ, 'Enable', 'off');
        set(app.RefZLabel, 'Enable', 'off');        
        set(app.pushbutton_Ref, 'Enable', 'on');
        
    end
    
%     if cur_Chip == 1
%     if CurrentChip == 1
%         
%         set(app.checkbox_withAF, 'Enable', 'on');
%         set(app.pushbutton_RunSave, 'Enable', 'on');
%         set(app.edit_RefZ, 'Enable', 'on');
%         set(app.RefZLabel, 'Enable', 'on');        
%         set(app.pushbutton_Ref, 'Enable', 'on');
%         
%     else
%         
%         set(app.checkbox_withAF, 'Enable', 'off');
%         set(app.pushbutton_RunSave, 'Enable', 'off');
%         set(app.edit_RefZ, 'Enable', 'off');
%         set(app.RefZLabel, 'Enable', 'off');      
%         set(app.pushbutton_Ref, 'Enable', 'off');
%         
%     end
    
else
    
    set(app.checkbox_withAF, 'Enable', 'off');
    set(app.pushbutton_RunSave, 'Enable', 'off');
    set(app.edit_RefZ, 'Enable', 'off');
    set(app.RefZLabel, 'Enable', 'off');      
    set(app.pushbutton_Ref, 'Enable', 'off');
    
end

set(app.edit_X, 'Enable', on_off);
set(app.XLabel, 'Enable', on_off);
set(app.edit_Y, 'Enable', on_off);
set(app.YEditFieldLabel, 'Enable', on_off);
set(app.edit_Z, 'Enable', on_off);
set(app.ZEditFieldLabel, 'Enable', on_off);
set(app.pushbutton_Reset, 'Enable', on_off);

set(app.pushbutton_Cam_Save, 'Enable', on_off);
set(app.pushbutton_Cam_Load, 'Enable', on_off);
set(app.listbox_StageUnit_Z, 'Enable', on_off);

set(app.pushbutton_Capture, 'Enable', on_off);
set(app.pushbutton_Set_Mode, 'Enable', on_off);
set(app.edit_Z_diff, 'Enable', on_off);
set(app.DiffLabel, 'Enable', on_off);
