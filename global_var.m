 % 2021. 07. 23

% iMeasy_Multi_v1.0.0 -> easySCAN_v2.0.0

function global_var(app)

% global MAIN_app DeviceName CamName MainPortNo...
%     PortNoFile ChPropFile StgStepFile cap_folder Run_flag AF_flag...
%     menu_id_list menu_ANALYSIS_opened Chamber_Setting_opened...
%     NoofChannel cur_Channel ChPropList StageList...
%     max_step Z_default_um...
%     im_W_um im_H_um frame_W_um frame_H_um tog_in_color tog_out_color...
%     NoofChip cur_Chip cur_Chamb Z_L_um C1_Chamb_W_um C1_Chamb_H_um posFlag...
%     posCanvas_LandimNo posCanvas_PortimNo ROIPosition logo_img MovDiff_um...
%     FluorMode FluorModeFile CoorCorrFile well_center_X_default...
%     well_center_Y_default rect_width_half_default well2wellHor_default...
%     well2wellVer_default defaultCoor lensMag lensMagDefault im_W_um_default...
%     im_H_um_default C_folder scanCh noFrameDefault chName AFPropFile...
%     AFRangeDefault AFRange AFInterval noFrame defaultRefZ Reset_flag...
%     refZ Stop_flag StageFlag LogPath CaptureFlag

global DeviceName CamName MainPortNo...
    PortNoFile ChPropFile StgStepFile cap_folder Run_flag AF_flag...
    menu_id_list menu_ANALYSIS_opened Chamber_Setting_opened...
    NoofChannel cur_Channel ChPropList StageList...
    max_step Z_default_um...
    tog_in_color tog_out_color...
    Z_L_um posFlag...
    logo_img MovDiff_um...
    FluorMode FluorModeFile CoorCorrFile LensMagDefault lensMag...
     C_folder scanCh  chName AFPropFile...
    AFRangeDefault AFRange defaultRefZ Reset_flag...
    refZ Stop_flag StageFlag LogPath CaptureFlag ...
    Pixel2umDefault ObserveRateDefault OverlabRateDefault...
    CurrentChamber CurrentChip ChipInform frame_W_um frame_H_um...
    MainChipNo ROIDefault

MainChipNo = 2;

CurrentChamber = 1;
CurrentChip = 1;

CaptureFlag = 0;
StageFlag = 0;
Stop_flag = 0;
% noFrameDefault = 3;
% noFrameDefault = [3, 3; 2, 4]; % [C1; C2]

LensMagDefault = 20;
% lensMag = 20;

logo_img = imread('logo.png');

posFlag = 0;

CompanyName = 'BIOROOTS';
DeviceName = 'Maximultix';
SWName = 'easySCAN';
CamName = 'acA'; % Basler acA
MainPortNo = [];
eval(sprintf('C_folder = ''C:/%s/%s/%s'';', CompanyName, DeviceName, SWName));
PortNoFile = fullfile(C_folder, 'Port_Number.mat');
ChPropFile = fullfile(C_folder, 'Preview_Set.mat');
StgStepFile = fullfile(C_folder, 'Stage_Step.mat');
FluorModeFile = fullfile(C_folder, 'Fluor_Mode.mat');
CoorCorrFile = fullfile(C_folder, 'CoorCorrFile.mat');
AFPropFile = fullfile(C_folder, 'AFPropFile.mat');
LogPath = fullfile(C_folder, 'LogData');

cap_folder = 0;
Run_flag = 0;
AF_flag = 0;
Reset_flag = 0;

AFRangeDefault = 400;
menu_id_list = {'ANALYSIS', 'Options', 'Stage_Calibration'};

menu_ANALYSIS_opened = 0;
Chamber_Setting_opened = 0;

NoofChannel = 2;
cur_Channel = 1;
ChPropList = {'Exp', 'Gamma', 'Gain', 'Inten'};

for chPropNum = 1:length(ChPropList)
    
    ChPropList_i = ChPropList{chPropNum};
    
    eval(sprintf('global %sRange;', ChPropList_i));
    
end

ExpRange = [50, 2000]; % ms
GammaRange = [1, 4];

GainRange = [0, 24]; % 200121 Test New Camera
IntenRange = [0, 255];

for chPropNum = 1:length(ChPropList)
    
    ChPropList_i = ChPropList{chPropNum};    
    
    eval(sprintf('default_%s = round(mean(%sRange));',ChPropList_i, ChPropList_i));     
   
    for j = 1:NoofChannel   
        
        eval(sprintf('global Ch%d_%s;', j, ChPropList_i));
        
        eval(sprintf('Ch%d_%s = default_%s;',j, ChPropList_i, ChPropList_i));               
        
    end

