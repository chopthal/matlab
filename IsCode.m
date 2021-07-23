% 2020. 11. 30

% iMeasy_Multi_v1.0.3 -> iMeasy_Multi_v1.0.6

% use Get_Snapshot for reconnect process.
% Try - catch on using imfindcircles. (2020. 12. 02)
            
function Result = IsCode(app)

%     global vid
    global cur_Channel
    
    BMImg = Get_Snapshot(app, cur_Channel);
%     BMImg = getsnapshot(vid);
%     BMImg = BMImg * 2^4;

    Result = 0;
    EncodeType = 2;
    [BMImgS1, BMImgS2] = size(BMImg);
    ZImg = zeros(BMImgS1, BMImgS2);
    BMImg = im2double(BMImg);
    [GmagCanny, ThrL, ThrH] = Decide_CannyLHThr(app, BMImg, 1.5, 6);
    EdgeImg = edge(BMImg, 'canny', [ThrL/255, ThrH/255]);
    ZZImg = ZImg;                        
    ZZImg(end:(end+2), end:(end+2)) = 0;
    TmpGmag = uint8(ZZImg); 
    TmpGmag(2:(end-1), 2:(end-1)) = GmagCanny;
    TmpEdge = ZZImg;
    TmpEdge(2:(end-1), 2:(end-1)) = EdgeImg;
    EndPnt = bwmorph(TmpEdge, 'endpoints');
    EndPntIdx = find(EndPnt);
    [EndPntR, EndPntC] = ind2sub([BMImgS1+2, BMImgS1+2], EndPntIdx);
    Z5Mat = zeros(5, 5);
    
    for EndPntIdxNun = 1:length(EndPntIdx)
                            
        PntR = EndPntR(EndPntIdxNun);
        PntC = EndPntC(EndPntIdxNun);

        while 1

            EdgeMat = TmpEdge((PntR-1):(PntR+1), (PntC-1):(PntC+1));

            if isempty(find(find(bwmorph(EdgeMat, 'endpoints'))==5, 1))

                break;

            end

            TmpEdgeMat = Z5Mat;
            TmpEdgeMat(2:4, 2:4) = EdgeMat;
            GmagMat = TmpGmag((PntR-1):(PntR+1), (PntC-1):(PntC+1));                                

            for EdgeMatIdxNum = find(EdgeMat)'

                if EdgeMatIdxNum==5

                    continue;

                end            

                [EdgeR, EdgeC] = ind2sub([3, 3], EdgeMatIdxNum);
                EdgeR = EdgeR+1;
                EdgeC = EdgeC+1;
                TmpEdgeMat((EdgeR-1):(EdgeR+1), EdgeC) = 1;
                TmpEdgeMat(EdgeR, (EdgeC-1):(EdgeC+1)) = 1;

            end

            TmpEdgeMat = TmpEdgeMat(2:4, 2:4);
            TmpGmagMat = GmagMat.*uint8(~TmpEdgeMat);
            [SortGmagVal, SortGmagIdx] = sort(TmpGmagMat(:), 'descend');

            if SortGmagVal(1)<ThrL

                break;

            end

            for SortGmagValNun = 1:length(SortGmagVal)

                if SortGmagVal(SortGmagValNun)~=SortGmagVal(1)

                    break;

                end

            end

            EqNum = SortGmagValNun-1; 

            if EqNum==1

                [GmagMatMaxR, GmagMatMaxC] = ind2sub([3, 3], SortGmagIdx(1));

            else

                [DirR, DirC] = ind2sub([3, 3], find(~TmpEdgeMat));
                DirR = mean(DirR);
                DirC = mean(DirC);
                [GmagMatMaxR, GmagMatMaxC] = ind2sub([3, 3], SortGmagIdx(1:EqNum));
                GmagMatMaxDir = ((GmagMatMaxR-DirR).^2+(GmagMatMaxC-DirC).^2).^0.5;
                [~, GmagMatMaxIdx] = min(GmagMatMaxDir);
                GmagMatMaxR = GmagMatMaxR(GmagMatMaxIdx);
                GmagMatMaxC = GmagMatMaxC(GmagMatMaxIdx);

            end

            PntR = PntR+GmagMatMaxR-2;
            PntC = PntC+GmagMatMaxC-2;
            TmpEdge(PntR, PntC) = 1;

        end

    end
    
    EdgeImg = bwmorph(bwmorph(TmpEdge(2:(end-1), 2:(end-1)), 'thin', Inf), 'diag');
    FillImg = imfill(EdgeImg, 'holes');    
    BMBg = mean(Remove_Outlier(app, BMImg(FillImg==0)));                        
    FillImg = bwareaopen(FillImg, app.HProfile.Mplex.EncodeType{EncodeType}.MinSideLth^2);
    CC = bwconncomp(FillImg);
    FillImg = 0<(FillImg-EdgeImg);
    
    for ObjNum = 1:CC.NumObjects
                            
        ObjInten = BMImg(CC.PixelIdxList{1, ObjNum});
        OtsuThrVal = double(multithresh(ObjInten, 2));

        if isempty(find(OtsuThrVal<BMBg, 1))

            BgThr = BMBg;

        else

            BgThr = OtsuThrVal(1);

        end

        TmpFillImg = ZImg;
        TmpFillImg(CC.PixelIdxList{1, ObjNum}) = 1;
        TmpFillImg = TmpFillImg.*FillImg;
        FillImgCC = bwconncomp(TmpFillImg, 4);

        for SegNum = 1:FillImgCC.NumObjects

            if mean(BMImg(FillImgCC.PixelIdxList{1, SegNum}))<BgThr

                FillImg(FillImgCC.PixelIdxList{1, SegNum}) = 0;                        

            end

        end

    end

    FillImg = bwmorph(imfill(bwmorph(FillImg, 'close', Inf), 'holes'), 'open', Inf);
    FillImg = bwareaopen(FillImg, app.HProfile.Mplex.EncodeType{EncodeType}.MinSideLth^2);
    CC = bwconncomp(FillImg);
    FillImg = ZImg;
    
    for ObjNum = 1:CC.NumObjects
                            
        ObjFill = ZImg;    
        ObjFill(CC.PixelIdxList{1, ObjNum}) = 1;
        ObjEdge = bwmorph(ObjFill, 'remove');
        ObjDisassem = ObjFill.*~ObjEdge;                            
        ObjCC = bwconncomp(ObjDisassem, 4);

        if ObjCC.NumObjects==1

            FillImg(CC.PixelIdxList{1, ObjNum}) = 1;                                
            continue;

        end

        LengthArray = zeros(1, ObjCC.NumObjects);

        for ConnObjNum = 1:ObjCC.NumObjects

            LengthArray(ConnObjNum) = length(ObjCC.PixelIdxList{1, ConnObjNum});

        end

        [~, MaxIdx] = max(LengthArray);

        ObjFill = ObjEdge;
        ObjFill(ObjCC.PixelIdxList{1, MaxIdx}) = 1;
        ObjFill = bwmorph(ObjFill, 'open', Inf);
        FillImg = FillImg+ObjFill;

    end
    
    CC = bwconncomp(FillImg);
        
    for ObjNum = 1:CC.NumObjects
        
        ObjFillImg = ZImg;
        ObjFillImg(CC.PixelIdxList{1, ObjNum}) = 1;
        IsAngInv = 0;
        InvAngYDir = -1;
        [R1, C1] = ind2sub([BMImgS1, BMImgS2], CC.PixelIdxList{1, ObjNum}(1));
        EdgeSub = bwtraceboundary(ObjFillImg, [R1, C1], 'E');
        AngleLth = size(EdgeSub, 1)-1;
        RawAngle = zeros(1, AngleLth);
        Angle = RawAngle;
        
        for AngleNum = 1:AngleLth

            dX = EdgeSub(AngleNum+1, 2)-EdgeSub(AngleNum, 2);
            dY = EdgeSub(AngleNum+1, 1)-EdgeSub(AngleNum, 1);

            if 0<dX

                IsAngInv = 0; 

            elseif dX<0

                IsAngInv = 1;

            end

            if 0<dY

                InvAngYDir = 1;

            elseif dY<0

                InvAngYDir = -1;

            end   

            if 0<dX

                RawAngle(AngleNum) = atan(dY/dX);

            elseif dX<0

                if dY~=0                                   

                    RawAngle(AngleNum) = atan(-1*(dX/dY));

                else

                    RawAngle(AngleNum) = atan(-1*(dX/dY))*InvAngYDir;    

                end

            else

                if IsAngInv==0

                    RawAngle(AngleNum) = atan(dY/dX);        

                else

                    RawAngle(AngleNum) = 0;

                end

            end

        end
        
        EdgeSub(end, :) = [];
        EdgeIdx = sub2ind([BMImgS1, BMImgS2], EdgeSub(:, 1), EdgeSub(:, 2));

        for EdgeIdxNum = 2:(length(EdgeIdx)-1)

            Angle(EdgeIdxNum) = mean(RawAngle((EdgeIdxNum-1):(EdgeIdxNum+1)));

        end
        
        Angle(EdgeIdxNum+1) = mean([RawAngle(EdgeIdxNum), RawAngle(EdgeIdxNum+1), RawAngle(1)]);
        Angle(1) = mean([RawAngle(EdgeIdxNum+1), RawAngle(1), RawAngle(2)]);
        TiltAng = zeros(1, 8);
        TiltAng(1) = mean(Angle((0<=Angle)&(Angle<=(pi/2))));
        TiltAng(2) = mean(Angle(((pi/12)<=Angle)&(Angle<=(pi/2))));
        TiltAng(3) = mean(Angle(((-pi/2)<=Angle)&(Angle<=0)));
        TiltAng(4) = mean(Angle(((-pi/2)<=Angle)&(Angle<=(-pi/12))));
        UpperMod1 = mode(Angle(0<=Angle));
        UpperMod2 = mode(Angle(0<Angle));
        LowerMod1 = mode(Angle(Angle<=0));
        LowerMod2 = mode(Angle(Angle<0));
        TiltAng(5) = mean(...
            Angle(((UpperMod1-pi/12)<=Angle)&(Angle<=(UpperMod1+pi/12))));
        TiltAng(6) = mean(...
            Angle(((UpperMod2-pi/12)<=Angle)&(Angle<=(UpperMod2+pi/12))));
        TiltAng(7) = mean(...
            Angle(((LowerMod1-pi/12)<=Angle)&(Angle<=(LowerMod1+pi/12))));
        TiltAng(8) = mean(...
            Angle(((LowerMod2-pi/12)<=Angle)&(Angle<=(LowerMod2+pi/12))));
        TiltAng(isnan(TiltAng)) = [];
        TiltAngLth = length(TiltAng);
        MatchScore = zeros(1, TiltAngLth);
        ObjEdgeImg = ZImg;
        ObjEdgeImg(EdgeIdx) = 1;
        ObjU = min(EdgeSub(:, 1));
        ObjD = max(EdgeSub(:, 1));
        ObjL = min(EdgeSub(:, 2));
        ObjR = max(EdgeSub(:, 2));
        ObjEdge = ObjEdgeImg(ObjU:ObjD, ObjL:ObjR);
        TmpRotObjEdge = cell(1, TiltAngLth);
        TmpRotObjURDL = TmpRotObjEdge;
        TmpRotObjWH = TmpRotObjEdge;
        
        for AngNum = 1:TiltAngLth

            RotObjEdge = imrotate(ObjEdge, TiltAng(AngNum)*180/pi, 'bilinear');                                
            [RotObjURDL, RotObjWH, ~, ~, RotObjWPeak, RotObjHPeak] = Calcul_ObjPos(app, RotObjEdge, 1);
            MatchScore(AngNum) = mean([RotObjWPeak, RotObjHPeak]);                                    
            TmpRotObjEdge{AngNum} = RotObjEdge;
            TmpRotObjURDL{AngNum} = RotObjURDL;
            TmpRotObjWH{AngNum} = RotObjWH;

        end
        
        [~, MaxInd] = max(MatchScore);
        TiltAng = TiltAng(MaxInd);
        RotObjEdge = TmpRotObjEdge{MaxInd};
        RotObjURDL = TmpRotObjURDL{MaxInd};
        RotObjWH = TmpRotObjWH{MaxInd};
        
        if (RotObjWH(1)<app.HProfile.Mplex.EncodeType{EncodeType}.MinSideLth)||...
                (RotObjWH(2)<app.HProfile.Mplex.EncodeType{EncodeType}.MinSideLth)||...
                ((10/9)<(RotObjWH(1)/RotObjWH(2)))||((RotObjWH(1)/RotObjWH(2))<(9/10))

            continue;

        end
        
        [RotObjS1, RotObjS2] = size(RotObjEdge);
        MatchScore = zeros(2, 4);

        for Side = 1:4

            CodeSize = size(app.HProfile.Mplex.EncodeType{EncodeType}.Rot(Side).RefImg);
            WRatio = app.HProfile.Mplex.EncodeType{EncodeType}.Rot(Side).WH(1, 1, 1)/RotObjWH(1);
            HRatio = app.HProfile.Mplex.EncodeType{EncodeType}.Rot(Side).WH(1, 2, 1)/RotObjWH(2);                                

            for Inv = 1:2

                RefImg = imresize(app.HProfile.Mplex.EncodeType{EncodeType}.Rot(Side).RefImg(:, :, Inv),...
                    round([CodeSize(1)/HRatio, CodeSize(2)/WRatio]));
                RefURDL = app.HProfile.Mplex.EncodeType{EncodeType}.Rot(Side).URDL(:, :, Inv);
                RefURDL(:, 1) = round(RefURDL(:, 1)/HRatio);
                RefURDL(:, 2) = round(RefURDL(:, 2)/WRatio);

                if RefURDL(1, 1)<RotObjURDL(1, 1)

                    d = RotObjURDL(1, 1)-RefURDL(1, 1);                                        
                    RefImg((1+d):(end+d), :) = RefImg;
                    RefImg(1:d, :) = 0;

                elseif RotObjURDL(1, 1)<RefURDL(1, 1)

                    d = RefURDL(1, 1)-RotObjURDL(1, 1);                                        
                    RefImg(1:d, :) = [];

                end

                if size(RefImg, 1)<RotObjS1

                    RefImg((end+1):RotObjS1, :) = 0;

                elseif RotObjS1<size(RefImg, 1)

                    RefImg((RotObjS1+1):end, :) = [];

                end

                if RefURDL(4, 2)<RotObjURDL(4, 2)

                    d = RotObjURDL(4, 2)-RefURDL(4, 2);                                        
                    RefImg(:, (1+d):(end+d)) = RefImg;
                    RefImg(:, 1:d) = 0;

                elseif RotObjURDL(4, 2)<RefURDL(4, 2)

                    d = RefURDL(4, 2)-RotObjURDL(4, 2);                                        
                    RefImg(:, 1:d) = [];

                end

                if size(RefImg, 2)<RotObjS2

                    RefImg(:, (end+1):RotObjS2) = 0;

                elseif RotObjS2<size(RefImg, 2)

                    RefImg(:, (RotObjS2+1):end) = [];

                end           

                RefImg = imbinarize(RefImg);        
                MatchScore(Inv, Side) = sum(sum(imbinarize(RotObjEdge).*RefImg));

            end

        end

        [MaxVal, MaxInd] = max(MatchScore(:));
        FindMaxVal = find(MatchScore==MaxVal);

        if (MaxVal==0)||(1<length(FindMaxVal))

            continue;

        end
        
        [Inv, RefPos] = ind2sub(size(MatchScore), MaxInd);
        CodeSize = size(app.HProfile.Mplex.EncodeType{EncodeType}.Rot(RefPos).Img);
        WRatio = app.HProfile.Mplex.EncodeType{EncodeType}.Rot(RefPos).WH(1, 1, 1)/RotObjWH(1);                                
        HRatio = app.HProfile.Mplex.EncodeType{EncodeType}.Rot(RefPos).WH(1, 2, 1)/RotObjWH(2);                                
        CodeImg = imresize(app.HProfile.Mplex.EncodeType{EncodeType}.Rot(RefPos).Img(:, :, Inv),...
            round([CodeSize(1)/HRatio, CodeSize(2)/WRatio]));
        CodeURDL = app.HProfile.Mplex.EncodeType{EncodeType}.Rot(RefPos).URDL(:, :, Inv);
        CodeURDL(:, 1) = round(CodeURDL(:, 1)/HRatio);
        CodeURDL(:, 2) = round(CodeURDL(:, 2)/WRatio);

        if CodeURDL(1, 1)<RotObjURDL(1, 1)

            d = RotObjURDL(1, 1)-CodeURDL(1, 1);                            
            CodeImg((1+d):(end+d), :) = CodeImg;
            CodeImg(1:d, :) = 0;

        elseif RotObjURDL(1, 1)<CodeURDL(1, 1)

            d = CodeURDL(1, 1)-RotObjURDL(1, 1);                            
            CodeImg(1:d, :) = [];

        end

        if size(CodeImg, 1)<RotObjS1

            CodeImg((end+1):RotObjS1, :) = 0;

        elseif RotObjS1<size(CodeImg, 1)

            CodeImg((RotObjS1+1):end, :) = [];

        end

        if CodeURDL(4, 2)<RotObjURDL(4, 2)

            d = RotObjURDL(4, 2)-CodeURDL(4, 2);                            
            CodeImg(:, (1+d):(end+d)) = CodeImg;
            CodeImg(:, 1:d) = 0;

        elseif RotObjURDL(4, 2)<CodeURDL(4, 2)

            d = CodeURDL(4, 2)-RotObjURDL(4, 2);                            
            CodeImg(:, 1:d) = [];

        end

        if size(CodeImg, 2)<RotObjS2

            CodeImg(:, (end+1):RotObjS2) = 0;

        elseif RotObjS2<size(CodeImg, 2)

            CodeImg(:, (RotObjS2+1):end) = [];

        end           

        NZ = find(0.5<=CodeImg(1, :));

        if ~isempty(NZ)

            CodeImg(1, NZ(1):NZ(end)) = 1;

        end

        NZ = find(0.5<=CodeImg(end, :));

        if ~isempty(NZ)

            CodeImg(end, NZ(1):NZ(end)) = 1;

        end

        NZ = find(0.5<=CodeImg(:, 1));

        if ~isempty(NZ)

            CodeImg(NZ(1):NZ(end), 1) = 1;

        end

        NZ = find(0.5<=CodeImg(:, end));

        if ~isempty(NZ)

            CodeImg(NZ(1):NZ(end), end) = 1;

        end
        
        RevCodeImg = bwmorph(imbinarize(imrotate(CodeImg, -TiltAng*180/pi, 'bilinear')), 'thin');                            
        RevCodeSize = size(RevCodeImg);
        dRow = round(mean([ObjU, ObjD])-RevCodeSize(1)/2);
        dCol = round(mean([ObjL, ObjR])-RevCodeSize(2)/2);                            
        [RevCodeRowSub, RevCodeColSub] = ind2sub(RevCodeSize, find(RevCodeImg));
        EdgeSub = [];
        EdgeSub(:, 1) = RevCodeRowSub+dRow;
        EdgeSub(:, 2) = RevCodeColSub+dCol;
        EdgeSub((EdgeSub(:, 1)<1), :) = [];
        EdgeSub((BMImgS1<EdgeSub(:, 1)), :) = [];
        EdgeSub((EdgeSub(:, 2)<1), :) = [];
        EdgeSub((BMImgS2<EdgeSub(:, 2)), :) = [];                            
        ObjEdgeImg = ZImg;
        ObjEdgeImg(sub2ind([BMImgS1, BMImgS2], EdgeSub(:, 1), EdgeSub(:, 2))) = 1;
        ObjU = min(EdgeSub(:, 1));
        ObjD = max(EdgeSub(:, 1));
        ObjL = min(EdgeSub(:, 2));
        ObjR = max(EdgeSub(:, 2));
        ObjEdge = ObjEdgeImg(ObjU:ObjD, ObjL:ObjR);
        RotAng = (TiltAng*180/pi)+((RefPos-1)*90);
        RotObjEdge = imrotate(ObjEdge, RotAng, 'bilinear');
        [RotObjURDL, RotObjWH, ~, ~, ~, ~] = Calcul_ObjPos(app, RotObjEdge, 0);
        RotObjGray = BMImg(ObjU:ObjD, ObjL:ObjR);
        RotObjGray = imrotate(RotObjGray, RotAng, 'bilinear');
        RotObjGray = RotObjGray(RotObjURDL(1, 1):RotObjURDL(3, 1), RotObjURDL(4, 2):RotObjURDL(2, 2));
        TR = round((RotObjWH(2)+1)*app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.RectEdge);
        TC = round((RotObjWH(1)+1)*app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.RectEdge);
        RotObjGray = RotObjGray((1+TR):(end-TR), (1+TC):(end-TC));
        RotObjGraySize = size(RotObjGray);
        
        if Inv==2
    
            TmpRotObjGray = RotObjGray;                               

            for RowNum = 1:RotObjGraySize(1)

                TmpRotObjGray((end-RowNum+1), :) = RotObjGray(RowNum, :);

            end

            RotObjGray = TmpRotObjGray;

        end
        
        [dx, dy] = smoothGradient(RotObjGray, 2^0.5);
        Gmag = hypot(dx, dy);
        Gmag = Gmag/max(Gmag(:));
        [~, GmagLThr, GmagHThr] = Decide_CannyLHThr(app, Gmag, 1.5, 3);
        GmagHProc = imbinarize(Gmag, GmagHThr/255);
        GmagLProc = imbinarize(Gmag, GmagLThr/255);
        GmagHLProc = GmagHProc+GmagLProc;
        GCC = bwconncomp(GmagHLProc);
        
        for GCCObjNum = 1:GCC.NumObjects
                                
            if isempty(find(GmagHLProc(GCC.PixelIdxList{1, GCCObjNum})==2, 1))

                GmagHLProc(GCC.PixelIdxList{1, GCCObjNum}) = 0;

            end

        end
        
        GmagProc = Gmag;
        GmagProc(GmagHLProc==0) = 0;
        SectUDLR = zeros(app.HProfile.Mplex.EncodeType{EncodeType}.NumCircle, 4);
        LinspaceS1 = linspace(1, RotObjGraySize(1), EncodeType+1);
        LinspaceS2 = linspace(1, RotObjGraySize(2), EncodeType+1);
        LinspaceS1Rnd = round(LinspaceS1);
        LinspaceS2Rnd = round(LinspaceS2);
        SectNum = 1;
        
        for ColNum = 1:EncodeType
       
            for RowNum = 1:EncodeType

                SectUDLR(SectNum, 1) = LinspaceS1Rnd(RowNum);
                SectUDLR(SectNum, 2) = LinspaceS1Rnd(RowNum+1);
                SectUDLR(SectNum, 3) = LinspaceS2Rnd(ColNum);
                SectUDLR(SectNum, 4) = LinspaceS2Rnd(ColNum+1);
                SectNum = SectNum+1;

            end

        end
        
        CodeMatrix = 0;
        
        for CircleNum = 1:app.HProfile.Mplex.EncodeType{EncodeType}.NumCircle

            SectGmagProc = GmagProc(SectUDLR(CircleNum, 1):SectUDLR(CircleNum, 2),...
                SectUDLR(CircleNum, 3):SectUDLR(CircleNum, 4));
            SectGmagS1 = SectUDLR(CircleNum, 2)-SectUDLR(CircleNum, 1)+1;
            SectGmagS2 = SectUDLR(CircleNum, 4)-SectUDLR(CircleNum, 3)+1;
            TS1 = round(SectGmagS1*app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.SectEdge);
            TS2 = round(SectGmagS2*app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.SectEdge);
            SectGmagProc(1:TS1, :) = 0;
            SectGmagProc((end-TS1+1):end, :) = 0;
            SectGmagProc(:, 1:TS2) = 0;
            SectGmagProc(:, (end-TS2+1)) = 0;
            TS1 = round(SectGmagS1*app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.SectCorner);
            TS2 = round(SectGmagS2*app.HProfile.Mplex.EncodeType{EncodeType}.RemoveR.SectCorner);
            SectGmagProc(1:TS1, 1:TS2) = 0;
            SectGmagProc(1:TS1, (end-TS2+1):end) = 0;
            SectGmagProc((end-TS1+1):end, 1:TS2) = 0;
            SectGmagProc((end-TS1+1):end, (end-TS2+1):end) = 0;
            SectGmagSMin = min([SectGmagS1, SectGmagS2]);
            MaxR = floor(SectGmagSMin/2);

            if MaxR<6

                continue;

            end

            MinR = ceil(MaxR/2);

            if MinR<6

                MinR = 6;

            end
            
