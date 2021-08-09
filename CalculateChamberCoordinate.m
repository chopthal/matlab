function chipInformStruct = ...
    CalculateChamberCoordinate(chipType, chipName, defaultCoor, measuredCoor,...
    chipROI, chamberNum, pixel2um, observeRate, overlabRate)

    if ~isempty(defaultCoor)        
        chipInformStruct.DefaultCoordinate = zeros(16, 2);
        chipInformStruct.DefaultCoordinate(1:size(defaultCoor, 1), 1:size(defaultCoor, 2)) = defaultCoor;   
    end    

% chipType : WellPlate, Droplet
    chipInformStruct.Name = chipName;
    chipInformStruct.ChamberNum = chamberNum;    
    chipInformStruct.ROI = chipROI;
    chipInformStruct.Type = chipType;
    chipInformStruct.ObserveRate = observeRate;
    chipInformStruct.OverlabRate = overlabRate;
%     chipInformStruct.DefaultCoordinate = zeros(16, 2);
    chipInformStruct.MeasuredCoordinate = zeros(16, 2);
%     chipInformStruct.DefaultCoordinate(1:size(defaultCoor, 1), 1:size(defaultCoor, 2)) = defaultCoor;   
    chipInformStruct.MeasuredCoordinate(1:size(measuredCoor, 1), 1:size(measuredCoor, 2)) = measuredCoor;   

    if strcmp(chipType, 'WellPlate') % left, right, top, bottom

        wellDiameter = zeros(8, 1);

        for i = 1:8
            distMatrix = squareform(pdist(chipInformStruct.MeasuredCoordinate));
            wellDiameter(i, 1) = distMatrix(2*i, 2*i-1);
        end
        wellDiameterAvg = mean(wellDiameter, 'all');
        chamberArea = ones(1, 2) * wellDiameterAvg*cos(deg2rad(45));
        
    elseif strcmp(chipType, 'Droplet') % left-top, right-top, left-bottom, right-bottom

        tmp = zeros(8, 1);
        tmp2 = zeros(8, 1);

        for i=1:4

            tmp(2*i-1, 1) = chipInformStruct.MeasuredCoordinate(4*i-2, 1)...
                - chipInformStruct.MeasuredCoordinate(4*i-3, 1);            
            tmp(2*i, 1) = chipInformStruct.MeasuredCoordinate(4*i, 1)...
                - chipInformStruct.MeasuredCoordinate(4*i-1, 1);            
            tmp2(2*i-1, 1) = chipInformStruct.MeasuredCoordinate(4*i-1, 2)...
                - chipInformStruct.MeasuredCoordinate(4*i-3, 2);
            tmp2(2*i, 1) = chipInformStruct.MeasuredCoordinate(4*i, 2)...
                - chipInformStruct.MeasuredCoordinate(4*i-2, 2);

        end         
        
        chamberArea = [sum(tmp(tmp~=0))/sum(tmp~=0), sum(tmp2(tmp2~=0))/sum(tmp2~=0)];

    end

    [chipInformStruct.FrameNum, chipInformStruct.ChamberRange] = ... 
        GetCaptureRange(chipInformStruct.ROI, pixel2um, chamberArea,...
        observeRate, overlabRate, chipInformStruct.ChamberNum,...
        chipInformStruct.MeasuredCoordinate);
   
    
end