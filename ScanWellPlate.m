% 2021. 08. 05

% easySCAN_v1.1.5 -> easySCAN_v2.0.0

% 

% function ScanWellPlate(mainApp, selTogStr, selConStr, selTogNum, hidFig, grpName)
function ScanWellPlate(mainApp, selTogStr, selConStr, selTogNum, hidFig, grpName)

% global cur_Chip X_abs_um Y_abs_um vid step_Medium_X_um step_Medium_Y_um...
%     FluorMode cur_Chamb AF_flag Z_abs_um  noFrame Run_flag refZ ResultApp...
%     ResultStruct Ch2_Exp Ch2_Gamma Ch2_Gain Ch2_Inten im_no refZ2 scanCh...
%     CamInform

global X_abs_um Y_abs_um vid...
    FluorMode CurrentChamber AF_flag Z_abs_um Run_flag refZ ResultApp...
    ResultStruct Ch2_Exp Ch2_Gamma Ch2_Gain Ch2_Inten im_no refZ2 scanCh...
    CamInform ChipInform CurrentChip

currentChipInform = ChipInform(CurrentChip);

if ~isempty(ResultApp)
    
    delete(ResultApp)
    
end

delete(findobj('Tag', 'imgPlate'))

dataComp = 0;
ResultStruct = struct;
Run_flag = 1;
[sorted_selTogNum(:, 1), sorted_selTogNum(:, 2)] = sort(selTogNum);
sorted_selConStr = selConStr(sorted_selTogNum(:, 2));
sorted_grpName = grpName(sorted_selTogNum(:, 2));
sorted_selTogStr = selTogStr(sorted_selTogNum(:, 2));
% noFrame = currentChipInform.FrameNum(1); % FrameNum(1) = FrameNum(2)
noFrame = currentChipInform.FrameNum(max(currentChipInform.FrameNum));

resetPeroid = 5;

