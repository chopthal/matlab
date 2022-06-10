if ~ispc; disp('Not supported on this platform.'); return; end % For windows only

if ~NET.isNETSupported; disp('#NET is not supported in this system.'); return; end

import System.*;

KEY = '00000000000000000000111111111111'; % length : 32
IV = '2222222222333333'; % length : 16
BYTE_UNIT_LENGTH = 16;

% Generate random characters length of 1,000
str = char(floor(rand(1, 1000) * (double('z') - double('A') + 1) + double('A')));
modStr = mod(length(str), BYTE_UNIT_LENGTH);
if modStr > 0; str = [str blanks(BYTE_UNIT_LENGTH - modStr)]; end % Dummy strings for encryption (fit to 16 bytes)
disp(str);
input = String(str); % System.String
encrypted = AesEncrypt(input, KEY, IV);
disp(encrypted);
input = String(encrypted);
decrypted = AesDecrypt(input, KEY, IV);
disp(decrypted);
disp(strcmp(str, decrypted)); % Compare original strings and decrypted strings.


function output = AesEncrypt(input, key, iv)
    import System.*;
    import System.Text.*;
    import System.IO.*;
    import System.Security.Cryptography.*;

    aesAlg = Aes.Create();
    aesAlg.Key = Encoding.UTF8.GetBytes(key);
    aesAlg.IV = Encoding.UTF8.GetBytes(iv);
    aesAlg.Padding = PaddingMode.PKCS7;

    encryptor = aesAlg.CreateEncryptor(aesAlg.Key, aesAlg.IV);    
    msEncrypt = MemoryStream();
    csEncrypt = CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write);
    xXml = Encoding.UTF8.GetBytes(input);
    csEncrypt.Write(xXml, 0, xXml.Length);
    buf = msEncrypt.ToArray();    
    output = Convert.ToBase64String(buf, 0, buf.Length, Base64FormattingOptions.None);
    output = char(output);

    csEncrypt.Close; msEncrypt.Close;
end


function output = AesDecrypt(input, key, iv)
    import System.*;
    import System.Text.*;
    import System.IO.*;
    import System.Security.Cryptography.*;

    aesAlg = Aes.Create();    
    aesAlg.Key = Encoding.UTF8.GetBytes(key);
    aesAlg.IV = Encoding.UTF8.GetBytes(iv);   
    aesAlg.Padding = PaddingMode.None;

    decryptor = aesAlg.CreateDecryptor(aesAlg.Key, aesAlg.IV);    
    msDecrypt = MemoryStream();
    csDecrypt = CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Write);    
    xXml = Convert.FromBase64String(input);        
    csDecrypt.Write(xXml, 0, xXml.Length);    
    buf = msDecrypt.ToArray();        
    tmp = Encoding.UTF8.GetString(buf);
    output = char(tmp);

    csDecrypt.Close; msDecrypt.Close;
end


