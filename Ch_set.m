% 2021. 08. 20

% easySCAN_v1.1.4 -> easySCAN_v2.0.0

% 


function Ch_set(app, ch)

% startChSet = tic;

% global src Run_flag cur_Channel Z_abs_um vid CamName ROIPosition
global src Run_flag cur_Channel Z_abs_um vid CamName CurrentChip ChipInform

prev_ch = cur_Channel;
cur_Channel = ch;

if (prev_ch == 1) && (cur_Channel == 2)

    tmp_um = Z_abs_um - get(app.edit_Z_diff, 'Value');

elseif (prev_ch == 2) && (cur_Channel == 1)

    tmp_um = Z_abs_um + get(app.edit_Z_diff, 'Value');

else

    tmp_um = Z_abs_um;   

end

if Z_abs_um < tmp_um

    tmp_dir =  'B';
    tmp_inq_um = tmp_um - Z_abs_um;
    Stage_Control(app, 'Z', tmp_dir, tmp_inq_um);


elseif Z_abs_um > tmp_um

    tmp_dir = 'F';
    tmp_inq_um = Z_abs_um - tmp_um;
    Stage_Control(app, 'Z', tmp_dir, tmp_inq_um);

end

eval(sprintf('global Ch%d_Exp;', ch));
eval(sprintf('global Ch%d_Gamma;', ch));
eval(sprintf('global Ch%d_Gain;', ch));
eval(sprintf('global Ch%d_Inten;', ch));
eval(sprintf('global Ch%d_Colormap;', ch));

eval(sprintf('Ch_Exp = Ch%d_Exp;', ch));
eval(sprintf('Ch_Gamma = Ch%d_Gamma;', ch));
eval(sprintf('Ch_Gain = Ch%d_Gain;', ch));
eval(sprintf('Ch_Inten = Ch%d_Inten;', ch));
eval(sprintf('Ch_Colormap = Ch%d_Colormap;', ch));

set(app.slider_Exp, 'Value', Ch_Exp);
set(app.edit_Exp, 'Value', Ch_Exp);

set(app.slider_Gamma, 'Value', Ch_Gamma);
set(app.edit_Gamma, 'Value', Ch_Gamma);

set(app.slider_Gain, 'Value', Ch_Gain);
set(app.edit_Gain, 'Value', Ch_Gain);

set(app.slider_Inten, 'Value', Ch_Inten);
set(app.edit_Inten, 'Value', Ch_Inten);

txStr = sprintf('$L#%d#ON#%d', ch, Ch_Inten);
rxStr = strcat(txStr, '#OK');
[~] = comm2port(app, 'Main_port', txStr, rxStr);
set(app.axes_camera, 'Colormap', Ch_Colormap);

Progress = [];

while 1

    try

        if src.LineStatusAll == 14

            if Ch_Gamma == 4

                src.Gamma = 3.99;

            else

                src.Gamma = Ch_Gamma;

            end

            src.Gain = Ch_Gain;
            src.ExposureTime = Ch_Exp * 1000; % ms -> us
            Apply_CamExp

            if ~isempty(Progress)&&isvalid(Progress)

                close(Progress);

            end

            break

        else

            if isempty(Progress)||~isvalid(Progress)

                Progress = uiprogressdlg(app.figure1,...
                    'Message', 'Reconnecting Camera......', 'Indeterminate', 'on');

            end

%             [cam_err, tmpVid, tmpSrc, vidRes] = CamConnect(CamName, ROIPosition);
            [cam_err, tmpVid, tmpSrc, vidRes] = CamConnect(CamName, ChipInform(CurrentChip).ROI);

            if cam_err == 0

                nBands = get(tmpVid, 'NumberOfBands');
                previewImage = image(zeros(vidRes(2), vidRes(1), nBands), 'parent', app.axes_camera);
                preview(tmpVid, previewImage);

                vid = tmpVid;
                src = tmpSrc;

            end

        end

    catch

        if isempty(Progress)||~isvalid(Progress)

            Progress = uiprogressdlg(app.figure1,...
                'Message', 'Reconnecting Camera......', 'Indeterminate', 'on');

        end

%         [cam_err, tmpVid, tmpSrc, vidRes] = CamConnect(CamName, ROIPosition);
        [cam_err, tmpVid, tmpSrc, vidRes] = CamConnect(CamName, ChipInform(CurrentChip).ROI);

        if cam_err == 0

            nBands = get(tmpVid, 'NumberOfBands');
            previewImage = image(zeros(vidRes(2), vidRes(1), nBands), 'parent', app.axes_camera);
            preview(tmpVid, previewImage);

            vid = tmpVid;
            src = tmpSrc;

        end

    end

end

if Run_flag==0

    radStr = sprintf('radiobutton_Ch%d', cur_Channel);
    str = get(app.(radStr), 'Text');
    prvStr = sprintf('Preview: %s', str);
    set(app.text_Status, 'Text', prvStr)

end

% timeChSet = toc(startChSet);
% fprintf('Time for ChSet = %d\n', timeChSet)

end

function Apply_CamExp

global CamInform src

if CamInform.Exp.Prv==src.ExposureTime

    return;

end

CamInform.Exp.Tic = tic;
CamInform.Exp.AdaptTime = (CamInform.Exp.Delay+CamInform.Exp.Prv+src.SensorReadoutTime)/1000000;
CamInform.Exp.Prv = src.ExposureTime;
CamInform.Pos.AdaptTime = (CamInform.Exp.Delay+CamInform.Exp.Prv+src.SensorReadoutTime)/1000000;

end
