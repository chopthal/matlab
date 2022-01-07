function analyte = test_path_parsing(parentPath, eventTime)

parentPathContents = dir(parentPath);
listContents = {parentPathContents.name};
isFolder = [parentPathContents.isdir];
listFolder = listContents(isFolder);

% parseWord = 'Multi-cycle Kinetics';
parseWord = 'Analyte Binding';

% listMCKFolder = listFolder(contains(listFolder, 'Multi-cycle Kinetics'))';
listMCKFolder = listFolder(contains(listFolder, parseWord))';
tmp = strfind(listMCKFolder, '.');
tmp1 = zeros(size(listMCKFolder, 1), 1);

for i = 1:size(listMCKFolder, 1)
    if tmp{i} >= 2
        tmp1(i) = str2double(listMCKFolder{i}(1:tmp{i}-1));
    end
end

[~, tmp1SortedIndex] = sort(tmp1);
listMCKFolder = listMCKFolder(tmp1SortedIndex);
% disp(listMCKFolder)

kIndex = strfind(listMCKFolder, parseWord);
informStr = cell(size(listMCKFolder, 1), 1);

for i = 1:size(listMCKFolder, 1)
    informStr{i} = listMCKFolder{i}(kIndex{i}+length(parseWord)+1:end);
    
end
% disp(informStr)

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
boundScale = 10000;

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
%     disp(analyteName)
%     disp([analyteNo, analyteConcentration])    
    analyte(analyteNo).Name = analyteName;
    analyte(analyteNo).Concentration = [analyte(analyteNo).Concentration; analyteConcentration * 10^-9];    
    analyte(analyteNo).EventTime = eventTime;
    if isempty(analyte(analyteNo).Path)
        analyte(analyteNo).Path{1, 1} = fullfile(parentPath, listMCKFolder{i}, 'RU', 'Ch1-Ch2.txt');
    else
        analyte(analyteNo).Path{end+1, 1} = fullfile(parentPath, listMCKFolder{i}, 'RU', 'Ch1-Ch2.txt');
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
    
    %% Set Default Fitting Variables
    koff = ones(1, size(analyte(analyteNo).Concentration, 1)) * 10^(-4);
    kon = ones(1, size(analyte(analyteNo).Concentration, 1)) * 10^4;
    Rmax = ones(1, size(analyte(analyteNo).Concentration, 1));
    if max(analyte(analyteNo).RmaxCandidate)>0; Rmax = Rmax * max(analyte(analyteNo).RmaxCandidate); end
    BI = zeros(1, size(analyte(analyteNo).Concentration, 1));
    
    analyte(analyteNo).DefaultFittingVariable = struct;
    analyte(analyteNo).DefaultFittingVariable.FittingModel = 'OneToOneStandard';
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard = struct;
%     analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.Name = {'koff';   'kon';    'Rmax';   'BI'};
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.Name = {'kon';   'koff';    'Rmax';   'BI'};
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.Type = {'Global'; 'Global'; 'Global'; 'Local'};
%     analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.Type = {'Local'; 'Local'; 'Local'; 'Local'};
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue =...
        cell(length(analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.Type), 1);
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.UpperBound =...
        cell(length(analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.Type), 1);
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.LowerBound =...
        cell(length(analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.Type), 1);

    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{1, 1} = kon;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{2, 1} = koff;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{3, 1} = Rmax;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{4, 1} = BI;

    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.UpperBound{1, 1} =...
        analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{1, 1} * boundScale;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.UpperBound{2, 1} =...
        analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{2, 1} * boundScale;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.UpperBound{3, 1} =...
        analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{3, 1} * boundScale;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.UpperBound{4, 1} =...
        inf(size(analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{4, 1}));

    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.LowerBound{1, 1} =...
        analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{1, 1} / boundScale;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.LowerBound{2, 1} =...
        analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{2, 1} / boundScale;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.LowerBound{3, 1} =...
        analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{3, 1} / boundScale;
    analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.LowerBound{4, 1} =...
        -inf(size(analyte(analyteNo).DefaultFittingVariable.OneToOneStandard.InitialValue{4, 1}));
end