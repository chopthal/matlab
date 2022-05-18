function img = MakeBackground(img)

img.Background = cell(1, 8);

for i = 1:size(img.Background, 2)
    
    img.Background{i} = zeros(100, 100, 3);
    img.Background{i} = double(img.Background{i});
    
    for ii = 1:size(img.Background{i}, 3)
    
        img.Background{i}(:, :, ii) = double(img.Color{i}(ii, 1))/2^8;
        
    end
    
end