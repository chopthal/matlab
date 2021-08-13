function ScanDropletChip(mainApp, currentChipInform)

global CurrentChip CurrentChamber X_abs_um Y_abs_um vid FluorMode scanCh Run_flag

% TODO : Progress bar, stop control

Run_flag = 1;

parentDir = datestr(clock);
parentDir(end-2) = '-';
parentDir(end-5) = '-';
parentDir = strcat(pwd, '\', parentDir);
mkdir(parentDir)

ResetStage(mainApp, [1 1 0])

for chambNo = 1:currentChipInform.ChamberNum(1)*currentChipInform.ChamberNum(2)
    
    if mainApp.ScanProgDlg.CancelRequested
        
        break
        
    end

    tag = sprintf('togglebutton_C%d_Chamb', CurrentChip);
    togglebutton_Chamb_Act(mainApp, tag, CurrentChamber, currentChipInform);

    observeArea = [currentChipInform.ChamberRange{chambNo, 1}(2) - currentChipInform.ChamberRange{chambNo, 1}(1),...
        currentChipInform.ChamberRange{chambNo, 2}(2) - currentChipInform.ChamberRange{chambNo, 2}(1)]; % [X, Y]
    gapFrame = observeArea ./ (currentChipInform.FrameNum - 1); % [X, Y]

    scanCoorMat = cell(currentChipInform.FrameNum(2), currentChipInform.FrameNum(1)); % {vertical, horizontal}

    childDir = sprintf('%s_%d', currentChipInform.Name, chambNo);
    savDir = strcat(parentDir, '\', childDir);
    mkdir(savDir)

    for horNo = 1:currentChipInform.FrameNum(1) % Horizontal
        
        if mainApp.ScanProgDlg.CancelRequested
        
            break
        
        end
        
        ordIdx = 1;
        ordResult = zeros(currentChipInform.FrameNum(1)*currentChipInform.FrameNum(2), 2);

        for verNo = 1:currentChipInform.FrameNum(2) % Vertical

            scanCoorMat{verNo, horNo} = [currentChipInform.ChamberRange{chambNo, 1}(1) +...
                gapFrame(1) * (horNo-1), currentChipInform.ChamberRange{chambNo, 2}(1) +...
                gapFrame(2) * (verNo-1)]; 
            
            if mod(verNo, 2) == 0

                for horNoOrd = flip(1:currentChipInform.FrameNum(1))

                    ordResult(ordIdx, 1) = horNoOrd;
                    ordResult(ordIdx, 2) = verNo;
                    ordIdx = ordIdx+1;

                end

            else

                for horNoOrd = 1:currentChipInform.FrameNum(1)

                    ordResult(ordIdx, 1) = horNoOrd;
                    ordResult(ordIdx, 2) = verNo;
                    ordIdx = ordIdx+1;

                end

            end

        end

    end

    for imNo = 1:size(ordResult, 1)
        
        if mainApp.ScanProgDlg.CancelRequested
        
            break

        end

        coorXY = scanCoorMat{ordResult(imNo, 2), ordResult(imNo, 1)}; % {Vertical, Horizontal}
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

        if mainApp.ScanProgDlg.CancelRequested == 0        

            ScanSaveImg(mainApp, vid, FluorMode, scanCh, savDir, imNo)

        end

    end
    
    % Image Stitching    
    pathContent = dir(savDir);
    imgName = {pathContent(~[pathContent.isdir]).name};
    imgNameBM = natsort(imgName(contains(imgName, 'BM')));
    imgNameFM = natsort(imgName(contains(imgName, 'FM')));

    montageFig = figure('Visible', 'Off');
    monBM = montage(fullfile(savDir, imgNameBM));
    imwrite(monBM.CData, fullfile(savDir, 'Stitched_BM.png'))
    cla(montageFig);
    monFM = montage(fullfile(savDir, imgNameFM));
    imwrite(monFM.CData, fullfile(savDir, 'Stitched_FM.png'))
    delete(montageFig);
    
end

[~] = comm2port(mainApp, 'Main_port', '$L#1#OFF', '$L#1#OFF#OK');
[~] = comm2port(mainApp, 'Main_port', '$L#2#OFF', '$L#2#OFF#OK');

Run_flag = 0;
Ch_set(mainApp, 1)

set(mainApp.radiobutton_Off, 'Value', 1)
[~] = comm2port(mainApp, 'Main_port', '$L#1#OFF', '$L#1#OFF#OK');
[~] = comm2port(mainApp, 'Main_port', '$L#2#OFF', '$L#2#OFF#OK');

winopen(parentDir)
set(mainApp.text_Status, 'Text', 'Scanning is finished.')

delete(mainApp.ScanProgDlg)
  