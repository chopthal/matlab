

noFrameDefault = [3, 3; 2, 4]; % [C1; C2]

im_W_um_default = ROIPosition(3) * pix2um;
im_H_um_default = ROIPosition(4) * pix2um;

frame_W_um = 86000;
frame_H_um = 128000;

D_frame_rack_X = 0;
T_frame_rack_Y = 0;
D_rack_chip_X = 5000;
D_rack_chip_Y = 13050;

chip_W_um = 75600;
chip_H_um = 25600;

ManualCalibrX = -1120.4;
ManualCalibrY = -628;

NoofChip = 2;
cur_Chip = 0;
cur_Chamb = 1;

for i = 1:NoofChip
    
    eval(sprintf('global C%d_NoofChamb;', i));
    
end

C1_name = '96 Half Well Cell Culture Plate (SPL)';
C1_NoofChamb = 96;
C2_name = 'Droplet Counting Chip';
C2_NoofChamb = 6;

for i = 1:NoofChip
    
    eval(sprintf('C_name = C%d_name;', i));
    popupmenu_chip_str{i, 1} = C_name;
    eval(sprintf('C%d_SetChamb = ones(1, C%d_NoofChamb);', i, i));
    
    eval(sprintf('C_NoofChamb = C%d_NoofChamb;', i));
    
    for j = 1:C_NoofChamb
                
        eval(sprintf('global C%d_Chamb%d_X_um C%d_Chamb%d_Y_um;', i, j, i, j));
        
        toggleStr = sprintf('togglebutton_C%d_Chamb%d', i, j);
        
        set(app.(toggleStr), 'Value', 0)
        set(app.(toggleStr), 'BackgroundColor', tog_out_color)
                
    end
    
end

popupmenu_chip_str{NoofChip+1, 1} = 'Manual';
set(app.popupmenu_chip, 'Items', popupmenu_chip_str);

defaultCoorC1 = [...
    11170.2219815918 14446.7509812473;
    14648.4028153763 14446.7509812473;
    12888.3595018950 12600.9012937927;
    12930.2652950731 16188.3994766681;
    73716.9463995669 14502.5730484082;
    77237.0330265295 14502.5730484082;
    75393.1781266919 12790.6963221398;
    75476.9897130482 16303.7650821340;
    10970.0054141852 112723.360953627;
    14448.1862479697 112544.730338712;
    12688.1429344884 110966.826573630;
    12730.0487276665 114465.009449048;
    73484.1364374662 112842.448030237;
    76962.3172712507 112887.105683966;
    75244.1797509475 111085.913650240;
    75286.0855441256 114554.324756505
    ];

wellCent1    = [0 0];
wellCent8    = [0 0];
wellCent89   = [0 0];
wellCent96   = [0 0];

for i=1:4
                    
%     wellCent1  = wellCent1  + [defaultCoor(i, 1), defaultCoor(i, 2)];
%     wellCent8  = wellCent8  + [defaultCoor(i+4, 1), defaultCoor(i+4, 2)];
%     wellCent89 = wellCent89 + [defaultCoor(i+8, 1), defaultCoor(i+8, 2)];
%     wellCent96 = wellCent96 + [defaultCoor(i+12, 1), defaultCoor(i+12, 2)];
    wellCent1  = wellCent1  + [defaultCoorC1(i, 1), defaultCoorC1(i, 2)];
    wellCent8  = wellCent8  + [defaultCoorC1(i+4, 1), defaultCoorC1(i+4, 2)];
    wellCent89 = wellCent89 + [defaultCoorC1(i+8, 1), defaultCoorC1(i+8, 2)];
    wellCent96 = wellCent96 + [defaultCoorC1(i+12, 1), defaultCoorC1(i+12, 2)];

end

wellCent1  = wellCent1 / 4;
wellCent8  = wellCent8 / 4;
wellCent89 = wellCent89 / 4;
wellCent96 = wellCent96 / 4;

defaultCoorC2 = [...
    11170.2219815918 14446.7509812473;
    14648.4028153763 14446.7509812473;
    12888.3595018950 12600.9012937927;
    12930.2652950731 16188.3994766681;    
    ];

% TODO : for chamb
for i=1:4
    
    chambCent1 = chambCent1 + [defaultCoorC2(i, 1), defaultCoorC2(i, 2)];    

end

chambCent1 = chambCent1 / 4;

well_center_X_default = wellCent1(1, 1);
well_center_Y_default = wellCent1(1, 2);
chamb_center_X_default = chambCent1(1, 1);
chamb_center_Y_default = chambCent1(1, 2);

