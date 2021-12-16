clear; close all

fileName = 'TestSet\bulky_problems2.txt';
data = readtable(fileName, 'VariableNamingRule', 'preserve');
fig = figure(1); ax = axes(fig); cla(ax);

for i = 1:size(data, 2)/2
    hold(ax, 'On')
    data.(data.Properties.VariableNames{2*i-1}) = [0:size(data.(data.Properties.VariableNames{2*i-1}), 1)-1]';
    plot(ax, data.(data.Properties.VariableNames{2*i-1}), data.(data.Properties.VariableNames{2*i}))
end
legend(ax, data.Properties.VariableNames, 'Location', 'bestoutside')

disp(data.Properties.VariableNames')
% [Target, Reference]
referencingSequence = {};
% referencingSequence = {
%     [14, 2];
%     [16, 4];
%     [18, 6];
%     [20, 8];
%     [22, 10];
%     [24, 12]
%     };
referencingSequence = {
    [14, 24];
    [16, 24];
    [18, 24];
    [20, 24];
    [22, 24];
    [24, 24]
    };

if isempty(referencingSequence)
    referencedData = cell(size(data, 2)/2, 3);
    for i = 1:size(data, 2)/2
        referencedData{i, 1} = data.(data.Properties.VariableNames{2*i-1});
        referencedData{i, 2} = data.(data.Properties.VariableNames{2*i});
        referencedData{i, 3} = strcat(data.Properties.VariableNames{2*i});
    end
else
    referencedData = cell(size(referencingSequence, 1), 3);
    for i = 1:size(referencingSequence, 1)
        referencedData{i, 1} = data.(data.Properties.VariableNames{referencingSequence{i}(1)-1});
        referencedData{i, 2} = data.(data.Properties.VariableNames{referencingSequence{i}(1)}) - data.(data.Properties.VariableNames{referencingSequence{i}(2)});
        referencedData{i, 3} = strcat(data.Properties.VariableNames{referencingSequence{i}(1)}, ' - ref');
    end
end

fig2 = figure(2); ax2 = axes(fig2); cla(ax2);

for i = 1:size(referencedData, 1)
    hold(ax2, 'On')    
    plot(ax2, referencedData{i, 1}, referencedData{i, 2})
end
legend(ax2, referencedData{:, 3}, 'Location', 'bestoutside')

baseLineTime     = [0, 61];
associationTime  = [75, 121];
dissociationTime = [126, 386];

processedIndex = [baseLineTime(1)+1:baseLineTime(2)+1,...
    associationTime(1)+1:associationTime(2)+1,...
    dissociationTime(1)+1:dissociationTime(2)+1];
processedData = cell(size(referencedData));

fig3 = figure(3); ax3 = axes(fig3); cla(ax3);

for i = 1:size(processedData, 1)    
    tmpBaseLineData = referencedData{i, 2}(baseLineTime(1)+1:baseLineTime(2)+1);
    tmpAssociationData = referencedData{i, 2}(associationTime(1)+1:associationTime(2)+1);
    tmpDissociationData = referencedData{i, 2}(dissociationTime(1)+1:dissociationTime(2)+1);
    
    tmpBulky = tmpAssociationData(1) - tmpBaseLineData(end);
    tmpAssociationData = tmpAssociationData - tmpBulky;
    tmpBulky = tmpDissociationData(1) - tmpAssociationData(end);
    tmpDissociationData = tmpDissociationData - tmpBulky;
    
    processedData{i, 2} = [tmpBaseLineData; tmpAssociationData; tmpDissociationData];
    processedData{i, 1} = [0 : size(processedIndex, 2)-1]';
    processedData{i, 3} = referencedData{i, 3};
    hold(ax3, 'On')    
    plot(ax3, processedData{i, 1}, processedData{i, 2})    
end
legend(ax3, processedData{:, 3}, 'Location', 'bestoutside')

x = [processedData{:, 1}];
y = [processedData{:, 2}];
% writematrix(resultMat, 'result.txt', 'Delimiter', 'tab')

for i = 1:size(x, 2)
    resultMat = [x(:, i), y(:, i)];
    fileName = sprintf('result%d.txt', i);
    writematrix(resultMat, fileName, 'Delimiter', 'tab')
end