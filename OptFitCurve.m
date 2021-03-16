function [resultMat, fitCurve] = OptFitCurve(app, fitProp)

global fitFunc rawData xVarAsso xVarDisso chi2

chi2 = 0;

xVarAsso = [];
xVarDisso = [];
fitFunc = struct;
varNum = struct;
varNum.Rmax = 1;
varNum.Koff = 1;
varNum.Kon = 1;
varNum.BI = 1;
initValMat = [];
fitCurve = struct;

for i = 1:size(rawData, 2)
    
    if strcmp(app.RmaxDropDown.Value, 'Constant')
        
        RmaxStr = num2str(fitProp(i).RmaxInit);
        varRmaxStr = 'Rmax1';
        varNum.Rmax = i;
        
    elseif strcmp(app.RmaxDropDown.Value, 'Global')
        
        RmaxStr = 'Rmax1';
        varRmaxStr = RmaxStr;
        
    elseif strcmp(app.RmaxDropDown.Value, 'Local')
        
        RmaxStr = sprintf('Rmax%d', i);
        varRmaxStr = RmaxStr;
        varNum.Rmax = i;
        
    end

    if strcmp(app.KoffDropDown.Value, 'Constant')
        
        KoffStr = num2str(fitProp(i).KoffInit);
        varKoffStr = 'Koff1';
        eval(sprintf('rawDataDissoX{%d} = rawData(%d).Dissociation.X;', i, i));
        eval(sprintf('rawDataDissoY{%d} = rawData(%d).Dissociation.Y;', i, i));
        tmpStr = sprintf(...
            '@(%s) %d * exp(-%d * rawDataDissoX{%d}) - rawDataDissoY{%d}',...
            varKoffStr, fitProp(i).R0Init, fitProp(i).KoffInit, i, i);
        fitFunc(i).Dissociation = tmpStr;
        varNum.Koff = i;

    elseif strcmp(app.KoffDropDown.Value, 'Global')
        
        KoffStr = 'Koff1';
        varKoffStr = KoffStr;
        eval(sprintf('rawDataDissoX{%d} = rawData(%d).Dissociation.X;', i, i));
        eval(sprintf('rawDataDissoY{%d} = rawData(%d).Dissociation.Y;', i, i));
        tmpStr = sprintf(...
            '@(%s) %d * exp(-Koff1 * rawDataDissoX{%d}) - rawDataDissoY{%d}',...
            varKoffStr, fitProp(i).R0Init, i, i);
        fitFunc(i).Dissociation = tmpStr;
   
    elseif strcmp(app.KoffDropDown.Value, 'Local')

        KoffStr = sprintf('Koff%d', i);
        varKoffStr = KoffStr;
        eval(sprintf('rawDataDissoX{%d} = rawData(%d).Dissociation.X;', i, i));
        eval(sprintf('rawDataDissoY{%d} = rawData(%d).Dissociation.Y;', i, i));
        tmpStr = sprintf(...
            '@(Koff%d) %d * exp(-Koff%d * rawDataDissoX{%d}) - rawDataDissoY{%d}',...
            i, fitProp(i).R0Init, i, i, i);
        fitFunc(i).Dissociation = tmpStr;
        varNum.Koff = i;
        
    end
        
    if strcmp(app.KonDropDown.Value, 'Constant')
        
        KonStr = num2str(fitProp(i).KonInit);
        varKonStr = 'Kon1';
        varNum.Kon = i;
        
    elseif strcmp(app.KonDropDown.Value, 'Global')
        
        KonStr = 'Kon1';
        varKonStr = KonStr;
        
    elseif strcmp(app.KonDropDown.Value, 'Local')
        
        KonStr = sprintf('Kon%d', i);
        varKonStr = KonStr;
        varNum.Kon = i;
        
    end
    
    if strcmp(app.BIDropDown.Value, 'Constant')
        
        BIStr = num2str(fitProp(i).BIInit);
        varBIStr = 'BI1';
        varNum.BI = i;
        
    elseif strcmp(app.BIDropDown.Value, 'Global')
        
        BIStr = 'BI1';
        varBIStr = BIStr;
        
    elseif strcmp(app.BIDropDown.Value, 'Local')
        
        BIStr = sprintf('BI%d', i);
        varBIStr = BIStr;
        varNum.BI = i;
        
    end
    
    fitFunc(i).Variables = sprintf('@(%s, %s, %s, %s) ', varRmaxStr, varKoffStr, varKonStr, varBIStr);
    
    eval(sprintf('rawDataAssoX{%d} = rawData(%d).Association.X;', i, i));
    eval(sprintf('rawDataAssoY{%d} = rawData(%d).Association.Y;', i, i));
    eval(sprintf('rawDataConcen{%d} = rawData(%d).Concentration;', i, i));
    
    funStr = strcat(...
        fitFunc(i).Variables,...
        sprintf('%s * rawDataConcen{%d} /', RmaxStr, i),...
        sprintf('(%s/%s + rawDataConcen{%d}) *', KoffStr, KonStr, i),...
        sprintf('(1 - exp(-(%s*rawDataConcen{%d} + %s) *', KonStr, i, KoffStr),...
        sprintf('rawDataAssoX{%d})) + %s - rawDataAssoY{%d}', i, BIStr, i)...
        );
    
    fitFunc(i).Association = funStr;
    disp(fitFunc(i).Association)
    disp(fitFunc(i).Dissociation)
    
    tmpMat = [fitProp(i).RmaxInit fitProp(i).KoffInit fitProp(i).KonInit fitProp(i).BIInit];
    initValMat = [initValMat; tmpMat];
    
