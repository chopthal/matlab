function GenerateReport(savePath, auditLog)
    
    makeDOMCompilable();
    import mlreportgen.dom.*;
    import mlreportgen.report.*;
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
    styles("baseHeadingPara") = {Color("black"), FontFamily("Arial")};
    styles("heading1Para") =...
        [styles("baseHeadingPara"), {OutlineLevel(1), Bold, FontSize("16pt")}];
    styles("mainPara") = [styles("baseHeadingPara"),...
        {OutlineLevel(2), OuterMargin("5pt", "0in", "20pt", "5pt"), FontSize("12pt")}];
    
    open(rpt);
    
    % Header
    header = PDFPageHeader();
    layout = getReportLayout(rpt);
    layout.PageHeaders = header;
    
    % Footer
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
    
    % Heading 1
    titleText = 'Audit-trail log';
    heading1Para = Paragraph(titleText);
    heading1Para.Style = styles("heading1Para");
    append(rpt, heading1Para);

    % Main    
    mainText = auditLog;
    mainPara = Paragraph(mainText);    
    mainPara.Style = styles("mainPara");
    append(rpt, mainPara);    
    mainPara.WhiteSpace = 'preserve';

    % After generation
    close(rpt);
    winopen(savePath);

end