parentDir = datestr(clock);
parentDir(end-2) = '-';
parentDir(end-5) = '-';
parentDir = strcat(pwd, '\', parentDir);
mkdir(parentDir)

refZ2 = refZ;
prevZ = (refZ + refZ2) / 2;

im_no = 1;

focInform = struct;

for i = 1:size(sorted_selTogNum, 1)

    if mainApp.ScanProgDlg.CancelRequested
        
        break
        
    end
    
    if mod(i, resetPeroid) == 1
        
        ResetStage(mainApp, [1 1 0])
        
    end
    
    startChamberScan = tic;
    
    focInform(i).isBlock = NaN(1, noFrame*noFrame);
    focInform(i).isCode = NaN(1, noFrame*noFrame);
    focInform(i).Time = NaN(1, noFrame*noFrame);
    
    imNo = 1;

    curChambStr = sprintf('togglebutton_C%d_Chamb', CurrentChip);
    togglebutton_Chamb_Act(mainApp, curChambStr, sorted_selTogNum(i, 1), currentChipInform);

    % TODO
    % eval(sprintf('global C%d_Chamb%d_X_um C%d_Chamb%d_Y_um',...
    %     cur_Chip, sorted_selTogNum(i, 1), cur_Chip, sorted_selTogNum(i, 1)));
    % eval(sprintf('C_Chamb_X_um = C%d_Chamb%d_X_um;', cur_Chip, sorted_selTogNum(i, 1)));
    % eval(sprintf('C_Chamb_Y_um = C%d_Chamb%d_Y_um;', cur_Chip, sorted_selTogNum(i, 1)));
    C_Chamb_X_um = currentChipInform.ChamberRange{sorted_selTogNum(i, 1), 1};
    C_Chamb_Y_um = currentChipInform.ChamberRange{sorted_selTogNum(i, 1), 2};

    scanCoorMat = cell(noFrame, noFrame);    
    
    observeArea = [currentChipInform.ChamberRange{sorted_selTogNum(i, 1), 1}(2) - currentChipInform.ChamberRange{sorted_selTogNum(i, 1), 1}(1),...
        currentChipInform.ChamberRange{sorted_selTogNum(i, 1), 2}(2) - currentChipInform.ChamberRange{sorted_selTogNum(i, 1), 2}(1)]; % [X, Y]
    gapFrame = observeArea / (noFrame - 1); % [X, Y]

    for verNo = 1:noFrame % vertical    

        for horNo = 1:noFrame % Horizontal        

            % scanCoorMat{iii, ii} = [C_Chamb_X_um(1) + step_Medium_X_um * (iii-1),...
            % C_Chamb_Y_um(1) + step_Medium_Y_um * (ii-1)];    
            scanCoorMat{verNo, horNo} = [C_Chamb_X_um(1) + gapFrame(1) * (verNo-1),...
            C_Chamb_Y_um(1) + gapFrame(2) * (horNo-1)];    

        end

    end
    
    if noFrame>1
        scanOrderMat = SqrOrderMat(noFrame);
    end
    
    coorBlock = refZ;
    Z_Focused = refZ;
    
    isBlock = 0;
    isFocused = 0;
    isCode = 0;
            
    if isempty(sorted_selConStr{i, 1})
        
        childDir = sprintf('%s-%s',...
        sorted_grpName{i, 1},...        
        sorted_selTogStr{i, 1});
        
    else
        
        childDir = sprintf('%s-%s%s',...
        sorted_grpName{i, 1},...
        sorted_selConStr{i, 1},...
        sorted_selTogStr{i, 1}(end-2:end));
        
    end
    
    savDir = strcat(parentDir, '\', childDir);
    mkdir(savDir)
        
    while mainApp.ScanProgDlg.CancelRequested == 0 && imNo <= noFrame^2         
        
        mainApp.ScanProgDlg.Message = sprintf(...
            'Auto Scanning...\n - Chamber : %d / %d\n - Image : %d / %d',...
            i, size(sorted_selTogNum, 1), imNo, noFrame^2);
        
        if noFrame == 1
            coorXY = scanCoorMat{1, 1};            
        else
            coorXY = scanCoorMat{scanOrderMat' == imNo};
        end
        distCoorX = abs(X_abs_um - coorXY(1));
        distCoorY = abs(Y_abs_um - coorXY(2));

        if X_abs_um > coorXY(1)

            Stage_Control(mainApp, 'X', 'F', distCoorX);            

        elseif X_abs_um < coorXY(1)

            Stage_Control(mainApp, 'X', 'B', distCoorX);            

        end

        if Y_abs_um > coorXY(2)

            Stage_Control(mainApp, 'Y', 'F', distCoorY);            

        elseif Y_abs_um < coorXY(2)

            Stage_Control(mainApp, 'Y', 'B', distCoorY);            

        end
        
        scanTime = tic;
        
        if get(mainApp.checkbox_withAF, 'Value') && mainApp.ScanProgDlg.CancelRequested == 0
            
            AF_flag = 1;
            
            if isCode == 0
                
                isBlock = 0;
                
                Ch_set(mainApp, 1)
                isBlock = DetectObj(mainApp);
                focInform(i).isBlock(imNo) = isBlock;
                
                if isBlock == 1                    

                    % Auto Focus
                    AutoFocusing(mainApp, refZ);
                    
                    % isCode?
                    if mainApp.ScanProgDlg.CancelRequested == 0
                    
                        Ch_set(mainApp, 1)
                        isCode = IsCode(mainApp);
                    
                    end
                    
                    focInform(i).isCode(imNo) = isCode;
                    
                end
                
                if isCode == 0 && mainApp.ScanProgDlg.CancelRequested == 0
                    
                    Z_Focused = refZ;
                    
                    if Z_abs_um > Z_Focused

                        Stage_Control(mainApp, 'Z', 'F', Z_abs_um - Z_Focused)

                    else

                        Stage_Control(mainApp, 'Z', 'B', Z_Focused - Z_abs_um)

                    end
                    
                end
                
            end
                
        end
       
    AF_flag = 0;
    
    if mainApp.ScanProgDlg.CancelRequested == 0        
        
        ScanSaveImg(mainApp, vid, FluorMode, scanCh, savDir, imNo)
        
    end
    
    focInform(i).Time(imNo) = toc(scanTime);
    imNo = imNo + 1;
            
    end
    
    timeChamberScan = toc(startChamberScan);
    fprintf('Time Chamber Scan = %d\n', timeChamberScan)
    
end

[~] = comm2port(mainApp, 'Main_port', '$L#1#OFF', '$L#1#OFF#OK');
[~] = comm2port(mainApp, 'Main_port', '$L#2#OFF', '$L#2#OFF#OK');

if mainApp.ScanProgDlg.CancelRequested ~= 1
    
    fileName = fullfile(parentDir, 'ChamberDesing.png');
    
    try
        
        exportapp(hidFig, fileName)
        delete(hidFig)
        
    catch
  
        disp('Cannot Find the Chamber Design Figure')
        hidFig.Name = 'Chamber Design (Cannot save)';
        hidFig.Visible = 'on';        
        
    end
    
end

DataStruct = getappdata(0, 'DataStruct');

strField = fieldnames(DataStruct);

CodeNum = struct;

infoFileName = fullfile(parentDir, 'Information.txt');
infoFileID = fopen(infoFileName, 'w');

for i = 1:size(strField, 1)
    
    tmpIdx = find(~cellfun(@isempty, DataStruct.(strField{i, 1}).Position)); % 20201113 Issue
    
    if ~isempty(tmpIdx)
        
        CodeNum.(strField{i, 1}) = DataStruct.(strField{i, 1}).CodeNum;
        
        % Group number (Group Name)
        fprintf(infoFileID, 'Group %s (%s)\n', strField{i, 1}(4:end), DataStruct.(strField{i, 1}).Name);
        
        for ii = 1:size(tmpIdx, 1)
            
            % Folder Name / Sample Number / Chamber Position            
            if isempty(DataStruct.(strField{i, 1}).Concentration{tmpIdx(ii, 1), 1})
        
                childDir = sprintf('%s-%s',...
                    strField{i, 1},...        
                    DataStruct.(strField{i, 1}).Element{tmpIdx(ii, 1), 1});

            else

                childDir = sprintf('%s-%s%s',...
                    strField{i, 1},...
                    DataStruct.(strField{i, 1}).Concentration{tmpIdx(ii, 1), 1},...
                    DataStruct.(strField{i, 1}).Element{tmpIdx(ii, 1), 1}(end-2:end));

            end
            
            fprintf(infoFileID, '%s / %s / %s\n', childDir,...
                DataStruct.(strField{i, 1}).Element{tmpIdx(ii, 1), 1},...
                DataStruct.(strField{i, 1}).Position{tmpIdx(ii, 1), 1});
            
        end
        
        fprintf(infoFileID, '\n%s\n', 'Analytes');
        
        for iii = 1:size(DataStruct.(strField{i, 1}).ListAnalyte, 1)
            
            fprintf(infoFileID, '%s\n', DataStruct.(strField{i, 1}).ListAnalyte{iii, 1});
            
        end
        
        fprintf(infoFileID, '\n');
        
    end
    
end

fclose(infoFileID);

fileNameCodeNum = fullfile(parentDir, 'CodeNum.mat');
save(fileNameCodeNum, 'CodeNum')

% for i = 1:size(focInform, 2)
%     
%     tmp(3*i-2, :) = focInform(i).isBlock;
%     tmp(3*i-1, :) = focInform(i).isCode;
%     tmp(3*i, :) = focInform(i).Time;
%     
% end

% fileNameScanInform = fullfile(parentDir, 'ScanInform.xls');
% writematrix(tmp, fileNameScanInform)

Run_flag = 0;

Ch_set(mainApp, 1)

set(mainApp.radiobutton_Off, 'Value', 1)
[~] = comm2port(mainApp, 'Main_port', '$L#1#OFF', '$L#1#OFF#OK');
[~] = comm2port(mainApp, 'Main_port', '$L#2#OFF', '$L#2#OFF#OK');

winopen(parentDir)
set(mainApp.text_Status, 'Text', 'Scanning is finished.')

delete(mainApp.ScanProgDlg)