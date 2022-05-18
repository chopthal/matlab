function TextReset(app)

for i = 1:10

    LabelName = sprintf('Label_%d', i);
    app.(LabelName).Text = '0';
    
end