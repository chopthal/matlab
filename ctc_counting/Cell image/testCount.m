clear; close all;

bf20x = imread('D:\Users\user\Desktop\Cell image\10-Feb-2022 13-43-06\Grp1-U1(1)\1_BM.png');
fm20x = imread('D:\Users\user\Desktop\Cell image\10-Feb-2022 13-43-06\Grp1-U1(1)\1_FM.png');

fig1 = figure(1); ax1 = axes(fig1);
fig2 = figure(2); ax2 = axes(fig2);

cla(ax); hold(ax, 'on'); imshow(bf20x, 'Parent', ax);
cla(ax2); hold(ax2, 'on'); imshow(fm20x, 'Parent', ax2);

