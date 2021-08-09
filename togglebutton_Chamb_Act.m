% 2021. 08. 02

% iMeasy_Multi_v1.0.0 -> easySCAN_v2.0.0

% function togglebutton_Chamb_Act(app, Tag, Chamb_No)
function togglebutton_Chamb_Act(app, tag, chambNo, currentChipInform)

% global cur_Chip cur_Chamb tog_in_color tog_out_color X_abs_um...
%     Y_abs_um Run_flag NoofChip

global CurrentChamber tog_in_color tog_out_color X_abs_um...
    Y_abs_um

% eval(sprintf('global C%d_NoofChamb;', cur_Chip));
% eval(sprintf('global C%d_Chamb%d_X_um;', cur_Chip, Chamb_No));
% eval(sprintf('global C%d_Chamb%d_Y_um;', cur_Chip, Chamb_No));
% eval(sprintf('C_NoofChamb = C%d_NoofChamb;', cur_Chip));
% eval(sprintf('C_Chamb_X_um = C%d_Chamb%d_X_um(1);', cur_Chip, Chamb_No));
% eval(sprintf('C_Chamb_Y_um = C%d_Chamb%d_Y_um(1);', cur_Chip, Chamb_No));
CurrentChamber = chambNo;

C_Chamb_X_um = currentChipInform.ChamberRange{chambNo, 1};
C_Chamb_Y_um = currentChipInform.ChamberRange{chambNo, 2};
C_NoofChamb = currentChipInform.ChamberNum(1) * currentChipInform.ChamberNum(2);

for i = 1:C_NoofChamb
    
    if i==chambNo
        
        tagStr = strcat(tag, num2str(i));
        set(app.(tagStr), 'BackgroundColor', tog_in_color)
        set(app.(tagStr), 'Value', 1)
        
    else
        
        tagStr = strcat(tag, num2str(i));
        set(app.(tagStr), 'BackgroundColor', tog_out_color)
        set(app.(tagStr), 'Value', 0)
        
    end
    
end

pause(0.01);

if X_abs_um<C_Chamb_X_um
    
    Stage_Control(app, 'X', 'B', C_Chamb_X_um-X_abs_um); 
    
else
    
    Stage_Control(app, 'X', 'F', X_abs_um-C_Chamb_X_um);    
    
end

if Y_abs_um<C_Chamb_Y_um
    
    Stage_Control(app, 'Y', 'B', C_Chamb_Y_um-Y_abs_um);  
    
else
    
    Stage_Control(app, 'Y', 'F', Y_abs_um-C_Chamb_Y_um);    
    
end

% TODO : Need confirm
% if CurrentChip~=(NoofChip+1)
% 
%     disp_Manual_inform_canvas(app)
%     
% end