end

for chNum = 1:NoofChannel
    
    eval(sprintf('global Ch%d_Colormap;', chNum));
    eval(sprintf('global Ch%d_SavedFieldName;', chNum));    
    
end

Ch1_Colormap = linspace(0, 1, 256)';
Ch1_Colormap(:, 2) = linspace(0, 1, 256)';
Ch1_Colormap(:, 3) = linspace(0, 1, 256)';
Ch1_SavedFieldName = 'BM';

Ch2_Colormap = Ch1_Colormap;
Ch2_SavedFieldName = 'FM';

StageList = {'X', 'Y', 'Z'};

for stageNum = 1:length(StageList)
    
    Stage = StageList{stageNum};    
    eval(sprintf('global max_step_%s;', Stage));    
    eval(sprintf('max_step_%s = [];', Stage));    
    
end

max_step = 999999;
MovDiff_um = 0;

PSHoleUp = 2;
PSHoleDn = 1;
PSHole2Hole = 4000;

PSUp2Up = 120000;
PSGuideLen = 89000;
PS2Hole = 6500;

Z_L_um = PSUp2Up - PSHole2Hole*(PSHoleUp-1) + PSHole2Hole*(PSHoleDn-1) - PS2Hole*2 - PSGuideLen;

% chipROI = {[360 0 1200 1200]; % [X-offset, Y-offset, Width, Height]
%     [0 0 1920 1200];
%     [710 350 500 500]};  
% ROIDefault = [0 0 1920 1200];
chipROI = {[0 0 5496 3672]; % [X-offset, Y-offset, Width, Height]
    [0 0 5496 3672];
    [0 0 5496 3672]};  
ROIDefault = [0 0 5496 3672];
ObserveRateDefault = 1.0; 
OverlabRateDefault = [0.1, 0.1]; % horizontal, vertical
% pix2um = 250/774 * 1.2; % 20x lens
% Pixel2umDefault = 250/774 * 1.2; % 20x lens
% Pixel2umDefault = 1000/260 * 4/20; % 20x lens
% Pixel2umDefault = 1000/630 * 4/20; % 20x lens
Pixel2umDefault = 1000/866 * 4/20; % 20x lens

% im_W_um_default = ROIPosition(3) * pix2um;
% im_H_um_default = ROIPosition(4) * pix2um;

frame_W_um = 86000;
frame_H_um = 128000;
% 
% D_frame_rack_X = 0;
% T_frame_rack_Y = 0;
% D_rack_chip_X = 5000;
% D_rack_chip_Y = 13050;
% 
% chip_W_um = 75600;
% chip_H_um = 25600;
% 
% ManualCalibrX = -1120.4;
% ManualCalibrY = -628;

tog_out_color = [0.38,0.82,1.00];
tog_in_color = [0.20,0.57,0.88]; 

% NoofChip = 1;
% NoofChip = 2;
chipNum = 3;
% cur_Chip = 0;
% cur_Chamb = 1;
% 
% for i = 1:NoofChip
%     
%     eval(sprintf('global C%d_NoofChamb;', i));
%     
% end

% C1_name = '96 Half Well Cell Culture Plate (SPL)';
% C1_NoofChamb = 96;
% C2_name = 'Droplet Counting Chip';
% C2_NoofChamb = 6;
chipName = {'96 Half Well Cell Culture Plate (SPL)';
    'Droplet Counting Chip (Smaller)';
    'Droplet Counting Chip (Bigger)'};

chipType = {'WellPlate';
    'Droplet';
    'Droplet'};

chamberNum = {[8 12]; % 96 well plate
    [1 3];
    [1 1]};

defaultCoor = cell(chipNum, 1); % {node1; node2; node3; node4}

