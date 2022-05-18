% 2020. 12. 07

% iMeasy_Multi_v1.0.6 -> iMeasy_Multi_v1.0.7

% Don't change timeout.

function RX_out = comm2port(app, TgtPortStr, TX, RX_wanted)

global timing_flag;

eval(sprintf('global %s;', TgtPortStr));
eval(sprintf('TgtPort = %s;', TgtPortStr));

% defTimeout = TgtPort.Timeout;

timing_flag = 0;

try

    flushinput(TgtPort);
    fprintf(TgtPort, TX);
    
catch
    
    timing_flag = 1;
    RX_out = ReconnProcess(app, TgtPortStr, TX, RX_wanted);    
    return;
    
end

t = 0;
tic;

while (TgtPort.BytesAvailable==0)&&(t<TgtPort.Timeout)

    pause(0.05);
    t = toc;
    
end

% disp(t)
% disp(TgtPort.BytesAvailable)
% 
% try
%     
%     TgtPort.Timeout = 1;
%     
% catch
%     
%     disp('Changing timeout to 1 is failed.')
%     
% end
% 
% disp(TgtPort.Timeout)

if TgtPort.BytesAvailable ~= 0
    
    ret = fscanf(TgtPort);
    RX_out = ret(1:(end-1));
    
else
    
    ret = [];
    
end

% ret = fscanf(TgtPort);
% RX_out = ret(1:(end-1));
% disp(ret)

if length(ret) < 5
    
    timing_flag = 2;
    RX_out = ReconnProcess(app, TgtPortStr, TX, RX_wanted);
    
    return;
    
end

if ~isempty(RX_wanted)
    
    if ~strcmp(RX_out, RX_wanted)
    
        timing_flag = 2;        
        RX_out = ReconnProcess(app, TgtPortStr, TX, RX_wanted);
        
    end
    
end

% try
% 
%     TgtPort.Timeout = defTimeout;
%     
% catch
%     
%     disp('Changing timeout to default (40s) is failed.')
%     
% end
    
    
function [RX_out] = ReconnProcess(app, TgtPortStr, TX, RX_wanted)

global Ch1_Inten Ch2_Inten timing_flag DeviceName

recProgDlg = uiprogressdlg(app.figure1,...
    'Message', 'Trying to Reconnect...',...
    'Indeterminate', 'on');

tmp_timing_flag = timing_flag;

RX_out = [];
err = 1;

TryReconnectPort(TgtPortStr);

chkTX = '$D#NAME';
chkRX = strcat(chkTX, '#', DeviceName, '#OK');

tStart = tic;
tEnd = 0;

while err == 1 && tEnd < 5

    [~, err] = comm2portExcReconn('Main_port', chkTX, chkRX);
    tEnd = toc(tStart);
    pause(0.05)
    
end

chNum = get(app.radiobutton_Ch2, 'Value') + 1;
offFlag = get(app.radiobutton_Ch2, 'Value');

if offFlag == 1
    
    txStr = sprintf('$L#%d#OFF', chNum);
    rxStr = strcat(txStr, '#OK');
    
else
    
    eval(sprintf('chInt = Ch%d_Inten;', chNum));

            Ch_set(app, 1);
    txStr = sprintf('$L#%d#ON#%d', chNum, chInt);
    rxStr = strcat(txStr, '#OK');
    
end

[~] = comm2port(app, TgtPortStr, txStr, rxStr);

eval(sprintf('global %s', TgtPortStr));

try

    eval(sprintf('%s.Timeout = 40;', TgtPortStr));
    
catch
    
    disp('Changing timeout to default (40s) in ReconProcess is failed.')
    
end

if strcmp(TX(2), 'S')

    if tmp_timing_flag == 2

        ResetCoorReconn(app, TgtPortStr, TX(4))
        
    end
    
    RX_out = comm2portExcReconn(TgtPortStr, TX, RX_wanted);  
    
end

delete(recProgDlg)


function ResetCoorReconn(app, TgtPortStr, axes)

global X_abs_um Y_abs_um Z_abs_um step_per_um_X step_per_um_Y step_per_um_Z

TX = strcat('$S#', axes, '#', 'F', '#', '999999');
[~] = comm2portExcReconn(TgtPortStr, TX, []);

if strcmp(axes, 'X')
    
    Step = floor(X_abs_um * step_per_um_X);
    
elseif strcmp(axes, 'Y')
    
    Step = floor(Y_abs_um * step_per_um_Y);
    
elseif strcmp(axes, 'Z')
    
    Step = floor(Z_abs_um * step_per_um_Z);
    
end

TX = strcat('$S#', axes, '#', 'B', '#', num2str(Step));
[~] = comm2portExcReconn(TgtPortStr, TX, []);

set(app.edit_X, 'Value', X_abs_um);
