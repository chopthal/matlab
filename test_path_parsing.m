function analyte = test_path_parsing(parentPath, eventTime)

parentPathContents = dir(parentPath);
listContents = {parentPathContents.name};
isFolder = [parentPathContents.isdir];
listFolder = listContents(isFolder);

listMCKFolder = listFolder(contains(listFolder, 'Multi-cycle Kinetics'))';
tmp = strfind(listMCKFolder, '.');
tmp1 = zeros(size(listMCKFolder, 1), 1);

for i = 1:size(listMCKFolder, 1)
    if tmp{i} >= 2
        tmp1(i) = str2double(listMCKFolder{i}(1:tmp{i}-1));
    end
end

[~, tmp1SortedIndex] = sort(tmp1);
listMCKFolder = listMCKFolder(tmp1SortedIndex);
disp(listMCKFolder)

parseWord = 'Multi-cycle Kinetics';
kIndex = strfind(listMCKFolder, parseWord);
informStr = cell(size(listMCKFolder, 1), 1);

for i = 1:size(listMCKFolder, 1)
    informStr{i} = listMCKFolder{i}(kIndex{i}+length(parseWord)+1:end);
    
end
disp(informStr)

parNum = count(informStr, '(');
analyte = struct;
concentrationUnit = 'nM';
analyte.Name = '';
analyte.Concentration = [];
analyte.Path = [];
analyte.Data = [];
analyte.RmaxCandidate = [];
analyte.XData = [];
analyte.YData = [];
analyte.k = [];
analyte.kName = [];
analyte.chi2 = [];
analyte.FittedT = [];
analyte.FittedR = [];
for i = 1:size(parNum, 1)    
    parStart = strfind(informStr{i}, '(');
    parEnd = strfind(informStr{i}, ')');         
    if parNum(i) == 1
        analyteNo = 1;        
    else
        analyteNo = str2double(informStr{i}(parStart(1)+1 : parEnd(1)-1));                
    end    
    if size(analyte, 1) == analyteNo
    end    
    tmp = split(informStr{i}(parStart(end)+1 : parEnd(end)-1), ' ');
    if size(tmp, 1) == 1
        analyteName = '';
    else
        analyteName = join(tmp(1:end-1), ' ');
        if iscell(analyteName)
            analyteName = analyteName{1};
        end
    end
    concentrationStr = tmp{end};        
    analyteConcentration = str2double(concentrationStr(1:end-length(concentrationUnit)));
    disp(analyteName)
    disp([analyteNo, analyteConcentration])    
    analyte(analyteNo).Name = analyteName;
    analyte(analyteNo).Concentration = [analyte(analyteNo).Concentration; analyteConcentration * 10^-9];    
    analyte(analyteNo).EventTime = eventTime;
    if isempty(analyte(analyteNo).Path)
        analyte(analyteNo).Path{1, 1} = fullfile(parentPath, listMCKFolder{i}, 'RU', 'Ch2-Ch1.txt');
    else
        analyte(analyteNo).Path{end+1, 1} = fullfile(parentPath, listMCKFolder{i}, 'RU', 'Ch2-Ch1.txt');
    end
    
    if isempty(analyte(analyteNo).Data)
        analyte(analyteNo).Data{1, 1} = readtable(analyte(analyteNo).Path{end}, 'VariableNamingRule', 'preserve');    
        analyte(analyteNo).Data{1, 1}.y = analyte(analyteNo).Data{1, 1}.y - analyte(analyteNo).Data{1, 1}.y(1);
        analyte(analyteNo).RmaxCandidate(1, 1) = analyte(analyteNo).Data{1, 1}.y(analyte(analyteNo).Data{1, 1}.x == analyte(analyteNo).EventTime(3));
        analyte(analyteNo).XData = [analyte(analyteNo).XData; analyte(analyteNo).Data{1, 1}.x];
        analyte(analyteNo).YData = [analyte(analyteNo).YData; analyte(analyteNo).Data{1, 1}.y];
    else
        analyte(analyteNo).Data{end+1, 1} = readtable(analyte(analyteNo).Path{end}, 'VariableNamingRule', 'preserve');
        analyte(analyteNo).Data{end, 1}.y = analyte(analyteNo).Data{end, 1}.y - analyte(analyteNo).Data{end, 1}.y(1);
        analyte(analyteNo).RmaxCandidate(end+1, 1) = analyte(analyteNo).Data{end, 1}.y(analyte(analyteNo).Data{end, 1}.x == analyte(analyteNo).EventTime(3));
        analyte(analyteNo).XData = [analyte(analyteNo).XData; analyte(analyteNo).Data{end, 1}.x];
        analyte(analyteNo).YData = [analyte(analyteNo).YData; analyte(analyteNo).Data{end, 1}.y];
    end    
end