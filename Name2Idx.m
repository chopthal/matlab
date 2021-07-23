function idx = Name2Idx(name)

% Cell to cell
% Empty cell to empty

idx = zeros(length(name), 1);

for i = 1:length(name)
    
    if isempty(name{i})
        
        idx(i, 1) = 0;
        
    else
                
        nameStr = name{i, 1};
        colChar = nameStr(1);
        rowNum = str2double(nameStr(3:end));

        colNum = double(colChar)-64;
        rowNum = 12 - rowNum + 1;

        idx(i, 1) = 8 * (rowNum-1) + colNum;
        
    end
    
end


% A-12 => 1, H-1 => 96