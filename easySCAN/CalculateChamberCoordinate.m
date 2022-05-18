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
    chipInformStruct.MeasuredCoordinate = zeros(16, 2);
    chipInformStruct.MeasuredCoordinate(1:size(measuredCoor, 1), 1:size(measuredCoor, 2)) = measuredCoor;   
    chamberArea = CalculateChamberArea(chipType, chipInformStruct.MeasuredCoordinate);
    [chipInformStruct.FrameNum, chipInformStruct.ChamberRange] = ... 
        GetCaptureRange(chipInformStruct.ROI, pixel2um, chamberArea,...
        observeRate, overlabRate, chipInformStruct.ChamberNum,...
        chipInformStruct.MeasuredCoordinate, chipInformStruct.Type);   
    
end