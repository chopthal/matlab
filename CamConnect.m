% 2021. 03. 18
% easySCAN_v1_1_3 -> easySCAN_v1_1_3

% Fast capture process.

% function [cam_err, vid, src, vidRes] = CamConnect(CamName, ROIPosition)
function [cam_err, vid, src, vidRes, camInform] = CamConnect(CamName, ROIPosition)

imaqreset;
cam_err = 1;
vid = [];
src = [];
vidRes = [];
camInform.Exp.Delay = 75;

try
            
    dev_IDs = imaqhwinfo('gentl');

catch
    
    return;

end

No_dev_IDs = length(dev_IDs.DeviceIDs);

if No_dev_IDs~=0
            
    for cam_i = 1:No_dev_IDs

        if strcmp(CamName, dev_IDs.DeviceInfo(cam_i).DeviceName(1:3))

            cam_err = 0;
            break;

        end

    end

else
    
    return;

end

% vid = videoinput('gentl', dev_IDs.DeviceIDs{1, cam_i}, 'Mono12');  
vid = videoinput('gentl', dev_IDs.DeviceIDs{1, cam_i}, 'Mono8');  
vid.ROIPosition = ROIPosition;
vidRes = [ROIPosition(3) ROIPosition(4)];

vid.FramesPerTrigger = 1;
vid.ReturnedColorspace = 'grayscale';
src.ExposureTime = 50000;
triggerconfig(vid, 'manual');
vid.TriggerRepeat = Inf;

src = getselectedsource(vid);
src.AutoFunctionROISelector = 'ROI1';
src.AutoFunctionROIUseBrightness = 'False';
src.ReverseX = 'True';
src.ReverseY = 'False';
