function global_var(app)

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

LensMagDefault = 20;

logo_img = imread('logo.png');
posFlag = 0;

CompanyName = 'icluebio';
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

frame_W_um = 86000;
frame_H_um = 128000;

tog_out_color = [0.38,0.82,1.00];
tog_in_color = [0.20,0.57,0.88]; 

chipNum = 3;
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
    11170.2219815918 14446.7509812473; % node 1 left
    14648.4028153763 14446.7509812473; % node 1 right
    12888.3595018950 12600.9012937927; % node 1 up
    12930.2652950731 16188.3994766681; % node 1 down
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
