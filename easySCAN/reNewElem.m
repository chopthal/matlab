% 2020.10.21

% iMeasy_Multi_v1.0.0

% function reNewElem(DataStruct, grpNumSel, elemListObj)
function reNewElem(DataStruct, grpStr, elemListObj)

% if isempty(grpNumSel)
if isempty(grpStr)

    set(elemListObj, 'Items', {})
    return
    
end

% grpStr = sprintf('Grp%d', grpNumSel);
listElem = DataStruct.(grpStr).Element;

set(elemListObj, 'Items', listElem)

if isempty(listElem)

    set(elemListObj, 'Value', {})
    
else
    
    set(elemListObj, 'Value', listElem(1))
    
end