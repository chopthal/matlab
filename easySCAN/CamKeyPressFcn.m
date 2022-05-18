% 2020. 12. 07

% iMeasy_Multi_v1.0.2 -> iMeasy_Multi_v1.0.7

% Scan flag, AF flag, Capture flag, Reset flag

function CamKeyPressFcn(app, event)

% global StageFlag
global StageFlag CaptureFlag Run_flag AF_flag Reset_flag

% if StageFlag == 1
if StageFlag == 1 || CaptureFlag == 1 || Run_flag == 1 || AF_flag == 1 || Reset_flag == 1
    
    return;
    
end

key = event.Key;
MainApp = app.UserData;

if strcmp(key, 'leftarrow')

    Stage_Control(MainApp, 'X', 'F', []);

elseif strcmp(key, 'rightarrow')

    Stage_Control(MainApp, 'X', 'B', []);

elseif strcmp(key, 'uparrow')

    Stage_Control(MainApp, 'Y', 'F', []);

elseif strcmp(key, 'downarrow')

    Stage_Control(MainApp, 'Y', 'B', []);

elseif strcmp(key, 'pageup')

    Stage_Control(MainApp, 'Z', 'F', []);

elseif strcmp(key, 'pagedown')

    Stage_Control(MainApp, 'Z', 'B', []);

elseif strcmp(key, 'space')

    progDlg = uiprogressdlg(MainApp.figure1,...
            'Message', 'Image Capture...', 'Indeterminate', 'on');

    Capture_Image(MainApp)
    delete(progDlg)
    figure(MainApp.figure_camera)

end