% rect_width_half_default = ((noFrameDefault - 1) / 2 + 0.01) * im_W_um_default;
rect_width_half_default = ((noFrameDefault(:, 1) - 1) / 2 + 0.01) * im_W_um_default;
rect_height_half_default = ((noFrameDefault(:, 2) - 1) / 2 + 0.01) * im_H_um_default;

well2wellHor_default = (wellCent8 - wellCent1 + wellCent96 - wellCent89) / 2 / 7;
well2wellVer_default = (wellCent89 - wellCent1 + wellCent96 - wellCent8) / 2 / 11;

chamb2chambHor_default = (chambCent2 - chambCent1 + chambCent6 - chambCent5) / 2;
chamb2chambVer_default = (chambCent5 - chambCent1 + chambCent6 - chambCent2) / 2 / 2;

if exist(CoorCorrFile, 'file') == 2

    load(CoorCorrFile);

else

    % Default
    well_center_X = well_center_X_default;
    well_center_Y = well_center_Y_default;
    chamb_center_X = chamb_center_X_default;
    chamb_center_Y = chamb_center_Y_default;
    rect_width_half = rect_width_half_default;
    
    well2wellVer = well2wellVer_default;
    well2wellHor = well2wellHor_default;    
    chamb2chambVer = chamb2chambVer_default;
    chamb2chambHor = chamb2chambHor_default;

    noFrame = noFrameDefault;

end

im_W_um = im_W_um_default * lensMagDefault/lensMag;
im_H_um = im_H_um_default * lensMagDefault/lensMag;

% TODO : rect width and height, C2. noFrame = [3 3; 2 4], rect_width_half =
% [00; 00]
if noFrame == 1
    
    rect_width_half = 0;
    rect_height_half = ;
    
else

    rect_width_half = ((noFrame - 1) / 2 + 0.01) * im_W_um_default;
    rect_height_half = ;
    
end

rect_width_half_mag = rect_width_half * lensMagDefault/lensMag;
rect_height_half_mag = ;

C1_Chamb1_X_um = [well_center_X - rect_width_half_mag, well_center_X + rect_width_half_mag];
C1_Chamb1_Y_um = [well_center_Y - rect_width_half_mag, well_center_Y + rect_width_half_mag];

% for i = 2:96
for i = 2:C1_NoofChamb
                
    if mod(i-1, 8) == 0
        
        eval(sprintf('C1_Chamb%d_X_um = C1_Chamb%d_X_um + well2wellVer(1, 1);', i, i-8));
        eval(sprintf('C1_Chamb%d_Y_um = C1_Chamb%d_Y_um + well2wellVer(1, 2);', i, i-8));

    else

        eval(sprintf('C1_Chamb%d_X_um = C1_Chamb%d_X_um + well2wellHor(1, 1);', i, i-1));
        eval(sprintf('C1_Chamb%d_Y_um = C1_Chamb%d_Y_um + well2wellHor(1, 2);', i, i-1));

    end

end

C2_Chamb1_X_um = [chamb_center_X - rect_width_half_mag, chamb_center_X + rect_width_half_mag];
C2_Chamb1_Y_um = [chamb_center_Y - rect_width_half_mag, chamb_center_Y + rect_width_half_mag];

for i = 2:C2_NoofChamb
                
    if mod(i-1, 2) == 0
        
        eval(sprintf('C2_Chamb%d_X_um = C2_Chamb%d_X_um + well2wellVer(1, 1);', i, i-8));
        eval(sprintf('C2_Chamb%d_Y_um = C2_Chamb%d_Y_um + well2wellVer(1, 2);', i, i-8));

    else

        eval(sprintf('C2_Chamb%d_X_um = C2_Chamb%d_X_um + well2wellHor(1, 1);', i, i-1));
        eval(sprintf('C2_Chamb%d_Y_um = C2_Chamb%d_Y_um + well2wellHor(1, 2);', i, i-1));

    end

end

if exist(CoorCorrFile, 'file') == 2

    load(CoorCorrFile);

else

    % Default
    well_center_X = well_center_X_default;
    well_center_Y = well_center_Y_default;
    chamb_center_X = chamb_center_X_default;
    chamb_center_Y = chamb_center_Y_default;
    rect_width_half = rect_width_half_default;
    
    well2wellVer = well2wellVer_default;
    well2wellHor = well2wellHor_default;    
    chamb2chambVer = chamb2chambVer_default;
    chamb2chambHor = chamb2chambHor_default;

    noFrame = noFrameDefault;

end