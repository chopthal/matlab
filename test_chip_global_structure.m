clear all

pixel2um = 250/774;
chipNum = 3;
chipName = {'96 Half Well Cell Culture Plate (SPL)';
    'Droplet Counting Chip (Smaller)';
    'Droplet Counting Chip (Bigger)'};
chipType = {'WellPlate';
    'Droplet';
    'Droplet'};
chamberNum = {[8 12]; % 96 well plate
    [1 1];
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
    11170.2219815918 14446.7509812473;
    14648.4028153763 14446.7509812473;
    11180.3595018950 16000.9012937927;
    14658.2652950731 16000.3994766681    
    ];
defaultCoor{3, 1} = [...
    11170.2219815918 14446.7509812473;
    14648.4028153763 14446.7509812473;
    11180.3595018950 20000.9012937927;
    14658.2652950731 20000.3994766681    
    ];

% Unit : pixel
chipROI = {[360 0 1200 1200]; % [X-offset, Y-offset, Width, Height]
    [0 0 1920 1200];
    [0 0 1920 1200]};    

observeRate = 1.1; 
overlabRate = [0.1, 0.1]; % horizontal, vertical

ChipInform = struct;

for i = 1:chipNum
    
    chipInformStruct = struct;    
    chipInformStruct = CalculateChamberCoordinate(...
        chipType{i, 1}, chipName{i, 1}, defaultCoor{i, 1}, chipROI{i, 1},...
         chamberNum{i, 1}, pixel2um, observeRate, overlabRate);
    
    structField = fieldnames(chipInformStruct);
    
    for ii = 1:size(structField, 1)
        ChipInform(i).(structField{ii, 1}) = chipInformStruct.(structField{ii, 1});
    end
    
end

function chipInformStruct = ...
    CalculateChamberCoordinate(chipType, chipName, defaultCoor,...
    chipROI, chamberNum, pixel2um, observeRate, overlabRate)
% chipType : WellPlate, Droplet

    chipInformStruct.Name = chipName;
    chipInformStruct.ChamberNum = chamberNum;    
    chipInformStruct.ROI = chipROI;
    chipInformStruct.Type = chipType;
    chipInformStruct.DefaultCoordinate = zeros(16, 2);
    chipInformStruct.DefaultCoordinate(1:size(defaultCoor, 1), 1:size(defaultCoor, 2)) = defaultCoor;   

    if strcmp(chipType, 'WellPlate') % left, right, top, bottom

        wellDiameter = zeros(8, 1);

        for i = 1:8            
            distMatrix = squareform(pdist(chipInformStruct.DefaultCoordinate));
            wellDiameter(i, 1) = distMatrix(2*i, 2*i-1);
        end
        wellDiameterAvg = mean(wellDiameter, 'all');
        chamberArea = ones(1, 2) * wellDiameterAvg*cos(deg2rad(45));

    else strcmp(chipType, 'Droplet') % left-top, right-top, left-bottom, right-bottom

        tmp = zeros(8, 1);
        tmp2 = zeros(8, 1);

        for i=1:4

            tmp(2*i-1, 1) = chipInformStruct.DefaultCoordinate(4*i-2, 1)...
                - chipInformStruct.DefaultCoordinate(4*i-3, 1);            
            tmp(2*i, 1) = chipInformStruct.DefaultCoordinate(4*i, 1)...
                - chipInformStruct.DefaultCoordinate(4*i-1, 1);            
            tmp2(2*i-1, 1) = chipInformStruct.DefaultCoordinate(4*i-1, 2)...
                - chipInformStruct.DefaultCoordinate(4*i-3, 2);
            tmp2(2*i, 1) = chipInformStruct.DefaultCoordinate(4*i, 2)...
                - chipInformStruct.DefaultCoordinate(4*i-2, 2);

        end         
        
        chamberArea = [sum(tmp(tmp~=0))/sum(tmp~=0), sum(tmp2(tmp2~=0))/sum(tmp2~=0)];

    end

    [chipInformStruct.FrameNum, chipInformStruct.ChamberRange] = ... 
        GetCaptureRange(chipInformStruct.ROI, pixel2um, chamberArea,...
        observeRate, overlabRate, chipInformStruct.ChamberNum,...
        chipInformStruct.DefaultCoordinate);
   
    
end
    
% chipName{chipNum+1, 1} = 'Manual';
% set(app.popupmenu_chip, 'Items', chipName);