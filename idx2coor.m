function coor = idx2coor(idx)

coor = zeros(size(idx, 1), 2);

for i = 1:size(idx, 1)
    
    [coor(i, 1), coor(i, 2)] = calcCoor(idx(i, 1));    
    
end


function [x, y] = calcCoor(idx)

y = floor(idx/8) + 1;
x = mod(idx, 8);

if x == 0
    
    y = y-1;
    x = 8;
    
end