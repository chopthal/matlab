function SaveData(app)

progFig = app.DropletCounterUIFigure;
progWindow = uiprogressdlg(progFig, 'Title', 'Please Wait', ...
    'Message', 'Saving Counted Results...', 'Cancelable', 'on');
pause(0.5)

progWindow.Value = 0.3;

if progWindow.CancelRequested == 1
    
    close(progWindow)
    return;
    
end

NoColors = 8;

CheckValue = cell(NoColors, 1);
LabelText = cell(NoColors, 1);
ResultMatrix = cell(NoColors+2, 3);

for i = 1:NoColors

    CheckStr = sprintf('CheckBox_%d', i);
    LabelStr = sprintf('Label_%d', i);
    CheckValue{i, 1} = app.(CheckStr).Value;
    LabelText{i, :} = app.(LabelStr).Text;

end

for i = 1:NoColors

    ResultMatrix{i, 1} = num2str(i);
    ResultMatrix{i, 2} = num2str(CheckValue{i, 1});
    ResultMatrix{i, 3} = LabelText{i, 1};

end

progWindow.Value = 0.6;

if progWindow.CancelRequested == 1
    
    close(progWindow)
    return;
    
end

ResultMatrix{NoColors+1, 1} = 'Unknown';
ResultMatrix{NoColors+2, 1} = 'Total';

ResultMatrix{NoColors+1, 3} = app.Label_9.Text;
ResultMatrix{NoColors+2, 3} = app.Label_10.Text;

TitleMatrix = {'Color', 'Selected', 'Numbers'};
WriteMatrix = [TitleMatrix;ResultMatrix];

progWindow.Value = 0.9;

FileName = 'Result.xlsx';
DateTime = char(datetime('now'));
DateTime(end-2) = '-';
DateTime(end-5) = '-';
PathName = fullfile(pwd, DateTime);
mkdir(PathName)
PathFile = fullfile(PathName, FileName);
xlswrite(PathFile, WriteMatrix, 1, 'A1')

progWindow.Value = 1.0;
pause(0.1)

if progWindow.CancelRequested == 1
    
    close(progWindow)
    return;
    
end

try

    winopen(PathName)

catch

    disp('Folder open is failed!')

end
   


% InstFig = figure;
% InstFig.Visible = 'off';
% InstAxes = axes(InstFig);
% 
% copyobj(app.UIAxes.Children, InstAxes);
% InstAxes.DataAspectRatio = app.UIAxes.DataAspectRatio;
% axis(InstAxes, 'off')
% 
% FileNameImg = 'ResultImage.png';
% PathFileImg = fullfile(PathName, FileNameImg);
% saveas(InstFig, PathFileImg);
% 
% delete(InstFig);