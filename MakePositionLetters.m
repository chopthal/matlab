% direction = 'Left';
% width = 16; % Letter
% height = 24; % Number

function result = MakePositionLetters(direction, width, height)

% 384 well : 16 x 24 (width x height)
% 96 well : 8 x 12
% 48 well : 6 x 8
% 12 well : 3 x 4

letters = char([65:1:65+width-1]); % char(65) = 'A'
result = cell(height, width);

for w = 1:width
    for h = 1:height      
        result{h, w} = [direction, ' ', letters(w), num2str(h)];
    end
end

result = result(:);
