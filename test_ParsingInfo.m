clear

parentPath = 'D:\Users\user\Desktop\새 폴더 (2)';
dataPath = 'RU';
dataFileName = 'ch1-ch2.txt';
parentPathContents = dir(parentPath);
listContents = {parentPathContents.name};
if sum(matches(listContents, 'Info.mat')) == 0; return; end

info = load(fullfile(parentPath, 'Info.mat'));
expFieldName = 'ExpProc';
targetApplication = {'Multi-cycle Kinetics'; 'Screening'};

if isempty(info); return; end
if ~isfield(info, expFieldName); return; end

applicationName = info.(expFieldName).App;
if sum(matches(targetApplication, applicationName)) == 0; return; end

listFolder = listContents([parentPathContents.isdir]);
listFolder = listFolder(~(matches(listFolder, '.') | matches(listFolder, '..')));
listFolder = listFolder(contains(listFolder, '.'));
tmp = split(listFolder, '.');
listFolder = listFolder';
idxFolderStr = tmp(:, :, 1);
idxFolderNum = str2double(idxFolderStr);
applicationColumn = info.(expFieldName).TableData{:, 1};

[name, ~, idx] = unique(applicationColumn);
targetApplicationName = name(contains(name, applicationName));

analyte = struct;
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

isApplicationRow = cell(length(targetApplicationName), 1);
for i = 1:length(targetApplicationName)
    isApplicationRow{i, 1} = matches(applicationColumn, targetApplicationName{i});
    pathName = fullfile(parentPath, listFolder(isApplicationRow{i, 1}), dataPath, dataFileName);

    % Path
    analyte(i).Path = pathName;
    isValidFile = false(size(pathName));
    for ii = length(pathName)
        if ~isfile(pathName{i}); continue; end
        try data = readtable(pathName{i}); catch; continue; end
        if size(data, 1) == info.(expFieldName).TableData.Var11(ii, 1)
            isValidFile(ii) = true;
        end
    end    

    % is Path valid
    analyte(i).IsValidPath = isValidFile;

    % Concentration
    concentration = str2double(info.(expFieldName).TableData.Var3(isApplicationRow{i, 1})); % Concentration
    unit = cellstr(string(info.(expFieldName).TableData.Var4(isApplicationRow{i, 1}))); % Unit
    analyte(i).Concentration = concentrationUnit2Mole(concentration, unit);    

    % Name
    analyteName= info.(expFieldName).TableData.Var2(isApplicationRow{i, 1});
    analyte(i).Name = analyteName{1};

    % EventTime
    totalTime = info.(expFieldName).TableData.Var11(isApplicationRow{i, 1});
    injectionTime = str2double(info.(expFieldName).TableData.Var7(isApplicationRow{i, 1}));
    washingTime = str2double(info.(expFieldName).TableData.Var8(isApplicationRow{i, 1}));    
    
    assoStart = totalTime(1) - washingTime(1) - injectionTime(1);
    assoEnd = totalTime(1) - washingTime(1);
    dissoStart = assoEnd + 1;
    dissoEnd = totalTime(1);
    analyte(i).EventTime = [assoStart assoEnd dissoStart dissoEnd];
    
    % Data (RmaxCanditate, XData, YData)
    boundScale = 1e8;
    analyteData = cell(size(analyte(i).Concentration));
    for ii = 1:length(analyteData)
        if i == 3 && ii == 5
            disp(i)
        end
        analyteData{ii} = readtable(analyte(i).Path{ii}, 'VariableNamingRule', 'preserve');    
        analyteData{ii}.y = analyteData{ii}.y -analyteData{ii}.y(1);
        
    end    
    analyte(i).Data = analyteData;
    analyte(i).RmaxCandidate(1, 1) = analyte(i).Data{1, 1}.y(analyte(i).Data{1, 1}.x == analyte(i).EventTime(3));
    analyte(i).XData = [analyte(i).XData; analyte(i).Data{1, 1}.x];
    analyte(i).YData = [analyte(i).YData; analyte(i).Data{1, 1}.y];

    % Fitting Variables
    %% Set Default Fitting Variables
    % 1:1 Standard Fitting
    koff = ones(1, size(analyte(i).Concentration, 1)) * 10^(-4);
    kon = ones(1, size(analyte(i).Concentration, 1)) * 10^4;
    Rmax = ones(1, size(analyte(i).Concentration, 1));
    if max(analyte(i).RmaxCandidate)>0; Rmax = Rmax * max(analyte(i).RmaxCandidate); end
    BI = zeros(1, size(analyte(i).Concentration, 1));
    
    analyte(i).DefaultFittingVariable = struct;
    analyte(i).DefaultFittingVariable.FittingModel = 'OneToOneStandard';
    analyte(i).DefaultFittingVariable.OneToOneStandard = struct;
    analyte(i).DefaultFittingVariable.OneToOneStandard.Name = {'kon';   'koff';    'Rmax';   'BI'};
    analyte(i).DefaultFittingVariable.OneToOneStandard.Type = {'Global'; 'Global'; 'Global'; 'Constant'};
    analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue =...
        cell(length(analyte(i).DefaultFittingVariable.OneToOneStandard.Type), 1);
    analyte(i).DefaultFittingVariable.OneToOneStandard.UpperBound =...
        cell(length(analyte(i).DefaultFittingVariable.OneToOneStandard.Type), 1);
    analyte(i).DefaultFittingVariable.OneToOneStandard.LowerBound =...
        cell(length(analyte(i).DefaultFittingVariable.OneToOneStandard.Type), 1);

    analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{1, 1} = kon;
    analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{2, 1} = koff;
    analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{3, 1} = Rmax;
    analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{4, 1} = BI;

    analyte(i).DefaultFittingVariable.OneToOneStandard.UpperBound{1, 1} =...
        analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{1, 1} * boundScale;
    analyte(i).DefaultFittingVariable.OneToOneStandard.UpperBound{2, 1} =...
        analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{2, 1} * boundScale;
    analyte(i).DefaultFittingVariable.OneToOneStandard.UpperBound{3, 1} =...
        analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{3, 1} * boundScale;
    analyte(i).DefaultFittingVariable.OneToOneStandard.UpperBound{4, 1} =...
        zeros(size(analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{4, 1}));

    analyte(i).DefaultFittingVariable.OneToOneStandard.LowerBound{1, 1} =...
        analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{1, 1} / boundScale;
    analyte(i).DefaultFittingVariable.OneToOneStandard.LowerBound{2, 1} =...
        analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{2, 1} / boundScale;
    analyte(i).DefaultFittingVariable.OneToOneStandard.LowerBound{3, 1} =...
        analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{3, 1} / boundScale;
    analyte(i).DefaultFittingVariable.OneToOneStandard.LowerBound{4, 1} =...
        zeros(size(analyte(i).DefaultFittingVariable.OneToOneStandard.InitialValue{4, 1}));
    
    % 1:1 Mass Transfer Fitting
    kt = ones(1, size(analyte(i).Concentration, 1)) * 10^8;
    targetIdx = 3;
    analyte(i).DefaultFittingVariable.OneToOneMassTransfer = struct;
    analyte(i).DefaultFittingVariable.OneToOneMassTransfer =...
        analyte(i).DefaultFittingVariable.OneToOneStandard;    
    analyte(i).DefaultFittingVariable.OneToOneMassTransfer.Name = InsertElementToCell(...
       analyte(i).DefaultFittingVariable.OneToOneMassTransfer.Name, targetIdx, 'kt');
    analyte(i).DefaultFittingVariable.OneToOneMassTransfer.Type = InsertElementToCell(...
       analyte(i).DefaultFittingVariable.OneToOneMassTransfer.Type, targetIdx, 'Global');
    analyte(i).DefaultFittingVariable.OneToOneMassTransfer.InitialValue = InsertElementToCell(...
       analyte(i).DefaultFittingVariable.OneToOneMassTransfer.InitialValue, targetIdx, kt);
    analyte(i).DefaultFittingVariable.OneToOneMassTransfer.UpperBound = InsertElementToCell(...
       analyte(i).DefaultFittingVariable.OneToOneMassTransfer.UpperBound, targetIdx, kt * boundScale);   
    analyte(i).DefaultFittingVariable.OneToOneMassTransfer.LowerBound = InsertElementToCell(...
       analyte(i).DefaultFittingVariable.OneToOneMassTransfer.LowerBound, targetIdx, kt / boundScale);
    
   analyte(i).FittingVariable = analyte(i).DefaultFittingVariable;
    
