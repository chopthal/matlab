conc1 = [0 0.02 0.04 0.08 0.16 0.32] * 10^(-9);
conc2 = [0 2 4 8 16 32] * 10^(-12);
conc3 = [124 12812 9393333 0.1123 0.0000001] * 10^(-3);
conc4 = [0 0.001 0.01 0.1 1 10 100] * 10^(-7);

[concStr, unit] = FindConcentrationUnit(conc3);

function [concStr, unit] = FindConcentrationUnit(concentration)
    logConc = log10(concentration);
    digitConc = round(round(min(logConc(~isinf(logConc))))/3) * 3;

    % Giga ~ ato    
    unitNames = {'GM', 'MM', 'KM', 'M', 'mM', 'uM', 'nM', 'pM', 'fM', 'aM'};
    unitDigitCriteria = [9 6 3 0 -3 -6 -9 -12 -15 -18];    
    [~, idx] = min(abs(digitConc - unitDigitCriteria));
    unitDigit = unitDigitCriteria(idx);        
    unit = (unitNames{idx});
    concNum = concentration / 10^unitDigit;
    concStr = cell(size(concNum, 2), 1);
    
    for i = 1:size(concNum, 2)
        concStr{i, 1} = sprintf('%0.2f', concNum(1, i));
    end
end



