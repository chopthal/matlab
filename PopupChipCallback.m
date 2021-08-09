% 2021. 08. 04

% iMeasy_Multi_v1.0.0 -> easySCAN_v2.0.0

function PopupChipCallback(app)

% global NoofChip cur_Chip
global ChipInform CurrentChip

chipItems = get(app.popupmenu_chip, 'Items');
chipVal = get(app.popupmenu_chip, 'Value');

% Chip_No = 0;
chipNo = 0;
chipNum = size(ChipInform, 2);

for i = 1:size(chipItems, 2)
    
    if strcmp(chipVal, chipItems{1, i})
        
        chipNo = i;
        break
        
    end
    
end

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

else
    
    set(app.axes_Canvas, 'Visible', 'on')
    btnGrpStr = sprintf('uibuttongroup_C%d', CurrentChip);
    set(app.(btnGrpStr), 'Visible', 'on')
    togStr = sprintf('togglebutton_C%d_Chamb1', CurrentChip);
    set(app.(togStr), 'Value', 1)
    tag = sprintf('togglebutton_C%d_Chamb', CurrentChip);
%     togglebutton_Chamb_Act(app, Tag, 1)
    togglebutton_Chamb_Act(app, tag, CurrentChip, ChipInform(CurrentChiip))
    set(app.pushbutton_RunSave, 'Enable', 'on');
    
    if CurrentChip == 1

    elseif CurrentChip == 2

    end

end    