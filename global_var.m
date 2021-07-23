% 2021. 04. 27

% easySCAN_v1.1.3 -> easySCAN_v1.1.4

% Disable AFIntervalDefault

function global_var(app)

global MAIN_app DeviceName CamName MainPortNo...
    PortNoFile ChPropFile StgStepFile cap_folder Run_flag AF_flag...
    menu_id_list menu_ANALYSIS_opened Chamber_Setting_opened...
    NoofChannel cur_Channel ChPropList StageList...
    max_step Z_default_um...
    im_W_um im_H_um frame_W_um frame_H_um tog_in_color tog_out_color...
    NoofChip cur_Chip cur_Chamb Z_L_um C1_Chamb_W_um C1_Chamb_H_um posFlag...
    posCanvas_LandimNo posCanvas_PortimNo ROIPosition logo_img MovDiff_um...
    FluorMode FluorModeFile CoorCorrFile well_center_X_default...
    well_center_Y_default rect_width_half_default well2wellHor_default...
    well2wellVer_default defaultCoor lensMag lensMagDefault im_W_um_default...
    im_H_um_default C_folder scanCh noFrameDefault chName AFPropFile...
    AFRangeDefault AFRange AFInterval noFrame defaultRefZ Reset_flag...
    refZ Stop_flag StageFlag LogPath CaptureFlag

CaptureFlag = 0;
StageFlag = 0;
Stop_flag = 0;
noFrameDefault = 3;

lensMagDefault = 20;
lensMag = 20;

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

for i = 1:length(ChPropList)
    
    ChPropList_i = ChPropList{i};
    
    eval(sprintf('global %sRange;', ChPropList_i));
    
end

ExpRange = [50, 2000]; % ms
GammaRange = [1, 4];

GainRange = [0, 24]; % 200121 Test New Camera
IntenRange = [0, 255];

for i = 1:length(ChPropList)
    
    ChPropList_i = ChPropList{i};    
    
    eval(sprintf('default_%s = round(mean(%sRange));',ChPropList_i, ChPropList_i));     
   
    for j = 1:NoofChannel   
        
        eval(sprintf('global Ch%d_%s;', j, ChPropList_i));
        
        eval(sprintf('Ch%d_%s = default_%s;',j, ChPropList_i, ChPropList_i));               
        
    end

end

for i = 1:NoofChannel
    
    eval(sprintf('global Ch%d_Colormap;', i));
    eval(sprintf('global Ch%d_SavedFieldName;', i));    
    
end

Ch1_Colormap = linspace(0, 1, 256)';
Ch1_Colormap(:, 2) = linspace(0, 1, 256)';
Ch1_Colormap(:, 3) = linspace(0, 1, 256)';
Ch1_SavedFieldName = 'BM';

Ch2_Colormap = Ch1_Colormap;
Ch2_SavedFieldName = 'FM';

StageList = {'X', 'Y', 'Z'};

for i = 1:length(StageList)
    
    Stage = StageList{i};
    
    eval(sprintf('global max_step_%s;', Stage));
    
    eval(sprintf('max_step_%s = [];', Stage));
    
    
end

max_step = 999999;
MovDiff_um = 0;
% Z_L_um = 32000; % for 4X % Photo sensor hole to hole = 4000
% Z_L_um = 16000; % for 4X % Photo sensor hole to hole = 4000

PSHoleUp = 2;
PSHoleDn = 1;
PSHole2Hole = 4000;

PSUp2Up = 120000;
% PSGuideLen = 91000;
PSGuideLen = 89000;
PS2Hole = 6500;

Z_L_um = PSUp2Up - PSHole2Hole*(PSHoleUp-1) + PSHole2Hole*(PSHoleDn-1) - PS2Hole*2 - PSGuideLen;

ROIPosition = [360 0 1200 1200]; % Offset X, Y, Width, Height
pix2um = 250/774 * 1.2; % 20x lens

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

tog_out_color = [0.38,0.82,1.00];
tog_in_color = [0.20,0.57,0.88]; 

NoofChip = 1;
cur_Chip = 0;
cur_Chamb = 1;

for i = 1:NoofChip
    
    eval(sprintf('global C%d_NoofChamb;', i));
    
end

C1_name = '96 Half Well Cell Culture Plate (SPL)';
C1_NoofChamb = 96;

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

