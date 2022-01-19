close force all; clear;
x = [0:100];
y1 = x.^2;
y2 = x.^2 + 1000;
y3 = x.^2 - 1000;

fig = uifigure(1);
ax = uiaxes(fig);
hold(ax, 'on'); line.p1 = plot(ax, x, y1);
hold(ax, 'on'); line.p2 = plot(ax, x, y2, '--');
hold(ax, 'on'); line.p3 = plot(ax, x, y3);

legend([line.p1, line.p2, line.p3], 'line1', 'line2', 'line3')