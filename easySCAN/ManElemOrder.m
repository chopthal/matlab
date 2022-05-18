function outStruct = ManElemOrder(inStruct, grpNum, listObj, dir)

elemVal = get(listObj, 'Value');

if isempty(elemVal) || isempty(fieldnames(inStruct))
    
    outStruct = [];    
    return
    
end

elemList   = get(listObj, 'Items');
elemNumSel = zeros(1, size(elemVal, 2));

for i = 1:size(elemVal, 2)

    for ii = 1:size(elemList, 2)

        if strcmp(elemVal{1, i}, elemList{1, ii})

            elemNumSel(i) = ii;

        end

    end

end

elemNumSel = sort(elemNumSel);

% curVal = get(listObj, 'Value');

grpStr = sprintf('Grp%d', grpNum);

lenIdx = length(inStruct.(grpStr).Element);
ordIdx = (1:1:lenIdx)';

if strcmpi(dir, 'Down')
    
    if elemNumSel(end) >= lenIdx

        outStruct = [];
        return
    
    end

    upIdx = ordIdx(1 : elemNumSel(end)+1);
    dnIdx = ordIdx(elemNumSel(end)+2 : end);
    tgIdx = upIdx(elemNumSel);
    upIdx(elemNumSel) = [];    
    
    startVal = elemNumSel(end) + 2 - length(elemNumSel);
    endVal = startVal + length(elemNumSel) - 1;
    
elseif strcmpi(dir, 'Up')
    
    if elemNumSel(1) <= 1
        
        outStruct = [];
        return
        
    end
    
    upIdx = ordIdx(1 : elemNumSel(1)-2);
    dnIdx = ordIdx(elemNumSel(1)-1 : end);

    tgIdx = dnIdx(elemNumSel - size(upIdx, 1));
    dnIdx(elemNumSel - size(upIdx, 1)) = [];    
    
    startVal = elemNumSel(1) - 1;
    endVal = startVal + length(elemNumSel) - 1;
    
end

resIdx = [upIdx; tgIdx; dnIdx];

inStruct.(grpStr).Element       = inStruct.(grpStr).Element(resIdx);
inStruct.(grpStr).Color         = inStruct.(grpStr).Color(resIdx);
inStruct.(grpStr).Type          = inStruct.(grpStr).Type(resIdx);
inStruct.(grpStr).RepNo         = inStruct.(grpStr).RepNo(resIdx);
inStruct.(grpStr).Concentration = inStruct.(grpStr).Concentration(resIdx);

% set(listObj, 'String', inStruct.(grpStr).Element)
set(listObj, 'Items', inStruct.(grpStr).Element)
elemNumSel = startVal : endVal;
set(listObj, 'Value', {inStruct.(grpStr).Element{elemNumSel}})

% set(listObj, 'Value', elemNumSel)

outStruct = inStruct;
