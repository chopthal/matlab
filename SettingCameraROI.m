function SettingCameraROI(MainApp, ROI, isConnection)

global vid CamInform src

% Setting Camera ROI
currentROI = vid.ROIPosition;
if currentROI == ROI
    
    if isConnection == 0
    
        return
        
    end
    
end

stop(vid)
vid.ROIPosition = ROI;
scrPos = get(0, 'ScreenSize');
% tmpROI = vid.ROIPosition;
% vidRes = [ROI(3), ROI(4)];

height = MainApp.figure1.Position(4);
width = ROI(3)/ROI(4) * height;
yoff = MainApp.figure1.Position(2);

mainFigCenter = [MainApp.figure1.Position(1) + MainApp.figure1.Position(3)/2, ...
    MainApp.figure1.Position(2) + MainApp.figure1.Position(4)/2];
scrCenter = [scrPos(1) + scrPos(3)/2, ...
    scrPos(2) + scrPos(4)/2];

if mainFigCenter(1) >= scrCenter(1)    
    
    xoff = MainApp.figure1.Position(1) - width - 10;    
    
else    
    
    xoff = MainApp.figure1.Position(1) + MainApp.figure1.Position(3) + 10;
    
end

MainApp.figure_camera.Position = [xoff, yoff, width, height];


% if vidRes(1)/2 > scrPos(3) && vidRes(2)/2 > scrPos(4)
% 
%     MainApp.figure_camera.Position(3) = scrPos(3)/2 - 10;
%     MainApp.figure_camera.Position(4) = scrPos(4)/2 - 10;
%     MainApp.figure_camera.Position(1) = 10;
%     MainApp.figure_camera.Position(2) = 50;
% 
% else
% 
%     MainApp.figure_camera.Position(3) = vidRes(1)/2;
%     MainApp.figure_camera.Position(4) = vidRes(2)/2;
%     MainApp.figure_camera.Position(1) = MainApp.figure1.Position(1) - MainApp.figure_camera.Position(3) - 10;
%     MainApp.figure_camera.Position(2) = scrPos(4) - MainApp.figure_camera.Position(4) - 50;        
% 
% end

nBands = get(vid, 'NumberOfBands');
% previewImage = image(zeros(vidRes(2), vidRes(1), nBands), 'parent', MainApp.axes_camera);
previewImage = image(zeros(ROI(4), ROI(3), nBands), 'parent', MainApp.axes_camera);
preview(vid, previewImage);

CamInform.Exp.Tic = tic;
CamInform.Exp.AdaptTime = 0;
CamInform.Exp.Prv = src.ExposureTime;
CamInform.Pos.Tic = CamInform.Exp.Tic;
CamInform.Pos.AdaptTime = 0;

start(vid)

MainApp.axes_camera.PlotBoxAspectRatioMode = 'manual';
MainApp.axes_camera.PlotBoxAspectRatio = [ROI(3) ROI(4) 1];
MainApp.axes_camera.InnerPosition = [0.01 0.01 0.98 0.98];