% 2021. 01. 12

% easySCAN_v1.0.0 -> easySCAN_v1.1.0

% interval : hard coding to 10 um


function GetAFImgs(app)

% Z stage down
% Creat folder (date)
% save : filename (intensity_Num)
% F : number dec / lens up
% B : number inc / lens down

global vid Z_abs_um

prevZ = Z_abs_um;

repNo = 1;

if app.Rep3CheckBox.Value == 1
    
    repNo = 3;
    
end

selpath = uigetdir;

if selpath == 0
    
    return;
    
else
    
    um_range = get(app.edit_Range, 'Value');
%     um_interval = get(app.edit_Interval, 'Value');
    um_interval = 10;

%     um_num = um_range/um_interval;    
    um_num = um_range/um_interval+1;    
    um_bottom = um_range/2;
    
    listZ = zeros(um_num, 1);

    Stage_Control(app, 'Z', 'F', um_bottom);

    FolderName = datestr(clock);
    FolderName(end-2) = '-';
    FolderName(end-5) = '-';
    FolderName = fullfile(selpath, FolderName);
    mkdir(FolderName);
    
    Ch_set(app, 1);
    
    for i=1:um_num
        
        for ii = 1:repNo
            
            if i ~= 1
                
                Stage_Control(app, 'Z', 'B', um_interval);
%                 pause(0.1);
        
            end

            im = getsnapshot(vid);
            im = im * 2^4;
            
            FileName = sprintf('%d.png', repNo*(i-1)+ii);

            FolderFile = fullfile(FolderName, FileName);        
            imwrite(im, FolderFile);

            listZ(repNo*(i-1)+ii, 1) = Z_abs_um;
            
        end

%         Stage_Control(app, 'Z', 'B', um_interval);
%         pause(0.1);

    end

    Stage_Control(app, 'Z', 'F', um_bottom);
    
    if Z_abs_um > prevZ

        Stage_Control(app, 'Z', 'F', Z_abs_um - prevZ)

    else

        Stage_Control(app, 'Z', 'B', prevZ - Z_abs_um)

    end
    
    savFileName = fullfile(FolderName, 'FocusInform.mat');
    
    save(savFileName, 'listZ')
    save(savFileName, 'um_interval', '-append')
    
end