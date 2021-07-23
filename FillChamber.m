% 2020. 09. 22
% iMeasy-M_v2.1.0 -> iMeasy-M_v2.4.0

% handles -> app
% addStyle without using HTML Codes.
% Filling algorithm changed : pass non-empty cell and position.

function [listPos, dataTable, tableStyle] = FillChamber(app, listData, dataTable, listPos, listCol, tableStyle)

if isempty(app.indSel)
    
    return
    
end

if get(app.radiobutton2, 'Value')
    
    indSel = flipud(app.indSel);
    
else
    
    indSel = app.indSel;
    
end

% colergen = @(color,text)...
%     ['<html><table border=0 width=80 bgcolor=',color,'><TR><TD align=center style=''font-size:9px''>',text,'</TD></TR> </table>'];

i = 1; ii = 1;
while ii <= size(listData, 1) && ii <= size(indSel, 1)
    
    if ~isempty(dataTable{indSel(i, 1), indSel(i, 2)})
        
        i = i+1;
        continue
        
    end
    
    if ~isempty(listPos{ii, 1})
        
        ii = ii + 1;
        continue
        
    end
    
%     if isempty(listPos{ii, 1})
        
%         hexCol = RGB2Hex(listCol{ii});
%         dataTable{indSel(i, 1), indSel(i, 2)} = colergen(hexCol, listData{ii});

    celllStyle = uistyle;
    celllStyle.BackgroundColor = listCol{ii};        
    celllStyle.HorizontalAlignment = 'center';
    addStyle(app.uitablePlate, celllStyle, 'cell', [indSel(i, 1), indSel(i, 2)])
    dataTable{indSel(i, 1), indSel(i, 2)} = listData{ii};      
    tableStyle(indSel(i, 1), indSel(i, 2)) = celllStyle;

    listPos{ii, 1} = Idx2Str([indSel(i, 1), indSel(i, 2)]);
    i = i+1;
        
%     end
    
    ii = ii+1;
    
end

% set(app.uitable2, 'Data', dataTable)
set(app.uitablePlate, 'Data', dataTable)