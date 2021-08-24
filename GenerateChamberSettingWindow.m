function GenerateChamberSettingWindow(mainApp, chamberNum, mainFigPosition, currentChipInform)

    global ChambSetApp

    ChambSetApp = struct;
    ChambSetApp.mainApp = mainApp;
%     ChambSetApp.currentChipInform = 'modal';
    ChambSetApp.chamberNum = chamberNum;
    ChambSetApp.currentChipInform = currentChipInform;

    ChambSetApp.mainFig = uifigure;
    ChambSetApp.mainFig.WindowStyle = 'modal';
    ChambSetApp.mainFig.Name = 'Select Chamber(s)';
    ChambSetApp.mainFig.Position = mainFigPosition;
    ChambSetApp.WindowStyle = mainFigPosition;
    ChambSetApp.btnPanel = uipanel(ChambSetApp.mainFig);
    ChambSetApp.ctrPanel = uipanel(ChambSetApp.mainFig);
    ChambSetApp.startBtn = uibutton(ChambSetApp.ctrPanel);
    ChambSetApp.startBtn.Text = 'Run';
    ChambSetApp.startBtn.ButtonPushedFcn = @(obj, event) StartBtnClicked(obj, event);
    ChambSetApp.chkAll = uicheckbox(ChambSetApp.ctrPanel);
    ChambSetApp.chkAll.Text = 'Select All';
    ChambSetApp.chkAll.ValueChangedFcn = @(obj, event) ChkAllValueChanged(obj, event);


    %% Main elements Position in mainFig

    mainMargin = [10 10 10 10];
    btnPanelPadding = [0 0 0 0];
    ctrPanelPadding = [0 0 0 10];
    ctrPanelHeight = 50;

    % btnPanel Position

    w = ChambSetApp.mainFig.Position(3) - mainMargin(1) - mainMargin(2)...
        - btnPanelPadding(1) - btnPanelPadding(2);
    h = ChambSetApp.mainFig.Position(4) - mainMargin(3) - mainMargin(4)...
        - btnPanelPadding(3) - btnPanelPadding(4) - ctrPanelHeight...
        - ctrPanelPadding(3) - ctrPanelPadding(4);
    x = mainMargin(1) + btnPanelPadding(1);
    y = mainMargin(4) + btnPanelPadding(4);
    ChambSetApp.btnPanel.Position = [x, y, w, h];

    % ctrPanel Position
    w = ChambSetApp.mainFig.Position(3) - mainMargin(1) - mainMargin(2)...
        - ctrPanelPadding(1) - ctrPanelPadding(2);
    h = ctrPanelHeight;
    x = mainMargin(1) + ctrPanelPadding(1);
    y = mainMargin(4) + ctrPanelPadding(4) + ChambSetApp.btnPanel.Position(4) + btnPanelPadding(3) + btnPanelPadding(4);
    ChambSetApp.ctrPanel.Position = [x, y, w, h];

    % control button Position in ctrPanel (btnStart, chkAll)
    ctrPanelMargin = [10 10 10 10];

    startBtnWidth = 100;
    startBtnPadding = [0 0 0 0];

    chkAllWidth = 100;
    chkAllPadding = [0 20 0 0];

    % startBtn
    w = startBtnWidth;
    h = ChambSetApp.ctrPanel.Position(4) - ctrPanelMargin(3) - ctrPanelMargin(4) - startBtnPadding(3) - startBtnPadding(4);
    x = ChambSetApp.ctrPanel.Position(3) - ctrPanelMargin(2) - startBtnPadding(2) - startBtnWidth;
    y = ctrPanelMargin(4) + startBtnPadding(4);
    ChambSetApp.startBtn.Position = [x, y, w, h];

    % chkAll
    w = chkAllWidth;
    h = ChambSetApp.ctrPanel.Position(4) - ctrPanelMargin(3) - ctrPanelMargin(4) - chkAllPadding(3) - chkAllPadding(4);
    x = ChambSetApp.startBtn.Position(1) - startBtnPadding(1) - chkAllPadding(2) - chkAllWidth;
    y = ctrPanelMargin(4) + chkAllPadding(4);
    ChambSetApp.chkAll.Position = [x, y, w, h];



    %% Togglebutton Position in btnPanel

    btnPanelMargin = [10 10 10 10]; % Left, Right, Top, Bottom (Pixel)
    btnGap = 10; % Btw btn and btn
    btnHeight = (ChambSetApp.btnPanel.Position(4) - btnPanelMargin(3) -...
        btnPanelMargin(4) - (chamberNum-1)*btnGap) / chamberNum;
    btnWidth = ChambSetApp.btnPanel.Position(3) - btnPanelMargin(1) - btnPanelMargin(2);

    for btnNo = 1:chamberNum

        btnStr = sprintf('btn%d', btnNo);
        ChambSetApp.(btnStr) = uibutton(ChambSetApp.btnPanel, 'state');
        textStr = sprintf('Chamber %d', btnNo);
        ChambSetApp.(btnStr).Text = textStr;
        ChambSetApp.(btnStr).Position =...
            [btnPanelMargin(1),...
            btnPanelMargin(4) + btnHeight*(chamberNum-btnNo) + btnGap*(chamberNum-btnNo),...
            btnWidth,...
            btnHeight];

    end

end

%% Callback functions

function ChkAllValueChanged(obj, event)

    global ChambSetApp
      
    for btnNo = 1:ChambSetApp.chamberNum

        btnStr = sprintf('btn%d', btnNo);
        ChambSetApp.(btnStr).Value = event.Value;

    end

end

function StartBtnClicked(obj, event)

    global ChambSetApp
    
    selBtnNo = zeros(ChambSetApp.chamberNum, 1);

    for btnNo = 1:ChambSetApp.chamberNum
        
        btnStr = sprintf('btn%d', btnNo);        
        selBtnNo(btnNo) = ChambSetApp.(btnStr).Value;
        
    end
    
    if sum(selBtnNo, 'all') == 0        
        
        uialert(ChambSetApp.mainFig, 'Please select chamber(s).', 'Run Error');
        
        return;
        
    end
    
    ChambSetApp.mainApp.ScanProgDlg = uiprogressdlg(ChambSetApp.mainApp.figure1,...
            'Message', 'Auto Scanning...',...
            'Cancelable', 'on',...
            'Indeterminate', 'on');
        
    delete(ChambSetApp.mainFig)    
    ScanDropletChip(ChambSetApp.mainApp, ChambSetApp.currentChipInform, selBtnNo)    
    
end