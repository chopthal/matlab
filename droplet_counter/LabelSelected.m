function LabelSelected(app)

for i = 1:8

    Label_n = sprintf('Label_%d', i);            

    if i == app.img.Selected

        app.(Label_n).BackgroundColor = app.img.Color{i}(1:3, 1);

    else

        app.(Label_n).BackgroundColor = 'none';

    end

end

