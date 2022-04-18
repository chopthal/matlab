function Img = Get_Snapshot(MainApp, ch)

global vid src CamName CamInform CurrentChip ChipInform

Progress = [];

while 1

    try

        if src.LineStatusAll == 14

%             Img = Snap_Img * 2^4;         
            Img = Snap_Img;

            if ~isempty(Progress)&&isvalid(Progress)

                close(Progress);

            end

            break;

        else

            if isempty(Progress)||~isvalid(Progress)

                Progress = uiprogressdlg(MainApp.figure1,...
                    'Message', 'Reconnecting Camera......', 'Indeterminate', 'on');

            end

            [cam_err, tmpVid, tmpSrc, vidRes, CamInform] = CamConnect(CamName, ChipInform(CurrentChip).ROI);

            if cam_err == 0

                nBands = get(tmpVid, 'NumberOfBands');
                previewImage = image(zeros(vidRes(2), vidRes(1), nBands), 'parent', MainApp.axes_camera);
                preview(tmpVid, previewImage);

                vid = tmpVid;
                src = tmpSrc;

                Ch_set(MainApp, ch)

            end

        end

    catch

        if isempty(Progress)||~isvalid(Progress)

            Progress = uiprogressdlg(MainApp.figure1,...
                'Message', 'Reconnecting Camera......', 'Indeterminate', 'on');

        end

        [cam_err, tmpVid, tmpSrc, vidRes, CamInform] = CamConnect(CamName, ChipInform(CurrentChip).ROI);
        

        if cam_err == 0

            nBands = get(tmpVid, 'NumberOfBands');
            previewImage = image(zeros(vidRes(2), vidRes(1), nBands), 'parent', MainApp.axes_camera);
            preview(tmpVid, previewImage);

            vid = tmpVid;
            src = tmpSrc;

            Ch_set(MainApp, ch)

        end

    end

    pause(0.05);

end

end



function Img = Snap_Img

    global CamInform vid
    
    pause(CamInform.Exp.AdaptTime-toc(CamInform.Exp.Tic));
    pause(CamInform.Pos.AdaptTime-toc(CamInform.Pos.Tic));
    trigger(vid);
    wait(vid, vid.Timeout, 'logging');
    Img = getdata(vid);

end