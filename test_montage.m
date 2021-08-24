savDir = 'D:\Working\Newly(20181129)\Bioroots\Maximultix\Running_SW\easySCAN\easySCAN_Git\24-Aug-2021 15-28-20\Droplet Counting Chip (Bigger)_1';
pathContent = dir(savDir);
imgName = {pathContent(~[pathContent.isdir]).name};
imgNameBM = natsort(imgName(contains(imgName, 'BM')));
imgNameFM = natsort(imgName(contains(imgName, 'FM')));

montageFig = figure('Visible', 'Off');
monBM = montage(fullfile(savDir, imgNameBM), 'Size', flip([13 11]), 'ThumbnailSize', [400, 400]); % [H, W]
imwrite(monBM.CData, fullfile(savDir, 'Stitched_BM.png'))
% cla(montageFig);
% monFM = montage(fullfile(savDir, imgNameFM), 'Size', flip([13 11]));
% imwrite(monFM.CData, fullfile(savDir, 'Stitched_FM.png'))
delete(montageFig);