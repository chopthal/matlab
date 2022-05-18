clear
close all

% folderName = 'D:\Users\user\Desktop\Cell image\10-Feb-2022 13-43-06\Grp1-U1(1)';
% folderName = 'D:\Users\user\Desktop\Cell image\Cell image\4X mix';
folderName = 'D:\Users\user\Desktop\Cell image\Cell image\20X mix';
listDir = dir(folderName);
nameList = {listDir.name};
listFile = nameList([listDir.isdir] == 0);
listFM = listFile(contains(listFile, 'BM'));

radiusRange = [10 20];

img = cell(length(listFM), 1);
for i = 1:length(listFM)    
    img{i} = imread(fullfile(folderName, listFM{i}));

    figure(i); imshow(img{i});

    [centers,radii] = imfindcircles(img{i}, radiusRange,...
    'ObjectPolarity', 'bright',...
    'Sensitivity', 0.95, ...
    'EdgeThreshold', 0.06);

    viscircles(centers, radii+1, 'Color', 'Red');

    fprintf('Img name : %s / circles : %d\n', listFM{i}, size(centers, 1))

    if i == 3
        break;
    end
end