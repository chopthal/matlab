function Make_HProfile(app, EncodeType, CodeImg)
            
    CodeImg = bwmorph(imbinarize(im2gray(CodeImg)), 'thin');
    CodeImg(:, :, 2) = CodeImg;

    for i = 1:size(CodeImg, 1)

        CodeImg(i, :, 2) = CodeImg(end-i+1, :, 1);

    end

    for i = 1:4

        for j = 1:2

            RotCodeImg = imrotate(CodeImg(:, :, j), -90*(i-1));
            [URDL, WH, RSum, CSum, ~, ~] = Calcul_ObjPos(app, RotCodeImg, 0);
            RotCodeImg...
                ((URDL(1, 1)+1):(URDL(3, 1)-1), (URDL(4, 2)+1):(URDL(2, 2)-1)) = 0;
            RotRefImg = RotCodeImg;

            r1 = find(CSum, 1);
            r2 = URDL(1, 1);
            f = find(RotCodeImg(r1, :));
            c1 = f(1);
            c2 = f(end);        

            if r1~=r2

                RotRefImg(1:(r2-3), c1:c2) = 1;

            end

            c1 = URDL(2, 2);
            c2 = length(RSum)-find(RSum(end:-1:1), 1)+1;
            f = find(RotCodeImg(:, c2));
            r1 = f(1);
            r2 = f(end);       

            if c1~=c2

                RotRefImg(r1:r2, (c1+3):end) = 1;

            end

            r1 = URDL(3, 1);
            r2 = length(CSum)-find(CSum(end:-1:1), 1)+1;
            f = find(RotCodeImg(r2, :));
            c1 = f(1);
            c2 = f(end);

            if r1~=r2

                RotRefImg((r1+3):end, c1:c2) = 1;

            end

            c1 = find(RSum, 1);
            c2 = URDL(4, 2);
            f = find(RotCodeImg(:, c1));
            r1 = f(1); 
            r2 = f(end);

            if c1~=c2

                RotRefImg(r1:r2, 1:(c2-3)) = 1;      

            end

            RotRefImg = bwmorph(bwmorph(RotRefImg, 'bridge'), 'fill');
            RotRefImg(URDL(1, 1), :) = 0;
            RotRefImg(:, URDL(2, 2)) = 0;
            RotRefImg(URDL(3, 1), :) = 0;
            RotRefImg(:, URDL(4, 2)) = 0;                    
            app.HProfile.Mplex.EncodeType{EncodeType}.Rot(i).Img(:, :, j)...
                = im2double(RotCodeImg);
            app.HProfile.Mplex.EncodeType{EncodeType}.Rot(i).RefImg(:, :, j)...
                = im2double(RotRefImg);
            app.HProfile.Mplex.EncodeType{EncodeType}.Rot(i).URDL(:, :, j) = URDL;
            app.HProfile.Mplex.EncodeType{EncodeType}.Rot(i).WH(:, :, j) = WH;

        end

    end

end