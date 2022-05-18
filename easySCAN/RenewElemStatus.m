% 2020.10.21

% iMeasy_Multi_v1.0.0

% function RenewElemStatus(MainTextHandle, grpStr, elemVal, DataStruct)
function RenewElemStatus(selApp, grpStr, elemVal, DataStruct)

if isempty(elemVal) || isempty(grpStr)
    
    typeStr    = '';
    colMat     = [0.94 0.94 0.94];
    repNo      = '';
    conStr     = '';
    posStr     = '';
    grpFullStr = '';
    unitStr    = '';
    
else
                
    for ii = 1:size(DataStruct.(grpStr).Element, 1)

        if strcmp(elemVal, DataStruct.(grpStr).Element{ii, 1})

            elemNumSel = ii;

        end

    end
    
    typeStr    = DataStruct.(grpStr).Type{elemNumSel};
    colMat     = DataStruct.(grpStr).Color{elemNumSel};
    repNo      = DataStruct.(grpStr).RepNo(elemNumSel);
    conStr     = DataStruct.(grpStr).Concentration(elemNumSel);
    posStr     = DataStruct.(grpStr).Position(elemNumSel);
    grpNum     = grpStr(4:end);
    grpFullStr = strcat('Group', grpNum);
    unitStr    = DataStruct.(grpStr).Unit{elemNumSel};
    
end

% set(MainTextHandle.Type,          'Text', typeStr)
% set(MainTextHandle.Group,         'Text', grpFullStr)
% set(MainTextHandle.Color,         'BackgroundColor', colMat)
% set(MainTextHandle.RepNo,         'Text', repNo)
% set(MainTextHandle.Concentration, 'Text', conStr)
% set(MainTextHandle.Position,      'Text', posStr)
% set(MainTextHandle.Unit,          'Text', unitStr)

set(selApp.textType,          'Text', typeStr)
set(selApp.textGroup,         'Text', grpFullStr)
set(selApp.textColor,         'BackgroundColor', colMat)
set(selApp.textRepNo,         'Text', repNo)
set(selApp.textConcentration, 'Text', conStr)
set(selApp.textPosition,      'Text', posStr)
set(selApp.textUnit,          'Text', unitStr)