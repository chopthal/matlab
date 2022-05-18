clear
close all

folderName = 'D:\Users\user\Desktop\Cell image\10-Feb-2022 13-43-06\Grp1-U1(1)'; % 20X
% folderName = 'D:\Users\user\Desktop\Cell image\Cell image\4X mix'; % 4X
listDir = dir(folderName);
nameList = {listDir.name};
listFile = nameList([listDir.isdir] == 0);
listFM = listFile(contains(listFile, 'FM'));

img = cell(length(listFM), 1);

for i = 1:length(listFM)    
    img{i} = imread(fullfile(folderName, listFM{i}));
    figure(i); subplot(1, 2, 1); imshow(img{i});
    try     
        img{i} = rgb2gray(img{i});        
    end

    % Image Brightness   
    img{i} = img{i} - mean(img{i}, 'all');
    

%     WBC_Min = 5; WBC_Max = 50;
    WBC_Min = 100; WBC_Max = 2000;
    MalScan_WBC_Thr = 0.05;

    BW = imbinarize(medfilt2(img{i}), MalScan_WBC_Thr);
    figure(i); subplot(1, 2, 2); imshow(BW);
    label = bwlabel(BW);
    stats = regionprops(BW, 'Area');
    idx = find([stats.Area]>WBC_Min&[stats.Area]<WBC_Max);
    BW2 = ismember(label, idx);
    stats2 = regionprops(BW2, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
    centers = cat(1, stats2.Centroid);
    MajorAxisLength = cat(1, stats2.MajorAxisLength);
    MinorAxisLength = cat(1, stats2.MinorAxisLength);
    diameters = mean([MajorAxisLength, MinorAxisLength], 2);
    radii = diameters/2;
    numbers = length(radii);

    viscircles(centers, radii+1, 'Color', 'Red');

    fprintf('Img name : %s / circles : %d\n', listFM{i}, numbers)

end