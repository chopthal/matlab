function str = Idx2Str(idx)

% idx = [column, row]
% example) [1, 2] -> 'B-12'

rowStrFull = 'ABCDEFGH';

rowStr = rowStrFull(idx(2));
colNum = 12-idx(1) + 1;

str = sprintf('%s-%d', rowStr, colNum);