end

disp(analyte)

function concMole = concentrationUnit2Mole(concentration, unit)

    % concentration : 1-d matrix (1, 2, ... )
    % unit : 1-d cell {'nM', 'uM', ...}
    
    concMole = [];
    
    if ~ismatrix(concentration); disp('concentration is not a matrix'); return; end
    if ~iscell(unit); disp('unit is not a cell'); return; end
    if size(concentration , 1) ~= 1 && size(concentration , 2) ~= 1; disp('concentration is not 1-d'); return; end
    if size(unit , 1) ~= 1 && size(unit , 2) ~= 1; disp('unit is not 1-d'); return; end
    if length(concentration) ~= length(unit); return; end
    
    unitList = {'TM', 'GM', 'MM', 'KM', 'M', 'mM', 'uM', 'nM', 'pM', 'fM'};
    conversionFactor = [1e12 1e9 1e6 1e3 1 1e-3 1e-6 1e-9 1e-12 1e-15];
    
    concMole = zeros(size(concentration));
    for i = 1:length(unit)
        concMole(i) = concentration(i) .* conversionFactor(matches(unitList, unit{i}));
    end

end


function resultCell = InsertElementToCell(originalCell, targetIdx, targetElement)

    resultCell = [];

    if size(originalCell, 1) ~= 1 && size(originalCell, 2) ~= 1
        disp('Original cell should be 1-D')
        return
    end

    if length(originalCell) < 1
        disp('Invalid original cell')
        return
    end

    if targetIdx < 1 || targetIdx > length(originalCell)+1
        disp('Invalid targetIdx')
        return
    end

    prevCell = originalCell(1:targetIdx-1);
    postCell = originalCell(targetIdx:end);
    
    if size(originalCell, 1) == 1
        resultCell = [prevCell, targetElement, postCell];
    elseif size(originalCell, 2) == 1
        resultCell = [prevCell; targetElement; postCell];
    end

end