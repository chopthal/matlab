function Capture_Image(app)

global cap_folder cap_i cap_folder_flag cur_Channel NoofChannel vid...
    FluorMode scanCh CaptureFlag

CaptureFlag = 1;

for i = 1:NoofChannel
    
    eval(sprintf('global Ch%d_SavedFieldName;', i));
    
end

if isequal(cap_folder, 0)||(exist(cap_folder, 'dir')~=7)

    pushbutton_Set_Folder(app)
    
end

if isequal(cap_folder, 0)||(exist(cap_folder, 'dir')~=7)
    
    return;
    
end

%TODO : Delete after optimaztion
if app.radiobutton_Ch1.Value
    scanCh = 1;
elseif app.radiobutton_Ch2.Value
    scanCh = 2;
end

set(app.text_Status, 'Text', 'Please wait......');

pause(0.05);

temp_cur_Channel = cur_Channel;

chStr = {'BM' 'FM'};

if cap_folder_flag==1
        
    while 1

        str = fullfile(cap_folder, strcat(num2str(cap_i), '_', chStr{scanCh(1)}, '.png'));

        if exist(str, 'file')==0

            cap_folder_flag = 0;  break;

        end

        cap_i = cap_i+1;

    end

end

ScanSaveImg(app, vid, FluorMode, scanCh, cap_folder, cap_i)
  
%TODO : Resotre after optimaztion
% radStr = sprintf('radiobutton_Ch%d', temp_cur_Channel);
% set(app.(radStr), 'Value', 1)
% Ch_set(app, temp_cur_Channel);

stStr = sprintf('Directory: %s,   Name: %d_XM.png', cap_folder, cap_i);
set(app.text_Status, 'Text', stStr)

cap_i = cap_i+1;

CaptureFlag = 0;
