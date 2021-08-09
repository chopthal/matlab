function [frameNumber, chamberRange] =...
    GetCaptureRange(camROI, pixel2um, chamberArea, observeRate,...
    overlabRate, chamberNum, measuredCoordinate)

frameSizeUm = [camROI(3), camROI(4)] * pixel2um;                
observeArea = frameSizeUm; % width, height
frameNumber = [0 0]; % horizontal, vertical

while observeArea(1) <= chamberArea(1)*sqrt(observeRate)

    observeArea(1) = observeArea(1) + frameSizeUm(1)*(1-overlabRate(1));
    frameNumber(1) = frameNumber(1)+1;
    
end

while observeArea(2) <= chamberArea(2)*sqrt(observeRate)
    
    observeArea(2) = observeArea(2) + frameSizeUm(2)*(1-overlabRate(2));
    frameNumber(2) = frameNumber(2)+1;
    
end

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

if node2 == 0
    chamberGapHor = [0 0]; % [X, Y]
elseif node4 == 0
    chamberGapHor = node2-node1;
else        
    chamberGapHor = (node2 - node1 + node4 - node3) /...
        (chamberNum(1, 1) - 1) / 2;
end

if node3 == 0
    chamberGapVer = [0 0];
elseif node4 == 0
    chamberGapVer = node3-node1;
else
    chamberGapVer = (node3 - node1 + node4 - node2) /...
        (chamberNum(1, 2) - 1) / 2;
end

% TODO : find node1 center coordinat
nodeCoorSum = [];
for i = 0:3
    nodeCoorSum(end+1, :) = sum(measuredCoordinate(i*4+1:i*4+4, :), 1);
end

chamberCenter = [sum(nodeCoorSum(:, 1), 'all') / sum(nodeCoorSum(:, 1)~=0, 'all'),...
    sum(nodeCoorSum(:, 2), 'all') / sum(nodeCoorSum(:, 2)~=0, 'all')];

for i = 1:chamberNum(1)*chamberNum(2)

    if i == 1

        chamberRange{i, 1} =...
            [chamberCenter(1) - observeArea(1)/2, chamberCenter(1) + observeArea(1)/2];
        chamberRange{i, 2} =...
            [chamberCenter(2) - observeArea(2)/2, chamberCenter(2) + observeArea(2)/2];

    elseif mod(i-1, chamberNum(2)) == 0 % Vertical

        chamberRange{i, 1} = chamberRange{i-chamberNum(1), 1} + chamberGapVer(1); % X
        chamberRange{i, 2} = chamberRange{i-chamberNum(1), 2} + chamberGapVer(2); % Y

    else % Horizontal

        chamberRange{i, 1} = chamberRange{i-1, 1} + chamberGapHor(1); % X
        chamberRange{i, 2} = chamberRange{i-1, 2} + chamberGapHor(2); % Y

    end

end