%             [Centers, Radii, Metric] = imfindcircles(SectGmagProc, [MinR, MaxR],...
%                     'Method', 'TwoStage', 'Sensitivity', 1, 'EdgeThreshold', 0);
            
            try

                [Centers, Radii, Metric] = imfindcircles(SectGmagProc, [MinR, MaxR],...
                    'Method', 'TwoStage', 'Sensitivity', 1, 'EdgeThreshold', 0);
                
            catch
                
                continue;
                
            end

            if isempty(Metric)||(Metric(1)<0.4)

                continue;

            end

            Center = Centers(1, :);
            Rad = Radii(1);

            if ((Center(1)-Rad)<1)||(SectGmagSMin<(Center(1)+Rad))||...
                    ((Center(2)-Rad)<1)||(SectGmagSMin<(Center(2)+Rad))

                continue;

            end
            
            CodeMatrix = CodeMatrix*10+CircleNum;

        end
        
        Code = find(CodeMatrix==app.HProfile.Mplex.EncodeType{EncodeType}.CodeMatrix, 1);

        if isempty(Code)

            continue;
            
        else
            
            Result = Code;
            break;

        end
        
    end

end


function [GmagCanny, ThrL, ThrH] = Decide_CannyLHThr(app, Img, SigmaL, SigmaH)
            
    [dx, dy] = smoothGradient(Img, 2^0.5);
    GmagCanny = hypot(dx, dy);
    GmagCanny = im2uint8(GmagCanny/max(GmagCanny(:)));            
    HData = imhist(GmagCanny);
    Lth_HData = length(HData);
    [HDataMaxVal, HDataMaxIdx] = max(HData);
    app.Fit.Gauss.Opt.Lower = [0, HDataMaxIdx, 0];
    app.Fit.Gauss.Opt.StartPoint =...
        [HDataMaxVal, HDataMaxIdx, std(double(GmagCanny(:)))*2^0.5];            
    FitResult = fit...
        ((HDataMaxIdx:Lth_HData)', HData(HDataMaxIdx:Lth_HData),...
        app.Fit.Gauss.Type, app.Fit.Gauss.Opt);
    Avg = FitResult.b1-1;
    Std = FitResult.c1/(2^0.5);
    ThrL = Decide_CannyThr(app, Avg, Std, SigmaL);
    ThrH = Decide_CannyThr(app, Avg, Std, SigmaH);

    if ThrL==ThrH  

        if ThrL==1

            ThrH = 2;        

        elseif ThrH==254

            ThrL = 253;

        else       

            ThrL = ThrL-1;

        end

    elseif ThrH<ThrL

        ThrTemp = ThrH;
        ThrH = ThrL;
        ThrL = ThrTemp;

    end

end

function Thr = Decide_CannyThr(~, Avg, Std, Sigma)

    Thr = Avg+Std*Sigma;

    if Thr<=0

        Thr = 1;

    elseif 255<=Thr

        Thr = 254;

    end

end    

function Data = Remove_Outlier(~, Data)
            
    Data = rmoutliers(Data, 'median', 'ThresholdFactor', 1.5);

end
