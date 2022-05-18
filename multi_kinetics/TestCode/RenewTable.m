function RenewTable(app)

% Default values
defData.Kon = ones(1, app.MainApp.dataNo) * 100000;
defData.Koff = ones(1, app.MainApp.dataNo) * 0.001;
defData.Rmax = zeros(1, app.MainApp.dataNo);
% defData.BI = ones(1, app.MainApp.dataNo) * 0.1;
defData.BI = zeros(1, app.MainApp.dataNo);

for i = 1:app.MainApp.dataNo
    
    defData.Rmax(1, i) = max(...
        [max(app.MainApp.dataStruct(i).kinAssoData(:, 2))...
        max(app.MainApp.dataStruct(i).kinDissoData(:, 2))]...
        );

end

tableData.Global.varNames = {'Start Value'};
tableData.Local.varNames = cell(1, app.MainApp.dataNo);
tableData.Constant.varNames = cell(1, app.MainApp.dataNo);

for i = 1:app.MainApp.dataNo
    
    tableData.Local.varNames{1, i} = app.MainApp.dataStruct(i).desName;
    tableData.Constant.varNames{1, i} = app.MainApp.dataStruct(i).desName;
    
end

dropDownVal = {app.RmaxDropDown.Value;
    app.KonDropDown.Value;
    app.KoffDropDown.Value;
    app.BIDropDown.Value};

dropDownOrd = {'Rmax';
    'Kon';
    'Koff';
    'BI'};

noGlobal = 1;
noLocal = 1;
noConstant = 1;

for i = 1:size(dropDownOrd, 1)
    
    if strcmp(dropDownVal{i, 1}, 'Global')
        
        tableData.Global.data(noGlobal, :) = max(defData.(dropDownOrd{i, 1}));
        tableData.Global.rowName{noGlobal, 1} = dropDownOrd{i, 1};
        noGlobal = noGlobal + 1;
        
    elseif strcmp(dropDownVal{i, 1}, 'Local')
        
        tableData.Local.data(noLocal, :) = defData.(dropDownOrd{i, 1});
        tableData.Local.rowName{noLocal, 1} = dropDownOrd{i, 1};
        noLocal = noLocal + 1;
        
    elseif strcmp(dropDownVal{i, 1}, 'Constant')
        
        tableData.Constant.data(noConstant, :) = defData.(dropDownOrd{i, 1});
        tableData.Constant.rowName{noConstant, 1} = dropDownOrd{i, 1};
        noConstant = noConstant + 1;
        
    end
    
end
    
if isfield(tableData.Global, 'data')

    dispTable.Global = array2table(tableData.Global.data);  
    dispTable.Global.Properties.VariableNames = tableData.Global.varNames;
    app.GlobalTable.Data = dispTable.Global;
    app.GlobalTable.ColumnName = dispTable.Global.Properties.VariableNames;
    app.GlobalTable.RowName = tableData.Global.rowName;
    app.GlobalTable.ColumnEditable = true;
    
else
    
    app.GlobalTable.Data = [];
    
end

if isfield(tableData.Local, 'data')
    
    dispTable.Local = array2table(tableData.Local.data);
    dispTable.Local.Properties.VariableNames = tableData.Local.varNames;
    app.LocalTable.Data = dispTable.Local;
    app.LocalTable.ColumnName = dispTable.Local.Properties.VariableNames;
    app.LocalTable.RowName = tableData.Local.rowName;
    app.LocalTable.ColumnEditable = true;
    
else
    
    app.LocalTable.Data = [];
    
end

if isfield(tableData.Constant, 'data')
    
    dispTable.Constant = array2table(tableData.Constant.data);    
    dispTable.Constant.Properties.VariableNames = tableData.Constant.varNames;
    app.ConstantTable.Data = dispTable.Constant;
    app.ConstantTable.ColumnName = dispTable.Constant.Properties.VariableNames;
    app.ConstantTable.RowName = tableData.Constant.rowName;
    app.ConstantTable.ColumnEditable = true;
    
else
    
    app.ConstantTable.Data = [];

end