MinSideLth = 150;

isBlock = 0;

imgFile = 'D:\Users\user\Desktop\20210209_판별샘플\Noise\20.png';
img = imread(imgFile);

ZImg = zeros(size(img));
DarkObjImgAll = ~imbinarize(img, 'adaptive', 'Sensitivity', 0.55, 'ForegroundPolarity', 'dark');
DarkObjImgAll = bwmorph(DarkObjImgAll, 'close', Inf);
DarkObjImg = bwareaopen(DarkObjImgAll, 5);
ConvexImg = bwconvhull(DarkObjImg, 'objects');

while 1    

    DarkObjImg = bwareaopen(bwmorph(ConvexImg|DarkObjImgAll, 'close', Inf), 5);
    Stats = regionprops(DarkObjImg, 'Area'); % 추가

    if isequal(ConvexImg, DarkObjImg)||(MinSideLth^2<=max(cell2mat({Stats.Area}))) % 변경

        break;

    end

    SumImg = DarkObjImg+ConvexImg;
    CC = bwconncomp(SumImg);
    PixelIdx = [];

    for ObjNum = 1:CC.NumObjects

        if (length(CC.PixelIdxList{ObjNum})*2)~=sum(SumImg(CC.PixelIdxList{ObjNum}))

            PixelIdx = [PixelIdx; CC.PixelIdxList{ObjNum}];

        end

    end

    ObjImg = ZImg;
    ObjImg(PixelIdx) = 1;
    ConvexImg = ConvexImg|bwconvhull(ObjImg, 'objects');

end

DarkObjImg = bwareaopen(DarkObjImg, MinSideLth^2);
Stats = regionprops(DarkObjImg, 'Circularity');

for ObjNum = 1:length(Stats)

    if Stats(ObjNum).Circularity<0.97

        isBlock = 1;

        break;

    end

end

disp(isBlock)