function screeningData = parsingScreeningInfo(parentPath)

screeningData = [];

dataMinLength = 20;
dataPath = 'RU';
dataFileName = 'ch1-ch2.txt';
parentPathContents = dir(parentPath);
listContents = {parentPathContents.name};

try
    info = load(fullfile(parentPath, 'Info.mat'));
catch    
    return;
end
expFieldName = 'ExpProc';
immobApplication = 'Immobilization';
applicationName = info.(expFieldName).App;

if ~strcmp(applicationName, 'Screening')
    return
end

listFolder = listContents([parentPathContents.isdir]);
listFolder = listFolder(~(matches(listFolder, '.')|matches(listFolder, '..')));
listFolder = listFolder(contains(listFolder, '.'));
dotIndex = strfind(listFolder, '.');
idxFolderStr = cell(size(dotIndex));

for i = 1:length(dotIndex)
    idxFolderStr{i} = listFolder{i}(1:dotIndex{i}(1)-1);
end

idxFolderNum = str2double(idxFolderStr);            
applicationColumn = info.(expFieldName).TableData{:, 1};      
name = unique(applicationColumn);
targetApplicationName = name(contains(name, applicationName));
screeningData = struct;
screeningData.ColNum = [];
screeningData.Name = '';
screeningData.Path = [];
screeningData.Data = [];
containImmobilization = sum(matches(applicationColumn, immobApplication));
immobData = [];
isImmobilization = [];

if containImmobilization
    immobFolder = listFolder{contains(listFolder, immobApplication)};
    immobPath = fullfile(parentPath, immobFolder, 'RU', 'Ch1.txt');
    isImmobilization = matches(applicationColumn, immobApplication);
    try
        immobData = readtable(immobPath);    
    catch
        isImmobilization = [];
    end
end

isApplicationRow = cell(1, 1);
screeningData.ColNum = info.(expFieldName).ColNum;                
isApplicationRow{1, 1} = matches(applicationColumn, targetApplicationName{1});
screeningData.ImmobilizationData = immobData;    
tmpCell = table2cell(info.ExpProc.TableData);                
informCell = tmpCell(isImmobilization, :);
informCell = [informCell; tmpCell(isApplicationRow{1, 1}, :)];
screeningData.Information.Data = informCell;
folderNo = find(isApplicationRow{1, 1}==1);
tmpList = listFolder(ismember(idxFolderNum, folderNo));
tmpDotIndex = strfind(tmpList, '.');
tmpIdxFolderStr = cell(size(tmpDotIndex));

for ii = 1:length(tmpDotIndex)
    tmpIdxFolderStr{ii} = tmpList{ii}(1:tmpDotIndex{1}(1)-1);
end

[~, tmpIdx] = sort(str2double(tmpIdxFolderStr));
sortedListFolder = tmpList(tmpIdx);
pathName = fullfile(parentPath, sortedListFolder, dataPath, dataFileName);
isValidFile = false(size(pathName));

for ii = 1:length(pathName)
    if ~isfile(pathName{ii})        
        continue;    
    end

    try        
        data = readtable(pathName{ii});    
    catch        
        continue    
    end

    if size(data, 1)==info.(expFieldName).TableData.Var11(ii, 1) && size(data, 2) == 2 && size(data, 1) > dataMinLength
        isValidFile(ii) = true;
    end

end

screeningData.Path = pathName(isValidFile);
isApplicationRow{i, 1}(folderNo(~isValidFile)) = 0;

if isempty(screeningData.Path)||(sum(isApplicationRow{1, 1})==0)
    return
end

result = cell(size(screeningData.Path, 2), 1);
for ii = 1:length(result)
     tableData =...
        readtable(screeningData.Path{ii}, 'VariableNamingRule', 'preserve');    
     result{ii, 1} = [tableData.x tableData.y];
end    

for i = 1:size(result, 1)
    screeningData.Data = [screeningData.Data result{i}];
end