end

varNumMat = [varNum.Rmax varNum.Koff varNum.Kon varNum.BI];
nonZeroIdx = varNumMat ~= 1;
varNo = 1:size(varNumMat, 2);
lastNum = size(varNumMat, 2);
varNoAcc = [];

x0 = [fitProp(1).RmaxInit fitProp(1).KoffInit fitProp(1).KonInit fitProp(1).BIInit];
% lb = [fitProp(1).RmaxInit 10^(-5) 10^3 -inf];
lb = [0 10^(-6) 10^3 -inf];
ub = [50000 10^(-1) 10^7 inf];
% ub = [fitProp(1).RmaxInit*2 10^(-1) 10^7 inf];
A = [];
b = [];
Aeq = [];
beq = [];

funcSumStr = '@(x) ';
for i = 1:size(fitFunc, 2)
    
    xVarAsso{i} = sprintf('x(%d), x(%d), x(%d), x(%d)',...
        varNo(1), varNo(2), varNo(3), varNo(4));
    xVarDisso{i} = sprintf('x(%d)', varNo(2));
    
    varNoAcc = [varNoAcc; varNo];
    
    if i ~= size(fitFunc, 2)
    
        for ii = 1:size(varNo, 2)

            if nonZeroIdx(ii) == true                
                
                varNo(ii) = lastNum + 1;
                lastNum = lastNum + 1;
                x0(end+1) = initValMat(i+1, ii); 
                ub(end+1) = ub(1, ii);
                
                if ii == 1
                    
                   lb(end+1) = initValMat(i+1, ii);
                   
                else
                    
                   lb(end+1) = lb(1, ii);
                    
                end

            end

        end
    
    end
    
end

disp(x0)
[x, fval] = fmincon(@FitCurve, x0, A, b, Aeq, beq, lb, ub);
% TODO : constant variable should not be fitted.
% constant variable should be reduced from x

resultMat = nan(size(varNoAcc));
% TODO : constant variable should be replace to constant var (line 225)

for i = 1:size(varNoAcc, 1)
    
    for ii = 1:size(varNoAcc, 2)
        
        if i == 1
            
            resultMat(i, ii) = x(ii);
            
        else
            
            if varNoAcc(i, ii) == varNoAcc(i-1, ii)
                
                resultMat(i, ii) = x(ii);
                
            else
                
                resultMat(i, ii) = x(varNoAcc(i, ii));
                
            end
            
        end
        
    end
    
end

resultMat(:, 1) = [16.59; 28.84; 41.33; 53.08; 67.50];
% but why last var, BI is succesfully get?

% Change Koff, Kon row order
tmpKon = resultMat(:, 3);
tmpKoff = resultMat(:, 2);
resultMat(:, 3) = tmpKoff;
resultMat(:, 2) = tmpKon;

resultMat(:, 5) = resultMat(:, 3) ./ resultMat(:, 2); % KD
resultMat(:, 6) = chi2;

RSOrg = zeros(size(rawData, 2), 1);
RASOrg = zeros(size(rawData, 2), 1);
RSSOrg = zeros(size(rawData, 2), 1);

for i = 1:size(rawData, 2)
    
    % Disso fitted data
    fitCurve(i).fitDissoY = fitProp(i).R0Init...
        * exp(-resultMat(i, 3)...
        * rawData(i).Dissociation.X);

    % Asso fitted data
    fitCurve(i).fitAssoY = resultMat(i, 1) * rawData(i).Concentration...
        / (resultMat(i, 5) + rawData(i).Concentration)...
        * (1 - exp(-(resultMat(i, 2) * rawData(i).Concentration + resultMat(i, 3))...
        .* rawData(i).Association.X));
    
%     fitCurve(i).ResiDisso = abs(fitCurve(i).fitDissoY - rawData(i).Dissociation.Y);
%     fitCurve(i).ResiAsso = abs(fitCurve(i).fitAssoY - rawData(i).Association.Y);
    fitCurve(i).ResiDisso = fitCurve(i).fitDissoY - rawData(i).Dissociation.Y;
    fitCurve(i).ResiAsso = fitCurve(i).fitAssoY - rawData(i).Association.Y;
    fitCurve(i).ResSum = sum(fitCurve(i).ResiDisso, 'all')...
        + sum(fitCurve(i).ResiAsso, 'all');
    fitCurve(i).ResAbsSum = sum(abs(fitCurve(i).ResiDisso), 'all')...
        + sum(abs(fitCurve(i).ResiAsso), 'all');
    fitCurve(i).ResSqrSum = sum(fitCurve(i).ResiDisso.^2, 'all')...
        + sum(fitCurve(i).ResiAsso.^2, 'all');
    
    
    RSOrg(i, 1) = RSOrg(i, 1) + fitCurve(i).ResSum;
    RASOrg(i, 1) = RASOrg(i, 1) + fitCurve(i).ResAbsSum;
    RSSOrg(i, 1) = RASOrg(i, 1) + fitCurve(i).ResAbsSum;
    
end

uVal = CalcUValue(rawData, fitCurve, fitProp, resultMat, RSOrg, RASOrg, RSSOrg);
% uVal = CalcUValue(rawData, fitCurve, fitProp, resultMat, RSOrg);
% uVal = CalcUValue(rawData, fitCurve, fitProp, resultMat, RASOrg);

disp(uVal)
