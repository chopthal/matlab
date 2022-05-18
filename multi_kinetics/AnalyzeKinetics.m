function AnalyzeKinetics(app, parentPath)

app.Analyte = ParsingInfo(parentPath);
validAnalyte = struct;

ii = 1;
for i = 1:size(app.Analyte, 2)
    if isempty(app.Analyte(i).Concentration) || isempty(app.Analyte(i).Data)
        continue
    end
%     validAnalyte(ii) = app.Analyte(i);

    for fieldName = fieldnames(app.Analyte)'
       validAnalyte(ii).(fieldName{1}) = app.Analyte(i).(fieldName{1});
    end

    ii = ii + 1;
end

if isempty(fieldnames(validAnalyte))
    app.Analyte = [];
    uialert(app.UIFigure, 'No Data', 'Invalid file')    
    return
else
    app.Analyte = validAnalyte;
end

app.UIDropdownName.Items = {validAnalyte.Name};
app.UIFigure.Visible = 'on';

UIProgressDialog = ...
    uiprogressdlg(app.UIFigure, 'Title', 'Please wait', ...
    'Message', 'Fitting Curve(s)...', ...
    'Indeterminate', 'on');
pause(0.01)
for i = 1:size(app.Analyte, 2)
    [app.Analyte(i).k,...
        app.Analyte(i).kName,...
        app.Analyte(i).chi2,...
        app.Analyte(i).FittedT,...
        app.Analyte(i).FittedR]...
            = ReadyForCurveFitting(...
                app.Analyte(i).Concentration,...
                app.Analyte(i).EventTime,...            
                app.Analyte(i).XData,...
                app.Analyte(i).YData,...
                app.Analyte(i).FittingVariable);
end    

app.UIDropdownName.ValueChangedFcn(app, [])
%% Set Fitting variables to Default
for i = 1:size(app.Analyte, 2)
    app.Analyte(i).FittingVariable = struct;
    app.Analyte(i).FittingVariable = app.Analyte(i).DefaultFittingVariable;
end

close(UIProgressDialog)

end