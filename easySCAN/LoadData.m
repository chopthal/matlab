function [dataTable, DataStruct, listData1, listVal1, listData2, listVal2, grpNum, tableStyle] = LoadData

[fileName, pathName] = uigetfile('*.mat');

if fileName == 0
    
    return;
    
end

setVars = {'dataTable', 'DataStruct', 'listData1', 'listVal1', 'listData2', 'listVal2', 'grpNum', 'tableStyle'};

fullName = fullfile(pathName, fileName);

load(fullName, setVars{:})