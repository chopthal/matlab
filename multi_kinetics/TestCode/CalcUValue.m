function uValRes = CalcUValue(rawData, fitCurve, fitProp, resultMat, RSOrg, RASOrg, RSSOrg)

% Rmax, Kon, Koff
% P1^ = (1+-0.01*U) * P1;

% Rmax
paraStr = {'Rmax', 'Kon', 'Koff', 'RmaxKon', 'RmaxKoff', 'KonKoff'};
uValDiff = 0.01;
RSCutOff = 0.5; % percent?

uValRes.Rmax = 0;
uValRes.Kon = 0;
uValRes.Koff = 0;
uValRes.RmaxKon = 0;
uValRes.RmaxKoff = 0;
uValRes.KonKoff = 0;

RS = zeros(size(fitCurve, 2), 1);
RAS = zeros(size(fitCurve, 2), 1);
RSS = zeros(size(fitCurve, 2), 1);
RSDiff = zeros(size(fitCurve, 2), size(fieldnames(uValRes), 1));
RASDiff = zeros(size(fitCurve, 2), size(fieldnames(uValRes), 1));
RSSDiff = zeros(size(fitCurve, 2), size(fieldnames(uValRes), 1));

iterNo = zeros(size(fieldnames(uValRes), 1), 1);

for ii = 1:size(fieldnames(uValRes), 1)
    
    uVal.Rmax = 0;
    uVal.Kon = 0;
    uVal.Koff = 0;    
    uVal.RmaxKon = 0;
    uVal.RmaxKoff = 0;
    uVal.KonKoff = 0;
    
    while min(RSDiff(:, ii)) <= RSCutOff && iterNo(ii, 1) <= 5000 % min? max?
%     while min(RASDiff(:, ii)) <= RSCutOff && iterNo(ii, 1) <= 5000 % min? max?
%     while min(RSSDiff(:, ii)) <= RSCutOff && iterNo(ii, 1) <= 5000 % min? max?
        
        iterNo(ii, 1) = iterNo(ii, 1) + 1;
        uVal.(paraStr{ii}) = uVal.(paraStr{ii}) + uValDiff;        

        for i = 1:size(fitCurve, 2)

            % Disso fitted data
%             fitCurve(i).fitDissoY = fitProp(i).R0Init...
%                 * exp(-(1 + 0.01 * uVal.Koff) * resultMat(i, 3)...
%                 * rawData(i).Dissociation.X);
            fitCurve(i).fitDissoY = fitProp(i).R0Init...
                * exp(-(1 + 0.01 * (uVal.Koff + uVal.RmaxKoff + uVal.KonKoff))...
                * resultMat(i, 3) * rawData(i).Dissociation.X);

            % Asso fitted data
%             fitCurve(i).fitAssoY = (1 + 0.01*uVal.Rmax)*resultMat(i, 1)...
%                 * rawData(i).Concentration...
%                 / (resultMat(i, 5) + rawData(i).Concentration)...
%                 * (1 - exp(-((1 + 0.01 * uVal.Kon) * resultMat(i, 2) * rawData(i).Concentration...
%                 + (1 + 0.01 * uVal.Koff) * resultMat(i, 3))...
%                 * rawData(i).Association.X));            
            fitCurve(i).fitAssoY = (1 + 0.01* (uVal.Rmax + uVal.RmaxKon + uVal.RmaxKoff))*resultMat(i, 1)...
                * rawData(i).Concentration...
                / (resultMat(i, 5) + rawData(i).Concentration)...
                * (1 - exp(-((1 + 0.01 * (uVal.Kon + uVal.RmaxKon + uVal.KonKoff)) * resultMat(i, 2) * rawData(i).Concentration...
                + (1 + 0.01 * (uVal.Koff + uVal.RmaxKoff + uVal.KonKoff)) * resultMat(i, 3))...
                * rawData(i).Association.X));

%             fitCurve(i).ResiDisso = abs(fitCurve(i).fitDissoY - rawData(i).Dissociation.Y);
%             fitCurve(i).ResiAsso = abs(fitCurve(i).fitAssoY - rawData(i).Association.Y);
            fitCurve(i).ResiDisso = fitCurve(i).fitDissoY - rawData(i).Dissociation.Y;
            fitCurve(i).ResiAsso = fitCurve(i).fitAssoY - rawData(i).Association.Y; % abs or not?
            
            fitCurve(i).ResSum = sum(fitCurve(i).ResiDisso, 'all')...
                + sum(fitCurve(i).ResiAsso, 'all');
            fitCurve(i).ResAbsSum = sum(abs(fitCurve(i).ResiDisso), 'all')...
                + sum(abs(fitCurve(i).ResiAsso), 'all');
            fitCurve(i).ResSqrSum = sum(fitCurve(i).ResiDisso.^2, 'all')...
                + sum(fitCurve(i).ResiAsso.^2, 'all');

            RS(i, 1) = fitCurve(i).ResSum;
            RAS(i, 1) = fitCurve(i).ResAbsSum;
            RSS(i, 1) = fitCurve(i).ResSqrSum;
            
        end
        
        RSDiff(:, ii) = abs((RS - RSOrg) ./ RSOrg) * 100; % ii : variables, i : curves
        RASDiff(:, ii) = abs((RAS - RASOrg) ./ RASOrg) * 100; % ii : variables, i : curves
        RSSDiff(:, ii) = abs((RSS - RSSOrg) ./ RSSOrg) * 100; % ii : variables, i : curves
%         RASDiff(:, ii) = abs((RAS - RASOrg) ./ RASOrg); % *100 or not?
        
    end
    
    uValRes.(paraStr{ii}) = uVal.(paraStr{ii}) - uValDiff;
    
end

fprintf('Iteration No = %d\n', iterNo)