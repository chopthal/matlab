fig = uifigure;
ax = uiaxes(fig);
% img = imread('C:\Users\tjckd\OneDrive\바탕 화면\Bioroots_사진\IMG_0369.jpg');
% imshow(img, 'Parent', ax)

asStartPos = [50, 0; 50, 100];
asEndPos = [100, 0; 100, 100];

ax.XLim = [0 150];
ax.YLim = [0 100];

lineAsStart = drawline('Parent', ax,...
     'Position', asStartPos, ...
     'Deletable', 0, ...
     'InteractionsAllowed', 'translate', ...
     'Label', 'Association Start', ...
     'LabelVisible', 'hover', ...
     'Color', [1 0 0], ...
     'LineWidth', 1);

lineAsEnd = drawline('Parent', ax,...
     'Position', asEndPos, ...
     'Deletable', 0, ...
     'InteractionsAllowed', 'translate', ...
     'Label', 'Association End', ...
     'LabelVisible', 'hover', ...
     'Color', [0 1 0], ...
     'LineWidth', 1);

disableDefaultInteractivity(ax)

%Setup         
% set(ax,'ylimmode','auto','xlimmode','auto'); %reset after image detroyed
h = zoom(ax); %build zoom object
% zoom reset; %store current setting

set(h,'ActionPostCallback',{@mypostcallback,h}); %set callback
set(h,'ActionPreCallback',{@myprecallback,h}); %set callback

[tb, btns] = axtoolbar(ax, {'export', 'zoomin', 'zoomout', 'restoreview'});

function mypostcallback(a,b,h) 
disp(a)
disp(b)
disp(h)
disp('post zoom')

b.Axes.Children(1).Position(:, 2) = b.Axes.YLim';
pause(0.01)

%     zdir = get(h); % get the handle
%     if(strcmp(zdir.Direction,'out')) %is it going out?
%         set(h,'ActionPostCallback',[]); %disable the call back to zoom out
%         zoom('out'); %zoom to original spot
%         set(h,'ActionPostCallback',{@mypostcallback,h}); %re-enable the callback
%     end
    
end


function myprecallback(~,~,h) 
    
    disp('pre zoom')    
    
end