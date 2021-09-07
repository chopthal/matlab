function [rx, errorCode] = WaitUntilWantedRX(portDevice, wantedRX, timeOut)

initializeRX = "61010152000310";
rx = '';
errorCode = '';

if isempty(wantedRX)
    wantedRX = "61010152000000";
end

if isempty(portDevice)
    return
elseif ~isvalid(portDevice)
    return
end

rx = num2str(str2double(wantedRX) + 1); % Wrong rx
tStart = tic;
tEnd = 0;

pfc = "1001";
pfcResetError = "0156";
while ~strcmp(rx, wantedRX) && tEnd < timeOut    
    value = "000152";
    rx = AliasCommunication(portDevice, [], [], [], [], pfc, value);                    
    
    % Error code
    value = "000155";
    rxError = AliasCommunication(portDevice, [], [], [], [], pfc, value);

    if ~strcmp(rxError(end-2:end), '000')
        errorCode = sprintf('Error Code : %s', rx(end-2:end));    
        disp(errorCode)
        % UIConfirm
        % Reset Error
        value = "000001"; % Reset all errors
        rx = AliasCommunication(portDevice, [], [], [], [], pfcResetError, value);
        % Return
        return
    end
    
    if strcmp(rx, initializeRX)
        return
    end
    
    tEnd = toc(tStart);
end