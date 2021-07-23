% 2020. 12. 28

% easySCAN_v1.0.0

function isBlock = DetectObj(MainApp)

global cur_Channel Stop_flag Run_flag AF_flag 

isBlock = 0;

Img = Get_Snapshot(MainApp, cur_Channel);

ZImg = zeros(size(Img));
DarkObjImgAll = ~imbinarize(Img, 'adaptive', 'Sensitivity', 0.55, 'ForegroundPolarity', 'dark');
DarkObjImgAll = bwmorph(DarkObjImgAll, 'close', Inf);
DarkObjImg = bwareaopen(DarkObjImgAll, 5);
ConvexImg = bwconvhull(DarkObjImg, 'objects');

while 1
    
    if Stop_flag == 1

        Run_flag = 0;
        AF_flag = 0;
        return

    end

    DarkObjImg = bwareaopen(bwmorph(ConvexImg|DarkObjImgAll, 'close', Inf), 5);
    Stats = regionprops(DarkObjImg, 'Area'); % 추가

%     if isequal(ConvexImg, DarkObjImg)
    if isequal(ConvexImg, DarkObjImg)||(MainApp.HProfile.Mplex.EncodeType{2}.MinSideLth^2<=max(cell2mat({Stats.Area}))) % 변경

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

if Stop_flag == 1

    Run_flag = 0;
    AF_flag = 0;
    return

end

DarkObjImg = bwareaopen(DarkObjImg, MainApp.HProfile.Mplex.EncodeType{2}.MinSideLth^2);
Stats = regionprops(DarkObjImg, 'Circularity');

for ObjNum = 1:length(Stats)

    if Stats(ObjNum).Circularity<0.97

        isBlock = 1;

        break;

    end

end