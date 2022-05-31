%% Data type : matrix (numeric)
clear; close all;
fileName = 'numeric.abc';
x = 0;
fileId = fopen(fileName, 'w');
for i = 1:3600
    x = x+1;    
    y = rand(1) * 20000;
    fwrite(fileId, EncryptData([x, y]), 'double');    
end

fclose(fileId);

fileId = fopen(fileName, 'r');
dataRead = fread(fileId, 'double');
fclose(fileId);
dataRead = DecryptData(dataRead);
x = dataRead(1:2:end);
y = dataRead(2:2:end);
result = [x, y];
plot(x, y);


%% Data type : string
fileName = 'string.abc';
fileId = fopen(fileName, 'w');

orgString = 'abcd -> efgh /n';
doubleOrgString = EncryptData(double(orgString));
fwrite(fileId, doubleOrgString, 'double');    
orgString = 'ijkl -> mnop /n';
doubleOrgString = EncryptData(double(orgString));
fwrite(fileId, doubleOrgString, 'double');
fclose(fileId);

fileId = fopen(fileName, 'r');
dataRead = fread(fileId, 'double');
dataRead = DecryptData(dataRead);
fclose(fileId);
charData = char(dataRead');
disp(charData);


%% Encryption

function encryptedData = EncryptData(orgData)
    encryptedData = orgData * 2 + 3;
end


function decryptedData = DecryptData(encryptedData)
    decryptedData = (encryptedData - 3) / 2;
end