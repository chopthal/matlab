% 2021. 08. 20

% easySCAN_v1.1.4 -> easySCAN_v2.0.0

% Don't display time for scanning anymore.


function Img = Get_Snapshot(MainApp, ch)

% global vid src CamName ROIPosition CamInform
global vid src CamName CamInform CurrentChip ChipInform

Progress = [];

while 1

    try

        if src.LineStatusAll == 14

            Img = Snap_Img * 2^4;         

            if ~isempty(Progress)&&isvalid(Progress)

                close(Progress);

            end

            break;

        else

            if isempty(Progress)||~isvalid(Progress)

                Progress = uiprogressdlg(MainApp.figure1,...
                    'Message', 'Reconnecting Camera......', 'Indeterminate', 'on');

            end

%             [cam_err, tmpVid, tmpSrc, vidRes, CamInform] = CamConnect(CamName, ROIPosition);
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

%         [cam_err, tmpVid, tmpSrc, vidRes, CamInform] = CamConnect(CamName, ROIPosition);
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

% startSnap = tic;

global CamInform vid

pause(CamInform.Exp.AdaptTime-toc(CamInform.Exp.Tic));
pause(CamInform.Pos.AdaptTime-toc(CamInform.Pos.Tic));
trigger(vid);
wait(vid, vid.Timeout, 'logging');
Img = getdata(vid);

% timeSnap = toc(startSnap);
% fprintf('Time for Snap = %d\n', timeSnap)

end