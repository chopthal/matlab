% 2021. 08. 04

% easySCAN_v1_1_3 -> easySCAN_v2_0_0

% 

function Stage_Control(app, stage, dir, inq_um)

% global Main_port NoofChip cur_Chamb cur_Chip Run_flag...
%     AF_flag Z_BM cur_Channel Z_diff Z_L_um MovDiff_um Reset_flag StageFlag CamInform
global Main_port CurrentChip CurrentChamber Run_flag...
    AF_flag Z_BM cur_Channel Z_diff Z_L_um MovDiff_um Reset_flag StageFlag CamInform ChipInform...
    X_abs_um Y_abs_um Z_abs_um X_curDir Y_curDir Z_curDir step_per_um_X step_per_um_Y step_per_um_Z...
    step_Coarse_X step_Medium_X step_Fine_X step_Coarse_Y step_Medium_Y step_Fine_Y step_Coarse_Z step_Medium_Z step_Fine_Z

StageFlag = 1;

% eval(sprintf('global %s_abs_um;', stage));
% eval(sprintf('global %s_curDir;', stage));
% eval(sprintf('curDir = %s_curDir;', stage));
% eval(sprintf('global step_per_um_%s;', stage));

backLash_X_um = 0;
backLash_Y_um = 0;
backLash_Z_um = 0;
backLash_um = 0;

if (Run_flag==0)&&(AF_flag==0)&&(Reset_flag==0)
    
end

if isempty(inq_um)
    
    if stage == 'Z'

        StageUnit = get(app.listbox_StageUnit_Z, 'Value');
        
    else

        StageUnit = get(app.listbox_StageUnit, 'Value');
        
    end
    
    % eval(sprintf('global step_%s_%s_um;', StageUnit, stage));
    eval(sprintf('inq_um = step_%s_%s_um;', StageUnit, stage));
    
end

if ~strcmp(curDir, dir)

    eval(sprintf('backLash_um = backLash_%s_um;', stage));
    
end

if strcmp(stage, 'X')||strcmp(stage, 'Y')

    if CurrentChip==(size(ChipInform, 2)+1) % Manual

        if strcmp(stage, 'X')
        
            stg_min_um = C_Manual_X_um(1);
            stg_max_um = C_Manual_X_um(2);
            
        elseif strcmp(stage, 'Y')
            
            stg_min_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 2}(1);
            stg_max_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 2}(2);
            
        end

        % eval(sprintf('global C_Manual_%s_um;', stage));
        % C_Chamb_stg = strcat('C_Manual_', stage, '_um');
        % eval(sprintf('stg_min_um = %s(1);', C_Chamb_stg));
        % eval(sprintf('stg_max_um = %s(2);', C_Chamb_stg)); 

    else

        if strcmp(stage, 'X')
        
            stg_min_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 1}(1);
            stg_max_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 1}(2);
            
        elseif strcmp(stage, 'Y')
            
            stg_min_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 2}(1);
            stg_max_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 2}(2);
            
        end

    end

%         C_Chamb_stg = strcat('C', num2str(CurrentChip), '_Chamb', num2str(CurrentChamber), '_', stage, '_um');
%         eval(sprintf('global %s;', C_Chamb_stg));

%     eval(sprintf('stg_min_um = %s(1);', C_Chamb_stg));
%     eval(sprintf('stg_max_um = %s(2);', C_Chamb_stg)); 
    

elseif strcmp(stage, 'Z')

    stg_min_um = 0;
    stg_max_um = Z_L_um;

end

if strcmp(dir, 'B')

    eval(sprintf('temp_abs_um = %s_abs_um + inq_um;', stage));    

    if stg_max_um<temp_abs_um

        Um = inq_um-(temp_abs_um-stg_max_um) + backLash_um;
        temp_abs_um = stg_max_um;

    else

        Um = inq_um + backLash_um;        

    end       

elseif strcmp(dir, 'F')

    eval(sprintf('temp_abs_um = %s_abs_um-inq_um;', stage));

    if temp_abs_um<stg_min_um

        Um = inq_um-(stg_min_um-temp_abs_um) + backLash_um;
        temp_abs_um = stg_min_um;

    else

        Um = inq_um + backLash_um;        

    end     

end

eval(sprintf('Step = floor(Um * step_per_um_%s);', stage));

if Step > 0
    
    TX = strcat('$S#', stage, '#', dir, '#', num2str(Step));
    [comm_err] = comm2port(app, 'Main_port', TX, []);
    
    % Left / Up : F
    % Right / Down : B
    
    if strcmp(dir, 'F')
        
        if strcmp(comm_err(end-1:end), 'EM')
            
            eval(sprintf('%s_abs_um = C_Manual_%s_um(1) + MovDiff_um;', stage, stage));
            eval(sprintf('%s_curDir = ''B'';', stage));
            
        else
        
            eval(sprintf('%s_abs_um = %s_abs_um + backLash_um - Step/step_per_um_%s;', stage, stage, stage));            
            
        end
        
    else
        
        if strcmp(comm_err(end-1:end), 'EM')
            
            eval(sprintf('%s_abs_um = C_Manual_%s_um(2) - MovDiff_um;', stage, stage));
            eval(sprintf('%s_curDir = ''F'';', stage));
            
        else
        
            eval(sprintf('%s_abs_um = %s_abs_um - backLash_um + Step/step_per_um_%s;', stage, stage, stage));
            
        end
        
    end
        
end

eval(sprintf('set(app.edit_%s, ''Value'', %s_abs_um);', stage, stage));    

if CurrentChip==(size(ChipInform, 2)+1)
        
    disp_Manual_inform(app);

else

    str1 = get(app.popupmenu_chip, 'Value');
    chambName = idx2name(CurrentChamber);
    eval(sprintf('str2 = ''Chamber: %s'';', chambName));
    stStr = sprintf('Chip: %s,   %s', str1, str2);
    set(app.text_Status, 'Text', stStr)
    disp_Manual_inform_canvas(app)

end         
       
eval(sprintf('%s_curDir = dir;', stage));

StageFlag = 0;

CamInform.Pos.Tic = tic; % 위치 이동 완료 후 코드 삽입