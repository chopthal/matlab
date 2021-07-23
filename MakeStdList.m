% 2020. 12. 09

% iMeasy_Multi_v1.0.3 -> iMeasy_Multi_v1.0.7

% fix round Concentration digit numbers.

function [stdList, listColor, listType, listRepNo, listCon, listPos, stdNum, unkNum, listUnit, listInt]...
    = MakeStdList(app, stdNum)

if isempty(stdNum)
   
    startNum = 1;
    
else

    startNum = max(stdNum) + 1;
    
end

startCon = round(get(app.edit1, 'Value') * 100) / 100;
numCon   = round(get(app.edit3, 'Value'));
dilFac   = 1/round(get(app.edit2, 'Value'));
numRep   = round(get(app.edit4, 'Value'));
chkZero  = get(app.checkbox1, 'Value');
selColor = get(app.pushbutton4, 'BackgroundColor');
selUnit  = get(app.popupmenu2, 'Value');

tmpCon         = cell(numCon + chkZero, numRep);
nameStr        = cell(numCon + chkZero, numRep);
tmpRepNo       = cell(numCon + chkZero, numRep);
tmpType        = cell(numCon + chkZero, numRep);
tmpColor       = cell(numCon + chkZero, numRep);
tmpUnkNum      = zeros(numCon + chkZero, numRep);
tmpStdNum      = zeros(numCon + chkZero, numRep);
listUnit       = cell((numCon + chkZero) * numRep, 1); 
listUnit(:, :) = {selUnit};

for i = 1:size(tmpCon, 1)
    
    for ii = 1:numRep    
        
        nameStr{i, ii} = sprintf('S%d(%d)', i+startNum-1, ii);
        tmpRepNo{i, ii} = num2str(ii);
        tmpType(i, ii) = {'Standard'};
        tmpColor(i, ii) = {selColor};
        tmpStdNum(i, ii) = i + startNum - 1;
        tmpUnkNum(i, ii) = 0;        
        
        if i <= numCon
        
%             tmpCon{i, ii} = num2str(round(startCon * dilFac^(i-1) * 100)/100);
            tmpCon{i, ii} = num2str(startCon * dilFac^(i-1));
            
        else
            
            tmpCon{i, ii} = '0';
        
        end
        
    end
    
end

if strcmp(app.popupmenu3.Value(1), 'N')

    stdList   = nameStr(:, 1);
    listCon   = tmpCon(:, 1);
    listRepNo = tmpRepNo(:, 1);
    listType  = tmpType(:, 1);
    listColor = tmpColor(:, 1);
    stdNum    = tmpStdNum(:, 1);
    unkNum    = tmpUnkNum(:, 1);
    
    for i = 2:size(nameStr, 2)
        
        stdList   = [stdList; nameStr(:, i)];
        listCon   = [listCon; tmpCon(:, i)];
        listRepNo = [listRepNo; tmpRepNo(:, i)];
        listType  = [listType; tmpType(:, i)];
        listColor = [listColor; tmpColor(:, i)];    
        stdNum    = [stdNum;    tmpStdNum(:, i)];
        unkNum    = [unkNum;    tmpUnkNum(:, i)];
        
    end
    
else

    stdList   = nameStr(1, :);
    listCon   = tmpCon(1, :);
    listRepNo = tmpRepNo(1, :);
    listType  = tmpType(1, :);
    listColor = tmpColor(1, :);
    stdNum    = tmpStdNum(1, :);
    unkNum    = tmpUnkNum(1, :);
    
    for i = 2:size(nameStr, 1)
        
        stdList   = [stdList nameStr(i, :)];
        listCon   = [listCon tmpCon(i, :)];
        listRepNo = [listRepNo tmpRepNo(i, :)];
        listType  = [listType tmpType(i, :)];
        listColor = [listColor tmpColor(i, :)];
        stdNum    = [stdNum    tmpStdNum(i, :)];
        unkNum    = [unkNum    tmpUnkNum(i, :)];
        
    end
    
    stdList = stdList';
    listCon = listCon';
    listRepNo = listRepNo';
    listType = listType';
    listColor = listColor';
    stdNum    = stdNum';
    unkNum    = unkNum';
    
end

listPos = cell(size(stdList, 1), 1);
listPos(:, :) = {''};
listInt = cell(size(stdList, 1), 1);
listInt(:, :) = {''};