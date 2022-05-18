function outStruct = delElem(inStruct, grpNum, elemNumSel, listObj)

% curVal = get(listObj, 'Value');
grpStr = sprintf('Grp%d', grpNum);

if isempty(fieldnames(inStruct))
    
    outStruct = [];
    return
    
end

if isempty(inStruct.(grpStr).Element)
    
    outStruct = [];
    return
    
end

% inStruct.(grpStr).Element(curVal)       = [];
% inStruct.(grpStr).Color(curVal)         = [];
% inStruct.(grpStr).Type(curVal)          = [];
% inStruct.(grpStr).RepNo(curVal)         = [];
% inStruct.(grpStr).Concentration(curVal) = [];
% inStruct.(grpStr).Position(curVal)      = [];
% inStruct.(grpStr).StdNum(curVal)        = [];
% inStruct.(grpStr).UnkNum(curVal)        = [];

inStruct.(grpStr).Element(elemNumSel)       = '';
inStruct.(grpStr).Color(elemNumSel)         = '';
inStruct.(grpStr).Type(elemNumSel)          = '';
inStruct.(grpStr).RepNo(elemNumSel)         = '';
inStruct.(grpStr).Concentration(elemNumSel) = '';
% inStruct.(grpStr).Position(elemNumSel)      = '';
inStruct.(grpStr).Position(elemNumSel)      = '';
inStruct.(grpStr).StdNum(elemNumSel)        = '';
inStruct.(grpStr).UnkNum(elemNumSel)        = '';

lenList = length(inStruct.(grpStr).Element);

% curVal = curVal(1);
elemNumSel = elemNumSel(1);

if lenList == 0
    
%     set(listObj, 'Value', [])
    set(listObj, 'Value', {})

% elseif curVal == 1
elseif elemNumSel == 1

%     set(listObj, 'Value', 1)
    set(listObj, 'Value', inStruct.(grpStr).Element{1})
    
% elseif curVal >= lenList
elseif elemNumSel >= lenList
    
%     set(listObj, 'Value', lenList)
    set(listObj, 'Value', inStruct.(grpStr).Element{lenList})
    
else
    
%     set(listObj, 'Value', curVal)
    set(listObj, 'Value', inStruct.(grpStr).Element{elemNumSel(1)})
    
end

set(listObj, 'Items', inStruct.(grpStr).Element)

% set(listObj, 'String', inStruct.(grpStr).Element)

outStruct = inStruct;
