fig = uifigure;
fig.Position = [100, 100, 800, 600];
g = uigridlayout(fig);

ax = uiaxes(g);
ax.Layout.Row = 1;
ax.Layout.Column = 1;
tb = uitable(g);
tb.Layout.Row = 2;
tb.Layout.Column = 1;

g.RowHeight = {'2x', '1x'};
g.ColumnWidth = {'1x'};