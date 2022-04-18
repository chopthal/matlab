function chamberArea = CalculateChamberArea(chipType, measuredCoordinate)

if strcmp(chipType, 'WellPlate') % left, right, top, bottom

    idxOddRow = false(size(measuredCoordinate, 1), 1);
    idxOddRow(1:2:end) = true;
    idxEvenRow = ~idxOddRow;    
    oddCoor = measuredCoordinate(idxOddRow, :);
    evenCoor = measuredCoordinate(idxEvenRow, :);    
    wellDiameter = sqrt(sum((evenCoor - oddCoor).^2, 2));

%     wellDiameter = zeros(8, 1);
% 
%     for i = 1:8
%         distMatrix = squareform(pdist(measuredCoordinate));
%         wellDiameter(i, 1) = distMatrix(2*i, 2*i-1);
%     end
    wellDiameterAvg = mean(wellDiameter, 'all');
    chamberArea = ones(1, 2) * wellDiameterAvg*cos(deg2rad(45));

elseif strcmp(chipType, 'Droplet') % left-top, right-top, left-bottom, right-bottom

    tmp = zeros(8, 1);
    tmp2 = zeros(8, 1);

    for i=1:4

        tmp(2*i-1, 1) = measuredCoordinate(4*i-2, 1)...
            - measuredCoordinate(4*i-3, 1);            
        tmp(2*i, 1) = measuredCoordinate(4*i, 1)...
            - measuredCoordinate(4*i-1, 1);            
        tmp2(2*i-1, 1) = measuredCoordinate(4*i-1, 2)...
            - measuredCoordinate(4*i-3, 2);
        tmp2(2*i, 1) = measuredCoordinate(4*i, 2)...
            - measuredCoordinate(4*i-2, 2);

    end         

    chamberArea = [sum(tmp(tmp~=0))/sum(tmp~=0), sum(tmp2(tmp2~=0))/sum(tmp2~=0)];

end