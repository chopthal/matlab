% 2020. 09. 29

% iMeasy-m_v1.5.0 -> iMeasy_Multi_v1.0.0

% handles -> app


% function pushbutton_Set_Folder
function pushbutton_Set_Folder(app)

% global MAIN_handles cap_folder cap_i cap_folder_flag;
global cap_folder cap_i cap_folder_flag;

% handles = MAIN_handles;

try

    temp_cap_folder = uigetdir(cap_folder, 'Select Folder to Save');

catch    
    
    temp_cap_folder = uigetdir(pwd, 'Select Folder to Save');

end    

if ~isequal(temp_cap_folder, 0)

    cap_folder = temp_cap_folder;
    cap_i = 1;
    cap_folder_flag = 1;
    
    try
    
        stStr = sprintf('Directory: %s', cap_folder);
        set(app.text_Status, 'Text', stSTr)
%         eval(sprintf('set(handles.text_Status, ''String'', ''Directory: %s'');',cap_folder));
    
    end

else
    
%     set(handles.text_Status, 'String', '');
    set(app.text_Status, 'Text', '');
    
end 