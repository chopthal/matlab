% 2021. 08. 04

% iMeasy_Multi_v1.0.0 -> easySCAN_v2.0.0

function PopupChipCallback(app)

global ChipInform CurrentChip

chipItems = get(app.popupmenu_chip, 'Items');
chipVal = get(app.popupmenu_chip, 'Value');

chipNo = 0;
chipNum = size(ChipInform, 2);

chipNo = find(strcmp(chipVal, chipItems));  


if chipNo == CurrentChip
    
    return;   
    
end

CurrentChip = chipNo;

for i = 1:chipNum
    
    btnGrpStr = sprintf('uibuttongroup_C%d', i);
    set(app.(btnGrpStr), 'Visible', 'off')
    
end

set(app.uibuttongroup_Manual, 'Visible', 'off');

if CurrentChip==(chipNum+1)
    
    set(app.axes_Canvas, 'Visible', 'off');    
    delete(app.axes_Canvas.Children);
    
    set(app.uibuttongroup_Manual, 'Visible', 'on');    
    set(app.pushbutton_RunSave, 'Enable', 'off');
    disp_Manual_inform(app)
    
    tmpROI = ChipInform(2).ROI; % Use a Droplet chip ROI
    
    set(app.checkbox_withAF, 'Enable', 'off');    
    set(app.edit_RefZ, 'Enable', 'off');
    set(app.RefZLabel, 'Enable', 'off');      
    set(app.pushbutton_Ref, 'Enable', 'off');    
    
elseif CurrentChip == 1
    
    set(app.axes_Canvas, 'Visible', 'on')
    btnGrpStr = sprintf('uibuttongroup_C%d', CurrentChip);
    set(app.(btnGrpStr), 'Visible', 'on')
    togStr = sprintf('togglebutton_C%d_Chamb1', CurrentChip);
    set(app.(togStr), 'Value', 1)
    tag = sprintf('togglebutton_C%d_Chamb', CurrentChip);
    togglebutton_Chamb_Act(app, tag, 1, ChipInform(CurrentChip))
    set(app.pushbutton_RunSave, 'Enable', 'on');
    
    set(app.checkbox_withAF, 'Enable', 'on');    
    set(app.edit_RefZ, 'Enable', 'on');
    set(app.RefZLabel, 'Enable', 'on');        
    set(app.pushbutton_Ref, 'Enable', 'on');
    
    tmpROI = ChipInform(chipNo).ROI;

else
    
    set(app.axes_Canvas, 'Visible', 'on')
    btnGrpStr = sprintf('uibuttongroup_C%d', CurrentChip);
    set(app.(btnGrpStr), 'Visible', 'on')
    togStr = sprintf('togglebutton_C%d_Chamb1', CurrentChip);
    set(app.(togStr), 'Value', 1)
    tag = sprintf('togglebutton_C%d_Chamb', CurrentChip);
    togglebutton_Chamb_Act(app, tag, 1, ChipInform(CurrentChip))
    set(app.pushbutton_RunSave, 'Enable', 'on');
    
    set(app.checkbox_withAF, 'Enable', 'off');    
    set(app.edit_RefZ, 'Enable', 'off');
    set(app.RefZLabel, 'Enable', 'off');        
    set(app.pushbutton_Ref, 'Enable', 'on');    
    
    tmpROI = ChipInform(chipNo).ROI;

end    

isConnection = 0;
SettingCameraROI(app, tmpROI, isConnection);
DefineGlobalMovingStep(tmpROI)