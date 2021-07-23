% 2021. 04. 01

% iMeasy_Multi_v1.0.5 -> easySCAN_v1_1_4

% Don't display time for scanning anymore.

function togglebutton_Chamb_Act(app, Tag, Chamb_No)

% startToggle = tic;

global cur_Chip cur_Chamb tog_in_color tog_out_color X_abs_um...
    Y_abs_um Run_flag NoofChip

eval(sprintf('global C%d_NoofChamb;', cur_Chip));
eval(sprintf('global C%d_Chamb%d_X_um;', cur_Chip, Chamb_No));
eval(sprintf('global C%d_Chamb%d_Y_um;', cur_Chip, Chamb_No));
eval(sprintf('C_NoofChamb = C%d_NoofChamb;', cur_Chip));
eval(sprintf('C_Chamb_X_um = C%d_Chamb%d_X_um(1);', cur_Chip, Chamb_No));
eval(sprintf('C_Chamb_Y_um = C%d_Chamb%d_Y_um(1);', cur_Chip, Chamb_No));
cur_Chamb = Chamb_No;

for i = 1:C_NoofChamb
    
    if i==Chamb_No
        
        tagStr = strcat(Tag, num2str(i));
        set(app.(tagStr), 'BackgroundColor', tog_in_color)
        set(app.(tagStr), 'Value', 1)
        
    else
        
        tagStr = strcat(Tag, num2str(i));
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

if cur_Chip~=(NoofChip+1)

    disp_Manual_inform_canvas(app)
    
end

% timeToggle = toc(startToggle);
% fprintf('Toggle act time = %d\n', timeToggle)
