clear; close force all;

fig = uifigure(1);

h = zoom(fig);
h.ActionPostCallback = @actionCallback;

p = pan(fig);
p.ActionPostCallback = @actionCallback;
ax = uiaxes(fig);
line1 = drawline(ax);

function actionCallback(src, event)
    disp(src)c 
    disp(event)
end