% 2021.08.04
% iMeasy_Multi_v1.0.0 -> easySCAN_v2.0.0

% Scan function name is changed : StartScan -> ScanWellPlate
% ReadyToScan function name is changed to ReadyToScanWellPlate

% function ReadyToScan(mainApp, DataStruct, AppObject, hidFig)
function ReadyToScanWellPlate(mainApp, DataStruct, AppObject, hidFig)

delete(AppObject)
   
grpList = fieldnames(DataStruct);
chList = [];
selTogStr = [];
selConStr = [];
grpName = [];
grpTmp = [];

for j = 1:size(grpList, 1)

    chList = [chList; DataStruct.(grpList{j}).Position];
    selTogStr = [selTogStr; DataStruct.(grpList{j}).Element];
    selConStr = [selConStr; DataStruct.(grpList{j}).Concentration];

    for jj = 1:size(DataStruct.(grpList{j}).Element, 1)

        grpTmp{jj, 1} = grpList{j, 1};    

    end

    grpName = [grpName; grpTmp];
    grpTmp = [];

end

selTogNum = Name2Idx(chList);
selTogStr(selTogNum == 0) = [];
selConStr(selTogNum == 0) = [];
grpName(selTogNum == 0) = [];
selTogNum(selTogNum == 0) = [];

if isempty(selTogNum)

    return

end

% startScan(mainApp, selTogStr, selConStr, selTogNum, hidFig, grpName)
ScanWellPlate(mainApp, selTogStr, selConStr, selTogNum, hidFig, grpName)