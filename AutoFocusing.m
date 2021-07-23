% 2021. 04. 01

% easySCAN_v1.1.3 -> easySCAN_v1.1.4

% Don't display time for scanning anymore.

function AutoFocusing(MainApp, refZ)

% startAF = tic;

global Z_abs_um

if isvalid(MainApp.AFProgDlg)
    
    progDlg = MainApp.AFProgDlg;
    
elseif isvalid(MainApp.ScanProgDlg)
    
    progDlg = MainApp.ScanProgDlg;
    
else
    
    progDlg.CancelRequested = 0;
        
end

if progDlg.CancelRequested == 1
    
    return
    
end

preInterval = 40;
focInterval = 10;
focRange = 80;
distComp = 0;

[preMaxPos, ~, ~] = FindMaxGradIntZ(MainApp, refZ, preInterval, MainApp.edit_Range.Value, distComp, progDlg);     
[maxPos, GData, isCenter] = FindMaxGradIntZ(MainApp, preMaxPos, focInterval, focRange, distComp, progDlg);

if isCenter == 0

    [maxPos, GData, ~] = FindMaxGradIntZ(MainApp, maxPos, focInterval, focRange, distComp, progDlg);

end

if progDlg.CancelRequested == 1
    
    return
    
end

% startVZone = tic;
Z_Focused = FindVZone(GData);
% timeVZone = toc(startVZone);
% fprintf('Time V Zone = %d\n', timeVZone)

if progDlg.CancelRequested == 1
    
    return
    
end

% Reset
% startReset = tic;
ResetStage(MainApp, [0 0 1])
% timeReset = toc(startReset);
% fprintf('Reset time = %d\n', timeReset)

if Z_abs_um > Z_Focused
    
    Stage_Control(MainApp, 'Z', 'F', Z_abs_um - Z_Focused + distComp)
    Stage_Control(MainApp, 'Z', 'B', distComp)

else
    
    Stage_Control(MainApp, 'Z', 'B', Z_Focused - Z_abs_um + distComp)
    Stage_Control(MainApp, 'Z', 'F', distComp)

end

% timeAF = toc(startAF);
% fprintf('Time AF = %d\n', timeAF)


function [maxPos, GData, isCenter] = FindMaxGradIntZ(MainApp, startZ, focusInterval, focusLength, distComp, progDlg)

global Run_flag AF_flag Z_abs_um

maxPos = [];
numFocusZ = floor(focusLength/focusInterval) + 1;
GData = zeros(numFocusZ, 2);
isCenter = 0;

focusRange = [startZ - focusLength/2, startZ + focusLength/2];

if isempty(startZ)
    
    return
    
end

if progDlg.CancelRequested == 1
    
    return
    
end

% Reset
% startReset = tic;
ResetStage(MainApp, [0 0 1])
% timeReset = toc(startReset);
% fprintf('Reset time = %d\n', timeReset)

if Z_abs_um > focusRange(1)
    
    Stage_Control(MainApp, 'Z', 'F', Z_abs_um - focusRange(1) + distComp)

else
    
    Stage_Control(MainApp, 'Z', 'B', focusRange(1) - Z_abs_um + distComp)

end

for i = 1:numFocusZ
    
    if progDlg.CancelRequested == 1
        
        break
        
    end
    
    if i == 1 && distComp > 0
        
        Stage_Control(MainApp, 'Z', 'B', distComp)
        
    end
    
    GData(i, :) = PreAFgetImgHist(MainApp, Z_abs_um);    

    if i ~= numFocusZ
        
        Stage_Control(MainApp, 'Z', 'B', focusInterval);
        
    end
    
end

if progDlg.CancelRequested == 1

    Run_flag = 0;
    AF_flag = 0;
    return
    
else
    
    [~, idx] = max(GData(:, 1));
    
    if idx == ceil(size(GData, 1) / 2)
        
        isCenter = 1;
        
    end
    
    maxPos = GData(idx, 2);

end


function GData = PreAFgetImgHist(MainApp, Z_abs_um)

% startAFSnap = tic;
Z_im = Get_Snapshot(MainApp, 1);
% timeAFSnap = toc(startAFSnap);
% fprintf('AF Snap time = %d\n', timeAFSnap)

[Gmag, ~] = imgradient(im2double(Z_im));    
GmagInten = mean(Gmag, 'All');

coorZ = Z_abs_um;
GData = [GmagInten coorZ];


function Z_Focused = FindVZone(GData)

% GData : [GmagInten Position(Z)], ex) [10000 7000; 12000 7040; ...].
% maxPos : Z-Coordination of the maximum GmagInten Position.

% Find V-Zone

uGI = GData(:, 1);

VzoneVal = [];
VzoneIdx = [];

for uGINum = 2:(length(uGI)-1)
    
    [MinVal, MinIdx] = min(uGI((uGINum-1):(uGINum+1)));
    
    if MinIdx==2
        
        VzoneVal(end+1) = MinVal;
        VzoneIdx(end+1) = uGINum;
        
    end
        
end

if isempty(VzoneIdx)
    
    [~, VzoneIdx] = max(uGI);
    
else    
    
    [~, MinIdx] = min(VzoneVal);
    VzoneIdx = VzoneIdx(MinIdx);
    
end

Z_Focused = GData(VzoneIdx, 2);