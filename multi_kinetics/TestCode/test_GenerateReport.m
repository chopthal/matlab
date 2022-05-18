% function GenerateReport(app)

import mlreportgen.dom.*;     
import mlreportgen.report.*;

CAPTURE_AXES_WIDTH = 800;
CAPTURE_AXES_HEIGHT = 400;
CAPTURE_AXES_MARGIN = 20;

FilePath = pwd;
FileName = 'testPDF.pdf';

rpt = Report(fullfile(FilePath, FileName), 'pdf');

% Page Layout
pageSizeObj = PageSize("11.69in", "8.27in", "portrait");
pageMarginsObj = PageMargins();
pageMarginsObj.Top = "0.5in";
pageMarginsObj.Bottom = "0.5in";
pageMarginsObj.Left = "0.7in";
pageMarginsObj.Right = "0.7in";
pageMArginsObj.Header = "0.5in";
pageMarginsObj.Footer = "0.5in";
pageMarginsObj.Gutter = "0in";

rpt.Layout.PageSize = pageSizeObj;
rpt.Layout.PageMargins = pageMarginsObj;

% Style : Heading
styles = containers.Map;

styles("baseHeadingPara") = {Color("black"),FontFamily("Arial")};
styles("heading1Para") = [styles("baseHeadingPara"),{OutlineLevel(1),Bold,...
                          FontSize("16pt")}];   
styles("heading2Para") = [styles("baseHeadingPara"),{OutlineLevel(2),...
                          OuterMargin("5pt","0in","12pt","5pt"),FontSize("14pt")}];

open(rpt);


%% Heading 1
heading1Para = Paragraph("Result");
heading1Para.Style = styles("heading1Para");
append(rpt,heading1Para);


%% Result image
% Heading (title)
heading2Para = Paragraph("Fitting plot");
heading2Para.Style = styles("heading2Para");
append(rpt,heading2Para);

fig = uifigure(2);
fig.Visible = 'off';
fig.Color = [1 1 1];
axesHandle = copyobj([app.UIFigure.UserData.Legend, app.UIAxes], fig);
lgd = findobj(axesHandle, 'Type', 'Legend');
lgd.Location = app.UIFigure.UserData.Legend.Location;
ax = findobj(axesHandle, 'Type', 'Axes');
fig.Position(3) = CAPTURE_AXES_WIDTH + 2*CAPTURE_AXES_MARGIN;
fig.Position(4) = CAPTURE_AXES_HEIGHT + 2*CAPTURE_AXES_MARGIN;
ax.Position(1) = CAPTURE_AXES_MARGIN;
ax.Position(2) = CAPTURE_AXES_MARGIN;
ax.Position(3) = CAPTURE_AXES_WIDTH;
ax.Position(4) = CAPTURE_AXES_HEIGHT;
box(ax, 'on')
delete(findobj(ax, 'Type', 'Arrow'));

figFrame = getframe(fig);
close(fig)
imwrite(figFrame.cdata, 'tmp.png');
figImage = Image('tmp.png');
figImage.Style = {ScaleToFit(true), HAlign('center'), Width('100%')};
append(rpt, figImage);


%% Result Table
% Heading (title)
heading3Para = Paragraph("Result table");
heading3Para.Style = styles("heading2Para");
append(rpt,heading3Para);

tableHeader = app.UITable.ColumnName';
formalTable = mlreportgen.dom.FormalTable(tableHeader, table2cell(app.UITable.Data));

% Style
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


%% After generation
close(rpt);
rptview(rpt);