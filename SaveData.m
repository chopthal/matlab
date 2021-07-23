function SaveData(dataTable, DataStruct, listData1, listVal1, listData2, listVal2, grpNum, tableStyle)

[fileName, pathName] = uiputfile('ChamberSetting.mat');

if fileName == 0
    
    return;
    
end

fullName = fullfile(pathName, fileName);

save(fullName, 'dataTable')
save(fullName, 'DataStruct', '-append')
save(fullName, 'listData1', '-append')
save(fullName, 'listVal1', '-append')
save(fullName, 'listData2', '-append')
save(fullName, 'listVal2', '-append')
save(fullName, 'grpNum', '-append')
save(fullName, 'tableStyle', '-append')

