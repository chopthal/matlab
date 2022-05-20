function GenerateAccount(id, password, tier)

% id : string
% password : string
% tier : string

MIN_PASSWORD_LENGTH = 5;
MAX_PASSWORD_LENGTH = 20;

if length(password) < MIN_PASSWORD_LENGTH
    fprintf('Password should be longer than %d words\n', MIN_PASSWORD_LENGTH);
    return;
end

if length(password) > MAX_PASSWORD_LENGTH
    fprintf('Password should be shorter than %d words\n', MAX_PASSWORD_LENGTH);
    return;
end

Accounts = struct;
hashedPassword = StringToHashedHex(password);

if isfile('accounts.mat')
    loadedVariable = load('accounts.mat');
    Accounts = loadedVariable.Accounts;
end

if isempty(fieldnames(Accounts))    
end

if isfield(Accounts, id)
    disp('Exist ID');
    return;
end

Accounts.(id).Password = hashedPassword;
Accounts.(id).Tier = tier;
save('accounts.mat', 'Accounts');

end