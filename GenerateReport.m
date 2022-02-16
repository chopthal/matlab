function GenerateReport(app, savePath)

UIProgressDialog = ...
    uiprogressdlg(app.UIFigure, 'Title', 'Please wait', ...
    'Message', 'Generating Report...', ...
    'Indeterminate', 'on');
pause(0.01)

import mlreportgen.dom.*;     
import mlreportgen.report.*;

delete('tmpImmob.png');
delete('tmpFit.png');

CAPTURE_AXES_WIDTH = 800;
CAPTURE_AXES_HEIGHT = 300;
CAPTURE_AXES_MARGIN = 20;
CAPTURE_LEGEND_HEIGHT = 50;

br = PageBreak();
analyte = app.UIFigure.UserData.Analyte;
analyteNo = find(matches(app.UIDropdownName.Items, app.UIDropdownName.Value));

rpt = Report(savePath, 'pdf');

% Page Layout
pageSizeObj = PageSize("11.69in", "8.27in", "portrait");
pageMarginsObj = PageMargins();
pageMarginsObj.Top = "0.5in";
pageMarginsObj.Bottom = "0.5in";
pageMarginsObj.Left = "0.7in";
pageMarginsObj.Right = "0.7in";
pageMarginsObj.Header = "0.5in";
pageMarginsObj.Footer = "0.5in";
pageMarginsObj.Gutter = "0in";

rpt.Layout.PageSize = pageSizeObj;
rpt.Layout.PageMargins = pageMarginsObj;
rpt.Layout.FirstPageNumber = 1;

% Style : Heading
styles = containers.Map;

styles("baseHeadingPara") = {Color("black"),FontFamily("Arial")};
styles("heading1Para") = [styles("baseHeadingPara"),{OutlineLevel(1),Bold,...
                          FontSize("16pt")}];   
styles("heading2Para") = [styles("baseHeadingPara"),{OutlineLevel(2),...
                          OuterMargin("5pt","0in","20pt","5pt"),FontSize("14pt")}];

open(rpt);

%% Header

header = PDFPageHeader();
logo = Image('ReportLogo.png');
logo.Style = {ScaleToFit(true), HAlign('right'), Height('0.5in'), VAlign('top'), OuterMargin("0pt","0pt","0pt","0pt"), InnerMargin("0pt","0pt","0pt","0pt")};
append(header, logo)

layout = getReportLayout(rpt);
layout.PageHeaders = header;

%% Footer
footer = PDFPageFooter();

page = Page();
page.Style = {HAlign('right'), FontSize('11pt')};
append(footer, page);

time = datestr(now);
paragraph = Paragraph(time);
paragraph.Style = [paragraph.Style, {HAlign('Left'), Bold(false), FontSize('10pt')}];
append(footer, paragraph);

layout = getReportLayout(rpt);
layout.PageFooters = footer;

%% Heading 1
titleText = sprintf('Result (Analyte : %s)', analyte(analyteNo).Name);
heading1Para = Paragraph(titleText);
heading1Para.Style = styles("heading1Para");
append(rpt,heading1Para);

%% Information table
informationCell = analyte(analyteNo).Information.Data;

if ~isempty(informationCell)

    % Heading (title)
    heading1Para = Paragraph("Information table");
    heading1Para.Style = styles("heading2Para");
    append(rpt,heading1Para);
    
    tableHeader = {'Application', 'Name', 'Conc.', 'Unit', 'Ch.Mode', 'FR (uL/min)', 'Inj. (s)', 'Wash (s)', 'Vol. (uL)', 'Pos.'};
    formalTable = mlreportgen.dom.FormalTable(tableHeader, informationCell);
    
    % Style
    formalTable.Style = {Width('100%'), ResizeToFitContents(true)};
    formalTable.RowSep = "Solid"; formalTable.ColSep = "Solid"; formalTable.Border = "Solid";
    formalTable.Header.TableEntriesStyle = [formalTable.Header.TableEntriesStyle,...
        {mlreportgen.dom.Bold(true), ...
        HAlign('center')}];
    formalTable.TableEntriesStyle = [formalTable.TableEntriesStyle,...
        {mlreportgen.dom.InnerMargin("2pt","2pt","2pt","2pt"),...
        mlreportgen.dom.WhiteSpace("preserve"), ...
        HAlign('center'), ...
        FontSize('10pt')}];
    append(rpt, formalTable);

end


%% Immobilization Image
% Get Immobilization data
immobilizationData = analyte(analyteNo).ImmobilizationData;

