function idx = Str2Idx(str)

% idx = [column, row]
% example) 'B-12' -> [1, 2]

row = double(str(1)) - double('A') + 1;
col = 12 - str2double(str(3:end)) + 1;

idx = [col, row];