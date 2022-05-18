function hashedHex = stringToHashedHex(string)

salt = 'salt';
sha256hasher = System.Security.Cryptography.SHA256Managed;
saltedString = strcat(string, salt);
sha256 = uint8(sha256hasher.ComputeHash(uint8(saltedString)));
hashedHex = sha256;

end