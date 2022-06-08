clear all

key = "01234567890123456789012345678901"; % 32
iv = "0123456789012345"; % 16

str = char(floor(rand(1, 3200) * (double('z') - double('A') + 1) + double('A')));
disp(length(str));
disp(str);
input = System.String(str);
output = AESEncrypt(input, key, iv); % 64
disp(output);
output = System.String(output);
output = AESDecrypt(output, key, iv); % 32
disp(output);


function output = AESEncrypt(input, key, iv)      
    output = '';
    import System.*;
    import System.Text.*;
    import System.IO.*;
    import System.Security.Cryptography.*;

    aes = RijndaelManaged();
    aes.KeySize = 128;
    aes.BlockSize = 128;
    aes.Mode = CipherMode.CBC;
    aes.Padding = PaddingMode.PKCS7;
    aes.Key = Encoding.UTF8.GetBytes(key);
    aes.IV = Encoding.UTF8.GetBytes(iv);
    
    encrypt = aes.CreateEncryptor(aes.Key, aes.IV);
    
    ms = MemoryStream();
    cs = CryptoStream(ms, encrypt, CryptoStreamMode.Write);
    xXml = Encoding.UTF8.GetBytes(input);
    cs.Write(xXml, 0, xXml.Length);
    
    buf = ms.ToArray();
    
    output = Convert.ToBase64String(buf);
    output = char(output);
end


function output = AESDecrypt(input, key, iv)
    output = '';
    import System.*;
    import System.Text.*;
    import System.IO.*;
    import System.Security.Cryptography.*;

    aes = RijndaelManaged();
    aes.KeySize = 128;
    aes.BlockSize = 128;
    aes.Mode = CipherMode.CBC;
    aes.Padding = PaddingMode.PKCS7;
    aes.Key = Encoding.UTF8.GetBytes(key);
    aes.IV = Encoding.UTF8.GetBytes(iv);
    
    decrypt = aes.CreateDecryptor(aes.Key, aes.IV);
    
    ms = MemoryStream();
    cs = CryptoStream(ms, decrypt, CryptoStreamMode.Write);
    xXml = Convert.FromBase64String(input);
    cs.Write(xXml, 0, xXml.Length);
    
    buf = ms.ToArray();
    
    output = Encoding.UTF8.GetString(buf);
    output = char(output);

end