% Unit : um
defaultCoor{1, 1} = [...
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
defaultCoor{2, 1} = [...
    25818.0643076426,17900.9157079127;
    61265.7941509129,18817.5628081709;
    25822.6961813971,31740.7842216483;
    61265.7941509129,32657.4313219066;
    23622.5561480045,56929.7957266964;
    59065.6541175203,56929.7957266964;
    23622.5561480045,70311.3406903029;
    59065.6541175203,70769.6642404320;
    23622.5561480045,94790.3263676920;
    59065.6541175204,94790.3263676920;
    23622.5561480046,108171.871331298;
    59065.6541175204,108630.194881428    
    ];
defaultCoor{3, 1} = [...
    23628.0059269948,56843.7180908282;
    27000,56843.7180908282;
    23628.0059269948,70225.2630544347;
    27000,70225.2630544347  
    ];

% ChipInform = struct;
% 
% for chipNumi = 1:chipNum
%     
%     chipInformStruct = struct;    
%     chipInformStruct = CalculateChamberCoordinate(...
%         chipType{chipNumi, 1}, chipName{chipNumi, 1}, defaultCoor{chipNumi, 1},...
%         defaultCoor{chipNumi, 1}, chipROI{chipNumi, 1}, chamberNum{chipNumi, 1},...
%         Pixel2um, observeRate, overlabRate);
%     
%     structField = fieldnames(chipInformStruct);
%     
%     for fieldNum = 1:size(structField, 1)
%         ChipInform(chipNumi).(structField{fieldNum, 1}) = chipInformStruct.(structField{fieldNum, 1});
%     end
%     
%     for chamberNumi = 1:ChipInform(chipNumi).ChamberNum
%         
%         toggleStr = sprintf('togglebutton_C%d_Chamb%d', chipNumi, chamberNumi);
%         set(app.(toggleStr), 'Value', 0)
%         set(app.(toggleStr), 'BackgroundColor', tog_out_color)
%         
%     end
%     
% end

% for i = 1:NoofChip
%     
%     eval(sprintf('C_name = C%d_name;', i));
%     popupmenu_chip_str{i, 1} = C_name;
%     eval(sprintf('C%d_SetChamb = ones(1, C%d_NoofChamb);', i, i));
%     
%     eval(sprintf('C_NoofChamb = C%d_NoofChamb;', i));
%     
%     for j = 1:C_NoofChamb
%                 
%         eval(sprintf('global C%d_Chamb%d_X_um C%d_Chamb%d_Y_um;', i, j, i, j));
%         
%         toggleStr = sprintf('togglebutton_C%d_Chamb%d', i, j);
%         
%         set(app.(toggleStr), 'Value', 0)
%         set(app.(toggleStr), 'BackgroundColor', tog_out_color)
%                 
%     end
%     
% end
% 
% popupmenu_chip_str{NoofChip+1, 1} = 'Manual';
% set(app.popupmenu_chip, 'Items', popupmenu_chip_str);

% Product Serial No : 003 2009 002
% defaultCoor = [...
%     11170.2219815918 14446.7509812473;
%     14648.4028153763 14446.7509812473;
%     12888.3595018950 12600.9012937927;
%     12930.2652950731 16188.3994766681;
%     73716.9463995669 14502.5730484082;
%     77237.0330265295 14502.5730484082;
%     75393.1781266919 12790.6963221398;
%     75476.9897130482 16303.7650821340;
%     10970.0054141852 112723.360953627;
%     14448.1862479697 112544.730338712;
%     12688.1429344884 110966.826573630;
%     12730.0487276665 114465.009449048;
%     73484.1364374662 112842.448030237;
%     76962.3172712507 112887.105683966;
%     75244.1797509475 111085.913650240;
%     75286.0855441256 114554.324756505
%     ];
% defaultCoorC1 = [...
%     11170.2219815918 14446.7509812473;
%     14648.4028153763 14446.7509812473;
%     12888.3595018950 12600.9012937927;
%     12930.2652950731 16188.3994766681;
%     73716.9463995669 14502.5730484082;
%     77237.0330265295 14502.5730484082;
%     75393.1781266919 12790.6963221398;
%     75476.9897130482 16303.7650821340;
%     10970.0054141852 112723.360953627;
%     14448.1862479697 112544.730338712;
%     12688.1429344884 110966.826573630;
%     12730.0487276665 114465.009449048;
%     73484.1364374662 112842.448030237;
%     76962.3172712507 112887.105683966;
%     75244.1797509475 111085.913650240;
%     75286.0855441256 114554.324756505
%     ];

% wellCent1    = [0 0];
% wellCent8    = [0 0];
% wellCent89   = [0 0];
% wellCent96   = [0 0];

% for i=1:4
%                     
% %     wellCent1  = wellCent1  + [defaultCoor(i, 1), defaultCoor(i, 2)];
% %     wellCent8  = wellCent8  + [defaultCoor(i+4, 1), defaultCoor(i+4, 2)];
% %     wellCent89 = wellCent89 + [defaultCoor(i+8, 1), defaultCoor(i+8, 2)];
% %     wellCent96 = wellCent96 + [defaultCoor(i+12, 1), defaultCoor(i+12, 2)];
%     wellCent1  = wellCent1  + [defaultCoorC1(i, 1), defaultCoorC1(i, 2)];
%     wellCent8  = wellCent8  + [defaultCoorC1(i+4, 1), defaultCoorC1(i+4, 2)];
%     wellCent89 = wellCent89 + [defaultCoorC1(i+8, 1), defaultCoorC1(i+8, 2)];
%     wellCent96 = wellCent96 + [defaultCoorC1(i+12, 1), defaultCoorC1(i+12, 2)];
% 
% end

% wellCent1  = wellCent1 / 4;
% wellCent8  = wellCent8 / 4;
% wellCent89 = wellCent89 / 4;
% wellCent96 = wellCent96 / 4;
% 
% defaultCoorC2 = [...
%     11170.2219815918 14446.7509812473;
%     14648.4028153763 14446.7509812473;
%     12888.3595018950 12600.9012937927;
%     12930.2652950731 16188.3994766681;    
%     ];
% 
% % TODO : for chamb
% for i=1:4
%     
%     chambCent1 = chambCent1 + [defaultCoorC2(i, 1), defaultCoorC2(i, 2)];    
% 
% end
% 
% chambCent1 = chambCent1 / 4;
% 
% well_center_X_default = wellCent1(1, 1);
% well_center_Y_default = wellCent1(1, 2);
% chamb_center_X_default = chambCent1(1, 1);
% chamb_center_Y_default = chambCent1(1, 2);
% 
% % rect_width_half_default = ((noFrameDefault - 1) / 2 + 0.01) * im_W_um_default;
% rect_width_half_default = ((noFrameDefault(:, 1) - 1) / 2 + 0.01) * im_W_um_default;
% rect_height_half_default = ((noFrameDefault(:, 2) - 1) / 2 + 0.01) * im_H_um_default;
% 
% well2wellHor_default = (wellCent8 - wellCent1 + wellCent96 - wellCent89) / 2 / 7;
% well2wellVer_default = (wellCent89 - wellCent1 + wellCent96 - wellCent8) / 2 / 11;
% 
% chamb2chambHor_default = (chambCent2 - chambCent1 + chambCent6 - chambCent5) / 2;
% chamb2chambVer_default = (chambCent5 - chambCent1 + chambCent6 - chambCent2) / 2 / 2;

if exist(C_folder, 'dir')~=7
        
    mkdir(C_folder);
    
end
    
if exist(PortNoFile, 'file')==2

    load(PortNoFile);   

end

if exist(ChPropFile, 'file')==2

    load(ChPropFile);         

    for propNum = 1:length(ChPropList)

        ChPropList_i = ChPropList{propNum};    

        for chNumi = 1:NoofChannel

            eval(sprintf('Ch_Prop = Ch%d_%s;', chNumi, ChPropList_i));
            eval(sprintf('PropRange = %sRange;', ChPropList_i));

            if isnan(Ch_Prop)||(Ch_Prop<PropRange(1))||(PropRange(2)<Ch_Prop)

                eval(sprintf('Ch%d_%s = default_%s;', chNumi, ChPropList_i, ChPropList_i));

            end

        end

    end

end

if exist(StgStepFile, 'file')==2

    load(StgStepFile);

end

if exist(FluorModeFile, 'file') == 2

    load(FluorModeFile);

else

    FluorMode = 'PE';
    lensMag = LensMagDefault; % 20x
    scanCh = [1 2];
    chName = 'Ch1 & 2';

end

pixel2um = Pixel2umDefault * LensMagDefault/lensMag;

set(app.edit_Z_diff, 'Visible', size(scanCh, 2) == 2)
set(app.DiffLabel, 'Visible', size(scanCh, 2) == 2)
set(app.pushbutton_Set_Mode, 'Visible', size(scanCh, 2) == 2)

if exist(CoorCorrFile, 'file') == 2

    load(CoorCorrFile);

else
    
    ChipInform = struct;

    for chipNumi = 1:chipNum

        chipInformStruct = struct;
        chipInformStruct = CalculateChamberCoordinate(...
            chipType{chipNumi, 1}, chipName{chipNumi, 1}, defaultCoor{chipNumi, 1},...
            defaultCoor{chipNumi, 1}, chipROI{chipNumi, 1}, chamberNum{chipNumi, 1},...
            pixel2um, ObserveRateDefault, OverlabRateDefault);

        structField = fieldnames(chipInformStruct);

        for fieldNum = 1:size(structField, 1)
            ChipInform(chipNumi).(structField{fieldNum, 1}) = chipInformStruct.(structField{fieldNum, 1});
        end

        for chamberNumi = 1:ChipInform(chipNumi).ChamberNum(1)*ChipInform(chipNumi).ChamberNum(2)
            
            toggleStr = sprintf('togglebutton_C%d_Chamb%d', chipNumi, chamberNumi);                
            set(app.(toggleStr), 'BackgroundColor', tog_out_color)
            
            if ChipInform(chipNumi).ChamberNum ~= 1
                set(app.(toggleStr), 'Value', 0)
            end

        end
    
    end

%     % Default
%     well_center_X = well_center_X_default;
%     well_center_Y = well_center_Y_default;
%     chamb_center_X = chamb_center_X_default;
%     chamb_center_Y = chamb_center_Y_default;
%     rect_width_half = rect_width_half_default;
%     
%     well2wellVer = well2wellVer_default;
%     well2wellHor = well2wellHor_default;    
%     chamb2chambVer = chamb2chambVer_default;
%     chamb2chambHor = chamb2chambHor_default;
% 
%     noFrame = noFrameDefault;

end

if exist(AFPropFile, 'file') == 2

    load(AFPropFile)

else

    AFRange = AFRangeDefault;

    if lensMag == 4
    
        defaultRefZ = 8600;

    elseif lensMag == 10

        defaultRefZ = 1000;

    else

        defaultRefZ = 900;

    end
    
    refZ = defaultRefZ;

end

% im_W_um = im_W_um_default * lensMagDefault/lensMag;
% im_H_um = im_H_um_default * lensMagDefault/lensMag;

% TODO : rect width and height, C2. noFrame = [3 3; 2 4], rect_width_half =
% [00; 00]
% if noFrame == 1
%     
%     rect_width_half = 0;
%     rect_height_half = ;
%     
% else
% 
%     rect_width_half = ((noFrame - 1) / 2 + 0.01) * im_W_um_default;
%     rect_height_half = ;
%     
% end

% rect_width_half_mag = rect_width_half * lensMagDefault/lensMag;
% rect_height_half_mag = ;
% 
% C1_Chamb1_X_um = [well_center_X - rect_width_half_mag, well_center_X + rect_width_half_mag];
% C1_Chamb1_Y_um = [well_center_Y - rect_width_half_mag, well_center_Y + rect_width_half_mag];

% for i = 2:96
% for i = 2:C1_NoofChamb
%                 
%     if mod(i-1, 8) == 0
%         
%         eval(sprintf('C1_Chamb%d_X_um = C1_Chamb%d_X_um + well2wellVer(1, 1);', i, i-8));
%         eval(sprintf('C1_Chamb%d_Y_um = C1_Chamb%d_Y_um + well2wellVer(1, 2);', i, i-8));
% 
%     else
% 
%         eval(sprintf('C1_Chamb%d_X_um = C1_Chamb%d_X_um + well2wellHor(1, 1);', i, i-1));
%         eval(sprintf('C1_Chamb%d_Y_um = C1_Chamb%d_Y_um + well2wellHor(1, 2);', i, i-1));
% 
%     end
% 
% end
% 
% C2_Chamb1_X_um = [chamb_center_X - rect_width_half_mag, chamb_center_X + rect_width_half_mag];
% C2_Chamb1_Y_um = [chamb_center_Y - rect_width_half_mag, chamb_center_Y + rect_width_half_mag];
% 
% for i = 2:C2_NoofChamb
%                 
%     if mod(i-1, 2) == 0
%         
%         eval(sprintf('C2_Chamb%d_X_um = C2_Chamb%d_X_um + well2wellVer(1, 1);', i, i-8));
%         eval(sprintf('C2_Chamb%d_Y_um = C2_Chamb%d_Y_um + well2wellVer(1, 2);', i, i-8));
% 
%     else
% 
%         eval(sprintf('C2_Chamb%d_X_um = C2_Chamb%d_X_um + well2wellHor(1, 1);', i, i-1));
%         eval(sprintf('C2_Chamb%d_Y_um = C2_Chamb%d_Y_um + well2wellHor(1, 2);', i, i-1));
% 
%     end
% 
% end

if strcmp(FluorMode, 'PE')
    
    Ch2_Colormap(:, 3) = 0; % FITC : add 'Ch2_Colormap(:, 1)'.
    
elseif strcmp(FluorMode, 'FITC')
    
    Ch2_Colormap(:, 3) = 0;
    Ch2_Colormap(:, 1) = 0;
    
end

try

    Z_default_um = refZ;
    
catch
    
    if lensMag == 4

        Z_default_um = 8600;

    elseif lensMag == 10

        Z_default_um = 1000;

    else

        Z_default_um = 900;

    end
    
    refZ = Z_default_um;
    
end
