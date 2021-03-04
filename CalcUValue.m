function uValRes = CalcUValue(rawData, fitCurve, fitProp, resultMat, RASOrg)

% Rmax, Kon, Koff
% P1^ = (1+-0.01*U) * P1;

% Rmax

paraStr = {'Rmax', 'Kon', 'Koff'};
uValDiff = 0.0001;
RASCutOff = 0.5; % percent
RASDiff = 0;
uValRes.Rmax = 0;
uValRes.Kon = 0;
uValRes.Koff = 0;

% iterNo = 1;

for ii = 1:3
    
    uVal.Rmax = 0;
    uVal.Kon = 0;
    uVal.Koff = 0;
    
    RAS = 0;
    RASDiff = 0;
    
    iterNo = 1;

    while RASDiff <= RASCutOff && iterNo <= 10000

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
                .* rawData(i).Association.X));

            fitCurve(i).ResiDisso = abs(fitCurve(i).fitDissoY - rawData(i).Dissociation.Y);
            fitCurve(i).ResiAsso = abs(fitCurve(i).fitAssoY - rawData(i).Association.Y);
            
            fitCurve(i).ResAbsSum = sum(fitCurve(i).ResiDisso, 'all')...
                + sum(fitCurve(i).ResiAsso, 'all');

            RAS = RAS + fitCurve(i).ResAbsSum;
            
        end
        
        RASDiff = abs(RAS - RASOrg) / RASOrg * 100;

        iterNo = iterNo + 1;
        uVal.(paraStr{ii}) = uVal.(paraStr{ii}) + uValDiff;
        fprintf('RAS diff = %d\n', RASDiff)
        
    end
    
    uValRes.(paraStr{ii}) = uVal.(paraStr{ii}) - uValDiff;
    fprintf('Iteration No = %d\n', iterNo-1)
    
end

% disp(RASDiff)
disp(uValRes)