% Product Serial No : 003 2009 002
defaultCoor = [...
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
                    
    wellCent1  = wellCent1  + [defaultCoor(i, 1), defaultCoor(i, 2)];
    wellCent8  = wellCent8  + [defaultCoor(i+4, 1), defaultCoor(i+4, 2)];
    wellCent89 = wellCent89 + [defaultCoor(i+8, 1), defaultCoor(i+8, 2)];
    wellCent96 = wellCent96 + [defaultCoor(i+12, 1), defaultCoor(i+12, 2)];

end

wellCent1  = wellCent1 / 4;
wellCent8  = wellCent8 / 4;
wellCent89 = wellCent89 / 4;
wellCent96 = wellCent96 / 4;

well_center_X_default = wellCent1(1, 1);
well_center_Y_default = wellCent1(1, 2);
rect_width_half_default = ((noFrameDefault - 1) / 2 + 0.01) * im_W_um_default;

well2wellHor_default = (wellCent8 - wellCent1 + wellCent96 - wellCent89) / 2 / 7;
well2wellVer_default = (wellCent89 - wellCent1 + wellCent96 - wellCent8) / 2 / 11;

if exist(C_folder, 'dir')~=7
        
    mkdir(C_folder);
    
end
    
if exist(PortNoFile, 'file')==2

    load(PortNoFile);   

end

if exist(ChPropFile, 'file')==2

    load(ChPropFile);         

    for i = 1:length(ChPropList)

        ChPropList_i = ChPropList{i};    

        for j = 1:NoofChannel

            eval(sprintf('Ch_Prop = Ch%d_%s;', j, ChPropList_i));
            eval(sprintf('PropRange = %sRange;', ChPropList_i));

            if isnan(Ch_Prop)||(Ch_Prop<PropRange(1))||(PropRange(2)<Ch_Prop)

                eval(sprintf('Ch%d_%s = default_%s;', j, ChPropList_i, ChPropList_i));

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
    lensMag = lensMagDefault; % 20x
    scanCh = [1 2];
    chName = 'Ch1 & 2';

end

set(app.edit_Z_diff, 'Visible', size(scanCh, 2) == 2)
set(app.DiffLabel, 'Visible', size(scanCh, 2) == 2)
set(app.pushbutton_Set_Mode, 'Visible', size(scanCh, 2) == 2)


if exist(CoorCorrFile, 'file') == 2

    load(CoorCorrFile);

else

    % Default
    well_center_X = well_center_X_default;
    well_center_Y = well_center_Y_default;
    rect_width_half = rect_width_half_default;
    
    well2wellVer = well2wellVer_default;
    well2wellHor = well2wellHor_default;

    noFrame = noFrameDefault;

end

if exist(AFPropFile, 'file') == 2

    load(AFPropFile)

else

    AFRange = AFRangeDefault;
%     AFInterval = AFIntervalDefault;

    if lensMag == 4
    
        defaultRefZ = 18000;

    elseif lensMag == 10

        defaultRefZ = 1000;

    else

%         defaultRefZ = 8500;
        defaultRefZ = 900;

    end
    
    refZ = defaultRefZ;

end

im_W_um = im_W_um_default * lensMagDefault/lensMag;
im_H_um = im_H_um_default * lensMagDefault/lensMag;

if noFrame == 1
    
    rect_width_half = 0;
    
else

    rect_width_half = ((noFrame - 1) / 2 + 0.01) * im_W_um_default;
    
end

rect_width_half_mag = rect_width_half * lensMagDefault/lensMag;

C1_Chamb1_X_um = [well_center_X - rect_width_half_mag, well_center_X + rect_width_half_mag];
C1_Chamb1_Y_um = [well_center_Y - rect_width_half_mag, well_center_Y + rect_width_half_mag];

for i = 2:96
                
    if mod(i-1, 8) == 0
        
        eval(sprintf('C1_Chamb%d_X_um = C1_Chamb%d_X_um + well2wellVer(1, 1);', i, i-8));
        eval(sprintf('C1_Chamb%d_Y_um = C1_Chamb%d_Y_um + well2wellVer(1, 2);', i, i-8));

    else

        eval(sprintf('C1_Chamb%d_X_um = C1_Chamb%d_X_um + well2wellHor(1, 1);', i, i-1));
        eval(sprintf('C1_Chamb%d_Y_um = C1_Chamb%d_Y_um + well2wellHor(1, 2);', i, i-1));

    end

end

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

        Z_default_um = 18000;

    elseif lensMag == 10

        Z_default_um = 1000;

    else

%         Z_default_um = 8500;
        Z_default_um = 900;

    end
    
    refZ = Z_default_um;
    
end
