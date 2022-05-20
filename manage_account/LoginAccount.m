function isLoggedIn = LoginAccount(id, password)

isLoggedIn = false;

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
else
    disp('Invalid Password!')
end

end