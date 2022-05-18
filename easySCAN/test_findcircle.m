close all
clear all

GrayImg = imread('D:\Working\Newly\Bioroots\Maximultix\Running_SW\easySCAN\easySCAN_Git\26-Aug-2021 13-35-32\Droplet Counting Chip (Bigger)_1\Stitched_BM.png');

DiaMin = 8;
DiaMax = 15;
Sensitivity = 0.92;

[Centers, Radius, ~] = imfindcircles(GrayImg, [DiaMin DiaMax],...
    'ObjectPolarity', 'dark', 'Sensitivity', Sensitivity);

fig = figure;
ax = axes(fig);

imshow(GrayImg, 'Parent', ax)
viscircles(ax, Centers, Radius, 'Color', 'Red')
