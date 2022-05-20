function [isLoggedIn, tier] = LoginAccount(id, password)

isLoggedIn = false;
tier = '';

if isempty(id); disp('Enter the ID'); return; end
if isempty(password); disp('Enter the Password'); return; end

Accounts = struct;
hashedPassword = StringToHashedHex(password);

if isfile('accounts.mat')
    loadedVariable = load('accounts.mat');
    Accounts = loadedVariable.Accounts;
end

if ~isfield(Accounts, id)
    disp('Invalid ID');
    return;
end

if ~isfield(Accounts.(id), 'Password')
    disp('Invalid Account. Please contact the Administrator!');
    return;
end

if isequal(hashedPassword, Accounts.(id).Password)
    isLoggedIn = true;
    tier = Accounts.(id).Tier;
else
    disp('Invalid Password!')
end

end