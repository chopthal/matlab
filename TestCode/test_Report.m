% https://kr.mathworks.com/help/rptgen/matlab-report-generator-task-examples.html
Time = datestr(clock);

import mlreportgen.dom.*;            
ID = Document(fullfile(FilePath, FileName), 'pdf');
open(ID);            
ID.CurrentPageLayout.PageMargins.Top = '0.75in';
ID.CurrentPageLayout.PageMargins.Header = '0.25in';
ID.CurrentPageLayout.PageMargins.Bottom = '0.75in';
ID.CurrentPageLayout.PageMargins.Footer = '0.25in';
ID.CurrentPageLayout.PageMargins.Gutter = '0in';
ID.CurrentPageLayout.PageMargins.Left = '1in';
ID.CurrentPageLayout.PageMargins.Right = '1in';
ID.CurrentPageLayout.FirstPageNumber = 1;            
TimeStr = sprintf('Timestamp : %s', Time);
P = Paragraph(TimeStr);
P.Style = [P.Style, {HAlign('Right'), Bold(true), FontSize('12pt')}];
Header = PDFPageHeader();
append(Header, P);
ID.CurrentPageLayout.PageHeaders = Header;            
Footer = PDFPageFooter();
append(Footer, HorizontalRule());            
[LogoImg, ~, LogoAlpha] = imread(app.Image.ImageSource);
LogoPath = fullfile(pwd, strcat(FileName, '(Logo).png'));
imwrite(LogoImg, LogoPath, 'Alpha', LogoAlpha);
Logo = Image(LogoPath);
Logo.Style = {ScaleToFit(true), HAlign('right'), Height('0.25in')};
append(Footer, Logo);
P = Paragraph();
P.Style = [P.Style, {WhiteSpace('preserve'), HAlign('center')}];
append(P, Text('Page '));
append(P, Page());
append(Footer, P);
ID.CurrentPageLayout.PageFooters = Footer;            
TableStyle = {Border('solid'), ColSep('solid'), RowSep('solid'), Width('100%'),...
    OuterMargin('0pt', '0pt', '0pt', '0pt')};            
P = Paragraph('Standard Curve');
P.Style = [P.Style, {HAlign('Left'), Bold(true), FontSize('12pt')}];
append(ID, P);

for i = 1:size(app.UITable3.Data, 1)

    TextStr = sprintf('%s : %s',...
        char(app.UITable3.Data{i, app.SelectTable.GrpColNum}),...
        char(app.UITable3.Data{i, app.SelectTable.MkColNum}));
    T = Text(TextStr);
    T.Style = [T.Style, {FontSize('12pt')}];
    append(ID, T);

end

F = figure;
F.Visible = 'off';
F.Position(3:4) = app.UIAxes.Position(3:4);
AX = axes(F);
AX.FontSize = app.UIAxes.FontSize;
hold(AX, 'on');

for i = 1:length(app.UIAxes.Children)

    X = app.UIAxes.Children(i).XData;
    Y = app.UIAxes.Children(i).YData;
    C = app.UIAxes.Children(i).Color;

    if strcmp(app.UIAxes.Children(i).Type, 'errorbar')

        errorbar(AX, X, Y, app.UIAxes.Children(i).YNegativeDelta,...
            'Color', C, 'Marker', app.UIAxes.Children(i).Marker,...
            'MarkerEdgeColor', C, 'MarkerFaceColor', C);

    else

        plot(AX, X, Y, 'LineStyle', '-', 'Color', C);

    end

end

hold(AX, 'off');
xlabel(AX, app.UIAxes.XLabel.String);
ylabel(AX, app.UIAxes.YLabel.String);
CurvePath = fullfile(pwd, strcat(FileName, '(Curve).png'));
saveas(F, CurvePath);
close(F); 
CurveImg = Image(CurvePath);
CurveImg.Style = {ScaleToFit(true), HAlign('center'), Width('100%')};
append(ID, CurveImg);            
P = Paragraph('Input Data');
P.Style = [P.Style, {HAlign('Left'), Bold(true), FontSize('12pt')}];
append(ID, P);
TableHeader = app.UITable.ColumnName(1:app.InputTable.DefNumCol)';
UITableData = app.UITable.Data;

if isempty(UITableData)
                    
    UITableData = cell(1, length(app.UITable.ColumnName));
    UITableData(:) = {''};                
    
