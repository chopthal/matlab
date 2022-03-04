filter = {'PDF file *.pdf'};
defPath = 'D:\Users\user\Desktop';
defName = 'Report';
[file, path] = uiputfile(filter, 'Save Report File', fullfile(defPath, defName));
disp(fullfile(path, file))