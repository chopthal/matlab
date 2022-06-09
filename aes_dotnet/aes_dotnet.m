% For windows only
if ~NET.isNETSupported
    disp('#NET is not supported in this system.')
    return
end

import System.*;

key = 'zoic-voi_qawe.krnkosjdiod1fjasdf'; % length : 32
iv = 'c8xpc3iojdx!pijr'; % length : 16

length(iv)

str = char(floor(rand(1, 3948753) * (double('z') - double('A') + 1) + double('A')));
% str = char(floor(rand(1, 58) * (126 - 32 + 1) + 32));
% str = sprintf('cxiojaio -> \nsaodifjasodifasdfsioadjfioasjioj   asiodfjiopasdjfo iopasdjfiopasdjf  aipsdjfiopasdfjopasifj8924u9384 89 3#$#$#-> %%34984u398iojzo   '); 
modStr = mod(length(str), 16);
if modStr > 0
    str = [str blanks(16 - modStr)]; % Dummy strings for encryption
end
disp(str);
input = String(str);
encrypted = AesEncrypt(input, key, iv);
input = String(encrypted);
decrypted = AesDecrypt(input, key, iv);
disp(decrypted);
strcmp(str, decrypted)


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


