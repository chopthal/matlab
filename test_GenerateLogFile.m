clear; close force all;

pathName = 'D:\Users\user\Desktop\2022-03-03 18-25-00\RU';
fileName = 'Ch1.txt';
fullPath = fullfile(pathName, fileName);
logFile = fullfile(pathName, 'LogFile.txt');

data = readtable(fullPath);
x = data.x - 61;
y = data.y;

fig = figure; ax = axes(fig);
plot(ax, x, y)

injectionTime = 180;
stabilizationTime = 420;
termStabilization = 0;
termCycle = 59;

fileID = fopen(logFile, 'w');

time1 = 0;
for i = 1:100
    time2 = time1 + injectionTime;
    time3 = time2 + termStabilization;
    time4 = time3 + stabilizationTime;
    fprintf(fileID, 'Injection Start : %d sec\n', time1);
    fprintf(fileID, 'Injection Finished : %d sec\n', time2);
    fprintf(fileID, 'Stabilization Start : %d sec\n', time3);
    fprintf(fileID, 'Stabilization End : %d sec\n', time4);

    if time4 >= y(end)
        break
    end

    time1 = time4 + termCycle;    
end

fclose(fileID);
winopen(logFile);