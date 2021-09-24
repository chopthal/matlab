function f = FitCurve(x)

global rawData fitFunc xVarAsso xVarDisso chi2

for i = 1:size(rawData, 2)
    
    fcnDissoRes = [];
    fcnAssoRes = [];

    rawDataDissoX{i} = rawData(i).Dissociation.X;
    rawDataAssoX{i} = rawData(i).Association.X;
    rawDataDissoY{i} = rawData(i).Dissociation.Y;
    rawDataAssoY{i} = rawData(i).Association.Y;
    rawDataConcen{i} = rawData(i).Concentration;
    
    % fcn = fit curve - raw curve
    eval(sprintf('fcnDisso{i} = %s;', fitFunc(i).Dissociation));
    eval(sprintf('fcnAsso{i} = %s;', fitFunc(i).Association));
    eval(sprintf('fcnDissoSqSum(i) = sum(fcnDisso{i}(%s).^2);', xVarDisso{i}));
    eval(sprintf('fcnAssoSqSum(i) = sum(fcnAsso{i}(%s).^2);', xVarAsso{i}));
    
    eval(sprintf('fcnDissoRes = fcnDisso{i}(%s);', xVarDisso{i}));
    eval(sprintf('fcnAssoRes = fcnAsso{i}(%s);', xVarAsso{i}));
    
%     rawChi2(i) = fcnDissoSqSum(i) / size(fcnDissoRes, 1);
    rawChi2(i) = fcnDissoSqSum(i) / size(fcnDissoRes, 1) + fcnAssoSqSum(i) / size(fcnAssoRes, 1);
    
end

chi2 = mean(rawChi2, 'all');

% f = sum(fcnDissoSqSum) + sum(fcnAssoSqSum);
f = chi2;