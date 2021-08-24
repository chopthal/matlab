function [frameNumber, chamberRange] =...
    GetCaptureRange(camROI, pixel2um, chamberArea, observeRate,...
    overlabRate, chamberNum, measuredCoordinate, chipType)

frameSizeUm = [camROI(3), camROI(4)] * pixel2um;                
tmpObsArea = chamberArea .* (ones(1, 2) * sqrt(observeRate));
% frameNumber  = round(tmpObsArea ./ frameSizeUm) + 1;
unitNumber = round((tmpObsArea - frameSizeUm .* overlabRate) ./ (frameSizeUm .* (1-overlabRate)));
frameNumber = unitNumber + 1;
% observeArea = (frameNumber-1) .* frameSizeUm;
observeArea = frameSizeUm .* unitNumber - frameSizeUm .* overlabRate .* (unitNumber-1);
chamberRange = cell(chamberNum(1)*chamberNum(2), 2); % {X, Y}

node1 = [0 0];
node2 = [0 0];
node3 = [0 0];
node4 = [0 0];

for i=1:4
    
    node1 = node1 + [measuredCoordinate(i, 1), measuredCoordinate(i, 2)];        
    node2 = node2 + [measuredCoordinate(i+4, 1), measuredCoordinate(i+4, 2)];
    node3 = node3 + [measuredCoordinate(i+8, 1), measuredCoordinate(i+8, 2)];
    node4 = node4 + [measuredCoordinate(i+12, 1), measuredCoordinate(i+12, 2)];

end

% Center of each node.
node1 = node1/4;
node2 = node2/4;
node3 = node3/4;
node4 = node4/4;

if strcmp(chipType, 'WellPlate') % 4 nodes & rect position (vertical, horizontal)
    
    chamberGapHor = (node2 - node1 + node4 - node3) /...
        (chamberNum(1, 1) - 1) / 2;
    chamberGapVer = (node3 - node1 + node4 - node2) /...
        (chamberNum(1, 2) - 1) / 2;
    
elseif strcmp(chipType, 'Droplet') % 1~4 nodes & vertical only position (nodeNum = chamberNum)
    
    chamberGapHor = [0 0];
    
    if node2 == 0
        chamberGapVer = [0 0];
    elseif node3 == 0        
        chamberGapVer = node2 - node1;
    elseif node4 == 0        
        chamberGapVer = (node2 - node1 + node3 - node2) / 2;
    else        
        chamberGapVer = (node2 - node1 + node4 - node3) / 2;
    end
    
end

chamberCenter = node1;

for i = 1:chamberNum(1)*chamberNum(2)

    if i == 1
        
        if frameNumber(1) == 1
            
            observeArea(1) = 0;
            
        end
        
        if frameNumber(2) == 1
            
            observeArea(2) = 0;
            
        end

        chamberRange{i, 1} =...
            [chamberCenter(1) - observeArea(1)/2, chamberCenter(1) + observeArea(1)/2];
        chamberRange{i, 2} =...
            [chamberCenter(2) - observeArea(2)/2, chamberCenter(2) + observeArea(2)/2];

    elseif mod(i-1, chamberNum(1)) == 0 % Vertical

        chamberRange{i, 1} = chamberRange{i-chamberNum(1), 1} + chamberGapVer(1); % X
        chamberRange{i, 2} = chamberRange{i-chamberNum(1), 2} + chamberGapVer(2); % Y

    else % Horizontal

        chamberRange{i, 1} = chamberRange{i-1, 1} + chamberGapHor(1); % X
        chamberRange{i, 2} = chamberRange{i-1, 2} + chamberGapHor(2); % Y

    end

end
