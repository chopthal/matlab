% function [outStruct, grpNum] = DelGrp(inStruct, grpNum, grpListObj)
function [outStruct, grpNum] = DelGrp(inStruct, grpIdx, grpNum, grpListObj)

if isempty(fieldnames(inStruct))
    
%     outStruct = [];
    outStruct = struct;
    return
    
end

if isempty(grpNum)
    
%     outStruct = [];
    outStruct = struct;
    return
    
end

% curVal = get(grpListObj, 'Value');
% grpSel = grpNum(curVal);
grpSel = grpNum(grpIdx);
grpStr = sprintf('Grp%d', grpSel);
% grpStr = sprintf('Grp%d', curVal);
% grpList = get(grpListObj, 'String');
grpList = get(grpListObj, 'Items');

inStruct = rmfield(inStruct, grpStr);
% grpNum(curVal) = [];
% grpList(curVal) = [];

grpNum(grpIdx) = [];
grpList(grpIdx) = [];

% curVal = curVal(1);
lenList = length(grpNum);

if lenList == 0
    
    grpVal = {};
    
%     set(grpListObj, 'Value', [])
%     set(grpListObj, 'Value', {})

% elseif curVal == 1
elseif grpIdx == 1

%     set(grpListObj, 'Value', 1)
    grpVal = sprintf('Group %d', grpNum(1));
%     set(grpListObj, 'Value', grpVal)
    
% elseif curVal >= lenList
elseif grpIdx >= lenList
    
    grpVal = sprintf('Group %d', grpNum(lenList));
    
%     set(grpListObj, 'Value', lenList)
    
else
    
    grpVal = sprintf('Group %d', grpNum(grpIdx));
%     set(grpListObj, 'Value', curVal)
%     set(grpListObj, 'Value', grpVal)
    
end

% set(grpListObj, 'String', grpList)
set(grpListObj, 'Items', grpList)
set(grpListObj, 'Value', grpVal)

outStruct = inStruct;