% 2020. 09. 29

% ? -> iMeasy_Multi_v1.0.0

% handles -> app

% function PopupChipCallback
function PopupChipCallback(app)

global NoofChip cur_Chip

% escObject([], app.popupmenu_chip)
% escObject([], app.popupmenu_chip)

% Chip_No = get(app.popupmenu_chip, 'Value');
% Chip_No = get(app.popupmenu_chip, 'Value');

chipItems = get(app.popupmenu_chip, 'Items');
chipVal = get(app.popupmenu_chip, 'Value');

Chip_No = 0;

for i = 1:size(chipItems, 2)
    
    if strcmp(chipVal, chipItems{1, i})
        
        Chip_No = i;
        break
        
    end
    
end

if Chip_No==cur_Chip
    
    return;   
    
end

cur_Chip = Chip_No;

for i = 1:NoofChip
    
    btnGrpStr = sprintf('uibuttongroup_C%d', i);
    set(app.(btnGrpStr), 'Visible', 'off')
    
end

% set(app.uibuttongroup_Manual, 'Visible', 'off');
set(app.uibuttongroup_Manual, 'Visible', 'off');

if cur_Chip==(NoofChip+1)
    
    set(app.axes_Canvas, 'Visible', 'off');    
    delete(app.axes_Canvas.Children);
    
    set(app.uibuttongroup_Manual, 'Visible', 'on');    
    set(app.pushbutton_RunSave, 'Enable', 'off');
    
%     if Chamber_Setting_opend==1
%         
%         delete(Chamber_Setting_app.figure1);
%         
%         Chamber_Setting_opend = 0;
%         
%     end
    
%     disp_Manual_inform;
    disp_Manual_inform(app)

else
    
    set(app.axes_Canvas, 'Visible', 'on')
    btnGrpStr = sprintf('uibuttongroup_C%d', cur_Chip);
    set(app.(btnGrpStr), 'Visible', 'on')
%     eval(sprintf('set(app.uibuttongroup_C%d, ''Visible'', ''on'');', cur_Chip));   
    togStr = sprintf('togglebutton_C%d_Chamb1', cur_Chip);
    set(app.(togStr), 'Value', 1)
%     eval(sprintf('set(app.togglebutton_C%d_Chamb1, ''Value'', 1);', cur_Chip));
%     togglebutton_Chamb_Act(togStr, 1)
    Tag = sprintf('togglebutton_C%d_Chamb', cur_Chip);
%     togglebutton_Chamb_Act(app, togStr, 1)
    togglebutton_Chamb_Act(app, Tag, 1)
    set(app.pushbutton_RunSave, 'Enable', 'on');
%     eval(sprintf('togglebutton_Chamb_Act(''togglebutton_C%d_Chamb'', 1);', cur_Chip));
    
%     if Chamber_Setting_opend==1
%         
%         for i = 1:NoofChip
%             
%             eval(sprintf('set(Chamber_Setting_app.uipanel_C%d, ''Visible'', ''off'');',...
%                 i));
% 
%         end
%         
%         eval(sprintf('set(Chamber_Setting_app.uipanel_C%d, ''Visible'', ''on'');',...
%             cur_Chip));   
%         
%     end
    
    if cur_Chip == 1
    
%         canPos = [0.02976190476190476 0.08670520231213873 0.9464285714285714 0.8497109826589595];

    elseif cur_Chip == 2

%         canPos = [0.28273809523809523 0.08670520231213873 0.4375 0.8497109826589595];

    end
% 
%     set(app.axes_Canvas, 'Position', canPos);

end    