if ~isempty(immobilizationData)

    % Heading (title)
    heading2Para = Paragraph("Immobilization plot");
    heading2Para.Style = styles("heading2Para");
    append(rpt,heading2Para);
    
    fig = uifigure(2);
    fig.Visible = 'off';
    fig.Color = [1 1 1];
    ax = uiaxes(fig);
    fig.Position(3) = CAPTURE_AXES_WIDTH + 2*CAPTURE_AXES_MARGIN;
    fig.Position(4) = CAPTURE_AXES_HEIGHT + 2*CAPTURE_AXES_MARGIN;
    ax.Position(1) = CAPTURE_AXES_MARGIN;
    ax.Position(2) = CAPTURE_AXES_MARGIN;
    ax.Position(3) = CAPTURE_AXES_WIDTH;
    ax.Position(4) = CAPTURE_AXES_HEIGHT;
    box(ax, 'on')
    
    plot(ax, immobilizationData.x, immobilizationData.y);
    xlabel(ax, 'Time (s)'); ylabel(ax, 'Response (RU)');
    ax.XLim = [0, immobilizationData.x(end)];
    
    figFrame = getframe(fig);
    close(fig)
    imwrite(figFrame.cdata, 'tmpImmob.png');
    fileattrib('tmpImmob.png', '+h');
    figImage = Image('tmpImmob.png');
    figImage.Style = {ScaleToFit(true), HAlign('center'), Width('100%')};
    append(rpt, figImage);
    
    % Immobilization level text
    immobilizationLevel = 10000.123;    

    immobilizationLevel=floor(immobilizationLevel*100)/100;
    immobilizationLevelStr = num2str(immobilizationLevel, '%.0f');
       
    FIN = length(immobilizationLevelStr);
    for i = FIN-2:-3:2
        immobilizationLevelStr(i+1:end+1) = immobilizationLevelStr(i:end);
        immobilizationLevelStr(i) = ',';
    end

    textImmobilizationLevel = Text(sprintf('* Immobilization Level : %s RU', immobilizationLevelStr));
    textImmobilizationLevel.Style = {HAlign('right'), OuterMargin("0pt","20pt","0pt","0pt"), FontSize("10pt")};
    append(rpt, textImmobilizationLevel)
end

%% Break line
append(rpt,br);

%% Result image
% Heading (title)
heading3Para = Paragraph("Fitting plot");
heading3Para.Style = styles("heading2Para");
append(rpt,heading3Para);

fig = uifigure(2);
fig.Visible = 'off';
fig.Color = [1 1 1];

if app.UICheckBoxLegend.Value
    axesHandle = copyobj([app.UIFigure.UserData.Legend, app.UIAxes], fig);
    lgd = findobj(axesHandle, 'Type', 'Legend');
    lgd.Location = app.UIFigure.UserData.Legend.Location;
else
    axesHandle = copyobj(app.UIAxes, fig);
end

ax = findobj(axesHandle, 'Type', 'Axes');
fig.Position(3) = CAPTURE_AXES_WIDTH + 2*CAPTURE_AXES_MARGIN;
fig.Position(4) = CAPTURE_AXES_HEIGHT + 2*CAPTURE_AXES_MARGIN + CAPTURE_LEGEND_HEIGHT;
ax.Position(1) = CAPTURE_AXES_MARGIN;
ax.Position(2) = CAPTURE_AXES_MARGIN;
ax.Position(3) = CAPTURE_AXES_WIDTH;
ax.Position(4) = CAPTURE_AXES_HEIGHT;
box(ax, 'on')
delete(findobj(ax, 'Type', 'Arrow'));

figFrame = getframe(fig);
close(fig)
imwrite(figFrame.cdata, 'tmpFit.png');
fileattrib('tmpFit.png', '+h');
figImage = Image('tmpFit.png');
figImage.Style = {ScaleToFit(true), HAlign('center'), Width('100%')};
append(rpt, figImage);


%% Result Table
% Heading (title)
heading4Para = Paragraph("Result table");
heading4Para.Style = styles("heading2Para");
append(rpt,heading4Para);

tableHeader = app.UITable.ColumnName';
formalTable = mlreportgen.dom.FormalTable(tableHeader, table2cell(app.UITable.Data));

% Style
formalTable.Style = {Width('100%'), ResizeToFitContents(true)};
formalTable.RowSep = "Solid"; formalTable.ColSep = "Solid"; formalTable.Border = "Solid";
formalTable.Header.TableEntriesStyle = [formalTable.Header.TableEntriesStyle,...
    {mlreportgen.dom.Bold(true), ...
    HAlign('center')}];
formalTable.TableEntriesStyle = [formalTable.TableEntriesStyle,...
    {mlreportgen.dom.InnerMargin("2pt","2pt","2pt","2pt"),...
    mlreportgen.dom.WhiteSpace("preserve"), ...
    HAlign('right'), ...
    FontSize('10pt')}];

append(rpt, formalTable);


%% After generation
close(rpt);
delete('tmpImmob.png');
delete('tmpFit.png');
winopen(savePath)

close(UIProgressDialog)