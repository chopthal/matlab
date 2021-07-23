% 2020. 12. 15

% iMeasy_Multi_v1.0.3 -> easySCAN_v1.0.0

% 

function [isBlock, coorBlock] = SearchBlock(app, refZ)

global Z_abs_um Stop_flag ROIPosition lensMag lensMagDefault Run_flag AF_flag AFRange

isCand = 0;
isBlock = 0;
coorBlock = refZ;
% findInt = AFRange/2; % um
findInt = AFRange/2; % um
blkThr = app.HProfile.Mplex.EncodeType{2}.MinSideLth * 4 * lensMag/lensMagDefault;
lenIdxList = 0;

% candCoor = [refZ - findInt, refZ, refZ + findInt];
candCoor = [refZ - findInt*2, refZ - findInt, refZ, refZ + findInt, refZ + findInt * 2];

% resultPreAF = zeros(3, 2);
resultPreAF = zeros(3, 3);

% for ii = 1:3
for ii = 1:size(candCoor, 2)

    if Z_abs_um > candCoor(ii)

        Stage_Control(app, 'Z', 'F', Z_abs_um - candCoor(ii))

    else

        Stage_Control(app, 'Z', 'B', candCoor(ii) - Z_abs_um)

    end

%     [~, Find_Gmag] = getImgHist(app);   
    [GData, Find_Gmag] = getImgHist(app);   

    Z = zeros(ROIPosition(4), ROIPosition(3));
    Z(Find_Gmag) = 1;
    CC = bwconncomp(Z);    

    for i = 1:CC.NumObjects

        if Stop_flag == 1

            Run_flag = 0;
            AF_flag = 0;
            return

        end
        
        lenIdxList(i, 1) = length(CC.PixelIdxList{i});

        if blkThr<length(CC.PixelIdxList{i})

            isCand = 1;

            break;

        end

    end

    if isCand == 1

%         resultPreAF(ii, :) = PreAFgetImgHist(app);
        resultPreAF(ii, :) = GData;

    end

end

if Stop_flag == 1

    Run_flag = 0;
    AF_flag = 0;            
    return

end

% [maxRes, maxResIdx] = max(resultPreAF(:, 1));
[maxRes, maxResIdx] = max(resultPreAF(:, 2));
% coorBlock = resultPreAF(maxResIdx, 2);
coorBlock = resultPreAF(maxResIdx, 3);

if maxRes ~= 0

    isBlock = 1;

end