function img = InitColor

InitRange = 50;

img.Color = cell(1, 8);
img.Color{1} = uint8([255 InitRange; 0 InitRange; 0 InitRange]); % Red [R, range; G, range, B; range]
img.Color{2} = uint8([0 InitRange; 255 InitRange; 0 InitRange]); % Green
img.Color{3} = uint8([0 InitRange; 0 InitRange; 255 InitRange]); % Blue
img.Color{4} = uint8([255 InitRange; 255 InitRange; 0 InitRange]); % Yellow
img.Color{5} = uint8([0 InitRange; 0 InitRange; 0 InitRange]);
img.Color{6} = uint8([0 InitRange; 0 InitRange; 0 InitRange]);
img.Color{7} = uint8([0 InitRange; 0 InitRange; 0 InitRange]);
img.Color{8} = uint8([0 InitRange; 0 InitRange; 0 InitRange]);

img = MakeBackground(img);

img.Selected = 0;