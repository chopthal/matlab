clear
path = 'D:\Working\Newly\icluebio\Software\icluebio\Kinetics\MultiKinetics\TestSet\BiaSimul_OrdinarySet';
file = 'OrdinaryKineticsSample.txt';
pathFile = fullfile(path, file);

dataTable = readtable(pathFile, 'VariableNamingRule', 'preserve');
disp(size(dataTable))

data = cell(size(dataTable, 2)/2, 2);
for i = 1:size(data, 1)    
    data{i, 1} = dataTable{:, 2*i-1};
    data{i, 2} = dataTable{:, 2*i};    
end

fig1 = figure(1);
ax1 = axes(fig1);
for i = 1:size(data, 1)
    hold(ax1, 'on'); plot(data{i, 1}, data{i, 2});
end

dy = cell(size(data, 1), 1);
fig2 = figure(2);
ax2 = axes(fig2);
for i = 1:size(dy, 1)
    dy{i} = gradient(data{i, 2} ./ gradient(data{i, 1}));
    hold(ax2, 'on'); plot(data{i, 1}, dy{i});
end

sumY = 0;
for i = 1:size(data, 1)
    
end