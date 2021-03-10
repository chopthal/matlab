function uValRes = CalcUValue(rawData, fitCurve, fitProp, resultMat, RASOrg)

% Rmax, Kon, Koff
% P1^ = (1+-0.01*U) * P1;

% Rmax
paraStr = {'Rmax', 'Kon', 'Koff'};
uValDiff = 0.0001;
RASCutOff = 0.5; % percent?
uValRes.Rmax = 0;
uValRes.Kon = 0;
uValRes.Koff = 0;

RAS = zeros(size(fitCurve, 2), 1);
RASDiff = zeros(size(fitCurve, 2), size(fieldnames(uValRes), 1));

iterNo = zeros(size(fieldnames(uValRes), 1), 1);

for ii = 1:size(fieldnames(uValRes), 1)
    
    uVal.Rmax = 0;
    uVal.Kon = 0;
    uVal.Koff = 0;       

    while min(RASDiff(:, ii)) <= RASCutOff && iterNo(ii, 1) <= 10000000 % min? max?
        
        iterNo(ii, 1) = iterNo(ii, 1) + 1;
        uVal.(paraStr{ii}) = uVal.(paraStr{ii}) + uValDiff;

        for i = 1:size(fitCurve, 2)

            % Disso fitted data
            fitCurve(i).fitDissoY = fitProp(i).R0Init...
                * exp(-(1 + 0.01 * uVal.Koff) * resultMat(i, 3)...
                * rawData(i).Dissociation.X);

            % Asso fitted data
            fitCurve(i).fitAssoY = (1 + 0.01*uVal.Rmax)*resultMat(i, 1)...
                * rawData(i).Concentration...
                / (resultMat(i, 5) + rawData(i).Concentration)...
                * (1 - exp(-((1 + 0.01 * uVal.Kon) * resultMat(i, 2) * rawData(i).Concentration...
                + (1 + 0.01 * uVal.Koff) * resultMat(i, 3))...
                * rawData(i).Association.X));

%             fitCurve(i).ResiDisso = abs(fitCurve(i).fitDissoY - rawData(i).Dissociation.Y);
%             fitCurve(i).ResiAsso = abs(fitCurve(i).fitAssoY - rawData(i).Association.Y);
            fitCurve(i).ResiDisso = fitCurve(i).fitDissoY - rawData(i).Dissociation.Y;
            fitCurve(i).ResiAsso = fitCurve(i).fitAssoY - rawData(i).Association.Y; % abs or not?
            
            fitCurve(i).ResAbsSum = sum(fitCurve(i).ResiDisso, 'all')...
                + sum(fitCurve(i).ResiAsso, 'all');

            RAS(i, 1) = fitCurve(i).ResAbsSum;
            
        end
        
        RASDiff(:, ii) = abs((RAS - RASOrg) ./ RASOrg) * 100; % ii : variables, i : curves
%         RASDiff(:, ii) = abs((RAS - RASOrg) ./ RASOrg); % *100 or not?
        
    end
    
    uValRes.(paraStr{ii}) = uVal.(paraStr{ii}) - uValDiff;
    
end

fprintf('Iteration No = %d\n', iterNo)