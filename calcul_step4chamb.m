% 2021. 08. 04

% iMeasy_Multi_v1.0.0 -> easySCAN_v2.0.0

function calcul_step4chamb

% global StageList NoofChip step_per_um_X step_per_um_Y frame_W_um frame_H_um...    
%     Z_L_um im_W_um im_H_um C_Manual_X_um C_Manual_Y_um...
%     step_per_um_Z C_Manual_Z_um MovDiff_um;

global step_per_um_X step_per_um_Y...
 Z_L_um C_Manual_X_um C_Manual_Y_um...
 step_per_um_Z C_Manual_Z_um MovDiff_um ChipInform...
 step_Coarse_X_um step_Medium_X_um step_Fine_X_um...
 step_Coarse_Y_um step_Medium_Y_um step_Fine_Y_um...
 step_Coarse_Z_um step_Medium_Z_um step_Fine_Z_um...
 max_step_X max_step_Y max_step_Z...
 frame_W_um frame_H_um Pixel2umDefault lensMag LensMagDefault

% frame_W_um = 86000;
% frame_H_um = 128000;

chipNo = 1;
chambNo = 1;

currentChipInform = ChipInform(chipNo);

pixel2um = Pixel2umDefault * LensMagDefault/lensMag;

% Default ROI : Droplet chip (non-square, 1920x1200)
im_W_um = ChipInform(2).ROI(3) * pixel2um;
im_H_um = ChipInform(2).ROI(4) * pixel2um;

observeArea = [currentChipInform.ChamberRange{chambNo, 1}(2) -...
    currentChipInform.ChamberRange{chambNo, 1}(1),...
    currentChipInform.ChamberRange{chambNo, 2}(2) -...
    currentChipInform.ChamberRange{chambNo, 2}(1)]; % [X, Y]

gapFrame = [0 0];

if currentChipInform.FrameNum(1) >= 2    
    gapFrame(1) = observeArea(1) / (currentChipInform.FrameNum(1)-1);
% else
%     gapFrame(1) = 0;    
end

if currentChipInform.FrameNum(2) >= 2    
    gapFrame(2) = observeArea(2) / (currentChipInform.FrameNum(1)-1);
% else
%     gapFrame(2) = 0;    
end


% gapFrame = observeArea ./ (frameNum - 1); % [X, Y]

% for i = 1:length(StageList)
%     
%     Stage = StageList{i};
%     
%     eval(sprintf(...
%         'global step_Coarse_%s_um step_Medium_%s_um step_Fine_%s_um max_step_%s;',...
%         Stage, Stage, Stage, Stage));
%     
% end

step_per_um_X = max_step_X/(frame_W_um-MovDiff_um);
step_per_um_Y = max_step_Y/(frame_H_um-MovDiff_um);
step_per_um_Z = max_step_Z/(Z_L_um-MovDiff_um);

fprintf('Max step X = %d\n', max_step_X)
fprintf('Max step Y = %d\n', max_step_Y)
fprintf('Max step Z = %d\n', max_step_Z)

fprintf('X step/um = %d\n', step_per_um_X)
fprintf('Y step/um = %d\n', step_per_um_Y)
fprintf('Z step/um = %d\n', step_per_um_Z)

fprintf('Frame width = %d\n', frame_W_um)
fprintf('Frame height = %d\n', frame_H_um)
fprintf('Z Length = %d\n', Z_L_um)

step_Coarse_X_um = im_W_um*5;
step_Medium_X_um = im_W_um;
step_Fine_X_um = im_W_um*0.1;
step_Coarse_Y_um = im_H_um*5;
step_Medium_Y_um = im_H_um;
step_Fine_Y_um = im_H_um*0.1;
% step_Coarse_X_um = gapFrame(1)*5;
% step_Medium_X_um = gapFrame(1);
% step_Fine_X_um = gapFrame(1)*0.1;
% step_Coarse_Y_um = gapFrame(2)*5;
% step_Medium_Y_um = gapFrame(2);
% step_Fine_Y_um = gapFrame(2)*0.1;
step_Coarse_Z_um = 100;
step_Medium_Z_um = 10;
step_Fine_Z_um = 10/3;

fprintf('Coarse X = %d\n', step_Coarse_X_um)
fprintf('Medium X = %d\n', step_Medium_X_um)
fprintf('Fine X = %d\n', step_Fine_X_um)
fprintf('Coarse Y = %d\n', step_Coarse_Y_um)
fprintf('Medium Y = %d\n', step_Medium_Y_um)
fprintf('Fine Y = %d\n', step_Fine_Y_um)
fprintf('Coarse Z = %d\n', step_Coarse_Z_um)
fprintf('Medium Z = %d\n', step_Medium_Z_um)
fprintf('Fine Z = %d\n', step_Fine_Z_um)


% for i = 1:NoofChip
%     
%     eval(sprintf('global C%d_NoofChamb;', i));    
%     eval(sprintf('C_NoofChamb = C%d_NoofChamb;', i));
%     
%     for j = 1:C_NoofChamb
%         
%         eval(sprintf(...
%             'global C%d_Chamb%d_X_um C%d_Chamb%d_Y_um;', i, j, i, j));        
%         
%     end
%     
% end
        
C_Manual_X_um = [0, frame_W_um];
C_Manual_Y_um = [0, frame_H_um];
C_Manual_Z_um = [0, Z_L_um];