end

for i = 1:size(UITableData, 1)
        
    for j = 1:size(UITableData, 2)
        
        if isempty(UITableData{i, j})
            
            UITableData{i, j} = '-';
            
        end                    
        
    end
                    
end

DftTableBody = UITableData(:, 1:app.InputTable.DefNumCol);
DispCodeNums = find(app.DispCodeNum);

if isempty(DispCodeNums)
    
    Table = FormalTable(TableHeader, DftTableBody);
    Table.Header.Style = [Table.Header.Style, {Bold}];            
    Table.Style = [Table.Style, TableStyle];
    append(ID, Table);
    
else
    
    TableHeader{end+1} = 'Intensity';
    
    for i = 1:length(DispCodeNums)
        
        CodeNum = DispCodeNums(i);                    
        
        if isempty(app.UITable4.Data)
            
            TextStr = sprintf('Code %d', CodeNum);                    
            
        else
        
            TextStr = sprintf('Code %d : %s',...
                CodeNum, app.UITable4.Data{CodeNum, app.CodeTable.TgtColNum});
        
        end
        
        T = Text(TextStr);
        T.Style = [T.Style, {Color(app.CodeColor{CodeNum}), FontSize('12pt')}];
        append(ID, T);
        TableBody = DftTableBody;
        TableBody(:, (end+1)) = UITableData(:, (app.InputTable.DefNumCol+i));
        Table = FormalTable(TableHeader, TableBody);
        Table.Header.Style = [Table.Header.Style, {Bold}];            
        Table.Style = [Table.Style, TableStyle];
        append(ID, Table);
        
    end
    
end

T = Text('.');
T.Style = [T.Style, {Color('white'), FontSize('12pt')}];
append(ID, T);            
P = Paragraph('Sample Data');
P.Style = [P.Style, {HAlign('Left'), Bold(true), FontSize('12pt')}];
append(ID, P);
TableHeader = app.UITable2.ColumnName(1:app.OutputTable.DefNumCol)';
UITable2Data = app.UITable2.Data;
            
if isempty(UITable2Data)

    TableBody = cell(1, length(TableHeader));                
    TableBody(:) = {'-'};
    Table = FormalTable(TableHeader, TableBody);
    Table.Header.Style = [Table.Header.Style, {Bold}];            
    Table.Style = [Table.Style, TableStyle];
    append(ID, Table);

else

    for i = 1:size(UITable2Data, 1)

        for j = 1:size(UITable2Data, 2)

            if isempty(UITable2Data{i, j})

                UITable2Data{i, j} = '-';

            end                    

        end

    end

    DftTableBody = UITable2Data(:, 1:app.OutputTable.DefNumCol);    
    TableHeader{end+1} = 'Intensity';
                
    for i = (app.OutputTable.DefNumCol+1):size(UITable2Data, 2)

        CodeNum = str2double(app.UITable2.ColumnName{i}(5:end));
        TextStr = sprintf('Code %d : %s',...
            CodeNum, app.UITable4.Data{CodeNum, app.CodeTable.TgtColNum});
        T = Text(TextStr);
        T.Style = [T.Style, {Color(app.CodeColor{CodeNum}), FontSize('12pt')}];
        append(ID, T);
        TableBody = DftTableBody;
        TableBody(:, (end+1)) = UITable2Data(:, i);
        Table = FormalTable(TableHeader, TableBody);
        Table.Header.Style = [Table.Header.Style, {Bold}];            
        Table.Style = [Table.Style, TableStyle];
        append(ID, Table);

    end

end

T = Text('.');
T.Style = [T.Style, {Color('white'), FontSize('12pt')}];
append(ID, T);            
P = Paragraph('Goodness of Fit');
P.Style = [P.Style, {HAlign('Left'), Bold(true), FontSize('12pt')}];
append(ID, P);

for i = 1:length(app.GoodnessofFitTextArea.Value)

    TextStr = app.GoodnessofFitTextArea.Value{i};

    if isempty(TextStr)

        TextStr = '-------------------------------------';                    

    end

    T = Text(TextStr);     
    T.Style = [T.Style, {FontSize('12pt')}];
    append(ID, T);                

end
            
close(ID);
delete(LogoPath);
delete(CurvePath);            
close(UIProgress);            
rptview(ID);