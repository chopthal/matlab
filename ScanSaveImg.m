% 2021. 04. 01

% easySCAN_v1.1.3 -> easySCAN_v1.1.4

% Don't display time for scanning anymore.


function ScanSaveImg(app, vid, FluorMode, scanCh, savDir, fileNum)

% startScanSave = tic;
chStr = {'BM' 'FM'};

if length(scanCh) >= 2

    Ch_set(app, 1);
    im = Get_Snapshot(app, 1);   
    
    Ch_set(app, 2)
    
%     startSave = tic;
    savName = sprintf('%d_%s.png', fileNum, chStr{1});    
    pathFile = fullfile(savDir, savName);
    imwrite(im, pathFile)
    
%     timeSave = toc(startSave);
%     fprintf('Time for Save = %d\n', timeSave) 

    im = Get_Snapshot(app, 2);   

    im_colored = uint16(zeros([size(im), 3]));

    if strcmp(FluorMode, 'PE')

        im_colored(:, :, 2) = im;
        im_colored(:, :, 1) = im;

    elseif strcmp(FluorMode, 'FITC')

        im_colored(:, :, 2) = im;

    end

    im = im_colored;

    Ch_set(app, 1)
%     startSave = tic;
    savName = sprintf('%d_%s.png', fileNum, chStr{2});    
    pathFile = fullfile(savDir, savName);
    imwrite(im, pathFile)
    
%     timeSave = toc(startSave);
%     fprintf('Time for Save = %d\n', timeSave)    

%     timeScanSave = toc(startScanSave);
%     fprintf('Time for ScanSave = %d\n', timeScanSave)
    
else

    for ch = scanCh

        Ch_set(app, ch);
        im = Get_Snapshot(app, ch);

        if ch~=1

            im_colored = uint16(zeros([size(im), 3]));

            if strcmp(FluorMode, 'PE')

                im_colored(:, :, 2) = im;
                im_colored(:, :, 1) = im;

            elseif strcmp(FluorMode, 'FITC')

                im_colored(:, :, 2) = im;

         end

        im = im_colored;

        end

%         startSave = tic;

        savName = sprintf('%d_%s.png', fileNum, chStr{ch});    
        pathFile = fullfile(savDir, savName);

        imwrite(im, pathFile)

%         timeSave = toc(startSave);
%         fprintf('Time for Save = %d\n', timeSave)    

%         timeScanSave = toc(startScanSave);
%         fprintf('Time for ScanSave = %d\n', timeScanSave)

    end
    
end