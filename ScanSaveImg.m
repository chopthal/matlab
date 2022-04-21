function ScanSaveImg(app, vid, FluorMode, scanCh, savDir, fileNum)

chStr = {'BM' 'FM'};

if length(scanCh) >= 2

    Ch_set(app, 1);
    im = Get_Snapshot(app, 1);   
    
    Ch_set(app, 2)
    savName = sprintf('%d_%s.png', fileNum, chStr{1});    
    pathFile = fullfile(savDir, savName);
    imwrite(im, pathFile)

    im = Get_Snapshot(app, 2);   

    im_colored = uint8(zeros([size(im), 3]));

    if strcmp(FluorMode, 'PE')

        im_colored(:, :, 2) = im;
        im_colored(:, :, 1) = im;

    elseif strcmp(FluorMode, 'FITC')

        im_colored(:, :, 2) = im;

    end

    im = im_colored;

    Ch_set(app, 1)
    savName = sprintf('%d_%s.png', fileNum, chStr{2});    
    pathFile = fullfile(savDir, savName);
    imwrite(im, pathFile)
    
else

    for ch = scanCh

        Ch_set(app, ch);
        im = Get_Snapshot(app, ch);

        if ch~=1

%             im_colored = uint16(zeros([size(im), 3]));
            im_colored = uint8(zeros([size(im), 3]));

            if strcmp(FluorMode, 'PE')

                im_colored(:, :, 2) = im;
                im_colored(:, :, 1) = im;

            elseif strcmp(FluorMode, 'FITC')

                im_colored(:, :, 2) = im;

         end

        im = im_colored;

        end

        savName = sprintf('%d_%s.png', fileNum, chStr{ch});    
        pathFile = fullfile(savDir, savName);
        imwrite(im, pathFile)
    end
    
end