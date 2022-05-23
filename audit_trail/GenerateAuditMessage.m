function msg = GenerateAuditMessage(app, event, srcName)

    dateStr = datestr(now);
    userName = 'Admin';
    srcType = event.Source.Type;
    remarks = '';    
    
    switch srcType
        case 'uibuttongroup'
            remarks = sprintf('"%s" -> "%s"', event.OldValue.Text, event.NewValue.Text);
        case {'uinumericeditfield', 'uispinner', 'uicheckbox', 'uilistbox', 'uidropdown', 'uieditfield'}
            if ischar(event.PreviousValue) || isstring(event.PreviousValue)
                remarks = sprintf('"%s" -> "%s"', event.PreviousValue, event.Value);
            else
                remarks = sprintf('"%d" -> "%d"', event.PreviousValue, event.Value);
            end
        case 'uitable'
            if ischar(event.PreviousData) || isstring(event.PreviousData)
                changedString = sprintf('"%s" -> "%s"', event.PreviousData, event.NewData);
            else
                changedString = sprintf('"%d" -> "%d"', event.PreviousData, event.NewData);
            end
            remarks = sprintf('%s (indices : [%d, %d])', changedString, event.Indices(1, 1), event.Indices(1, 2));
    end

    eventName = event.EventName;    
    msg = sprintf('[%s] "%s" (%s/%s/%s) %s\n', dateStr, userName, srcName, srcType, eventName, remarks);
    msg = EncrypteAuditMessage(msg);

    fprintf(app.FileId, msg);

end


function encryptedMsg = EncrypteAuditMessage(auditMsg)

    INPUT_LENGTH = 16;
    resultEncrypt = '';
    
    %% Encrypt
    hexFullText = dec2hex(auditMsg);
    for i = 1:floor(size(hexFullText, 1)/INPUT_LENGTH)
        hexText = hexFullText(INPUT_LENGTH*(i-1)+1:INPUT_LENGTH*(i-1)+INPUT_LENGTH, :);    
        tmp = cellstr(hexText);
        input = strcat(tmp{:});        
        output = UseCipher('Encrypt', input);
        resultEncrypt = [resultEncrypt, output];
    end
    
    if isempty(i)
        i = 0;
    end
    
    if i*INPUT_LENGTH < size(hexFullText, 1)
        hexText = hexFullText(INPUT_LENGTH*i+1:end, :);
        if size(hexText, 1) < 16
            for ii = 1:16-size(hexText, 1)
                hexText(end+1, :) = '20';
            end
        end
        tmp = cellstr(hexText);
        input = strcat(tmp{:});
        output = UseCipher('Encrypt', input);
        resultEncrypt = [resultEncrypt, output];
    end
    
    encryptedMsg = resultEncrypt;

end