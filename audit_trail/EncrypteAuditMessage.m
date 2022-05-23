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