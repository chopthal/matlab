% 2020. 11. 04

% iMeasy_Multi_v1.0.0 -> iMeasy_Multi_v1.0.3

% Num->Rep / Rep->Num error fixed.

function [unkList, listColor, listType, listRepNo, listCon, listPos, stdNum, unkNum, listUnit, listInt]...
    = MakeUnkList(app, unkNum)

if isempty(unkNum)
    
    startNum = 1;
    
else
    
    startNum = max(unkNum) + 1;
    
end

numUnk = round(get(app.edit3, 'Value'));
numRep = round(get(app.edit4, 'Value'));
selColor = get(app.pushbutton4, 'BackgroundColor');

tmpCon         = cell(numUnk, numRep);
nameStr        = cell(numUnk, numRep);
tmpRepNo       = cell(numUnk, numRep);
tmpType        = cell(numUnk, numRep);
tmpColor       = cell(numUnk, numRep);
tmpUnkNum      = zeros(numUnk, numRep);
tmpStdNum      = zeros(numUnk, numRep);
listUnit       = cell(numUnk * numRep, 1); 
listUnit(:, :) = {'-'};

for i = 1:numUnk
    
    for ii = 1:numRep
        
        nameStr{i, ii} = sprintf('U%d(%d)', i+startNum-1, ii);
        tmpRepNo{i, ii} = num2str(ii);
        tmpType(i, ii) = {'Unknown'};
        tmpColor(i, ii) = {selColor};
        tmpCon{i, ii} = '';        
        tmpStdNum(i, ii) = 0;
        tmpUnkNum(i, ii) = i + startNum - 1;
        
    end
    
end

% if strcmp(app.popupmenu3.Value(1), 'R')
if strcmp(app.popupmenu3.Value(1), 'N')
    
    
    unkList   = nameStr(:, 1);
    listCon   = tmpCon(:, 1);
    listRepNo = tmpRepNo(:, 1);
    listType  = tmpType(:, 1);
    listColor = tmpColor(:, 1);
    stdNum    = tmpStdNum(:, 1);
    unkNum    = tmpUnkNum(:, 1);
    
    
    for i = 2:size(nameStr, 2)
        
        unkList   = [unkList;   nameStr(:, i)];
        listCon   = [listCon;   tmpCon(:, i)];
        listRepNo = [listRepNo; tmpRepNo(:, i)];
        listType  = [listType;  tmpType(:, i)];
        listColor = [listColor; tmpColor(:, i)];       
        stdNum    = [stdNum;    tmpStdNum(:, i)];
        unkNum    = [unkNum;    tmpUnkNum(:, i)];
        
    end
    
else
    
    unkList   = nameStr(1, :);
    listCon   = tmpCon(1, :);
    listRepNo = tmpRepNo(1, :);
    listType  = tmpType(1, :);
    listColor = tmpColor(1, :);
    stdNum    = tmpStdNum(1, :);
    unkNum    = tmpUnkNum(1, :);
    
    for i = 2:size(nameStr, 1)
        
        unkList   = [unkList   nameStr(i, :)];
        listCon   = [listCon   tmpCon(i, :)];
        listRepNo = [listRepNo tmpRepNo(i, :)];
        listType  = [listType  tmpType(i, :)];
        listColor = [listColor tmpColor(i, :)];
        stdNum    = [stdNum    tmpStdNum(i, :)];
        unkNum    = [unkNum    tmpUnkNum(i, :)];
        
    end
    
    unkList   = unkList';
    listCon   = listCon';
    listRepNo = listRepNo';
    listType  = listType';
    listColor = listColor';
    stdNum    = stdNum';
    unkNum    = unkNum';
    
end

listPos = cell(size(unkList, 1), 1);
listPos(:, :) = {''};
listInt = cell(size(unkList, 1), 1);
listInt(:, :) = {''};