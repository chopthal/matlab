function [URDL, WH, RSum, CSum, WPeak, HPeak] = Calcul_ObjPos(~, Img, Span)
            
    URDL = zeros(4, 2);
    WH = zeros(1, 2);
    WPeak = zeros(1, 2);
    HPeak = zeros(1, 2);

    TmpRSum = sum(Img, 1);
    RSum = TmpRSum;

    for i = 2:(length(TmpRSum)-1)

        if TmpRSum(i)~=0

            RSum(i) = sum(TmpRSum((i-Span):(i+Span)));

        end

    end

    TmpCSum = sum(Img, 2);
    CSum = TmpCSum;

    for i = 2:(length(TmpCSum)-1)

        if TmpCSum(i)~=0

            CSum(i) = sum(TmpCSum((i-Span):(i+Span)));

        end

    end

    [WPeak(1), RSumMaxIdx(1)] = max(RSum(1:floor(length(RSum)/2))); 
    [WPeak(2), RSumMaxIdx(2)] = max(RSum(end:-1:ceil(length(RSum)/2))); 
    RSumMaxIdx(2) = length(RSum)-RSumMaxIdx(2)+1;
    RSumMaxIdx(3) = round(mean([RSumMaxIdx(1), RSumMaxIdx(2)]));                        
    [HPeak(1), CSumMaxIdx(1)] = max(CSum(1:floor(length(CSum)/2))); 
    [HPeak(2), CSumMaxIdx(2)] = max(CSum(end:-1:ceil(length(CSum)/2))); 
    CSumMaxIdx(2) = length(CSum)-CSumMaxIdx(2)+1;
    CSumMaxIdx(3) = round(mean([CSumMaxIdx(1), CSumMaxIdx(2)]));            
    URDL(1, :) = [CSumMaxIdx(1), RSumMaxIdx(3)];
    URDL(2, :) = [CSumMaxIdx(3), RSumMaxIdx(2)];
    URDL(3, :) = [CSumMaxIdx(2), RSumMaxIdx(3)];
    URDL(4, :) = [CSumMaxIdx(3), RSumMaxIdx(1)];                        
    WH(1, 1) = RSumMaxIdx(2)-RSumMaxIdx(1);
    WH(1, 2) = CSumMaxIdx(2)-CSumMaxIdx(1);

end