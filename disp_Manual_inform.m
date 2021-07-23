% 2020. 09. 29

% iMeasy-m_v1.1.0 -> iMeasy_Multi_v1.0.0

% handles -> app

% function disp_Manual_inform
function disp_Manual_inform(app)

% global MAIN_app cur_Chip X_abs_um Y_abs_um...
%     frame_W_um frame_H_um;
global X_abs_um Y_abs_um frame_W_um frame_H_um

% app = MAIN_app;

% contents = cellstr(get(app.popupmenu_chip, 'String'));
% str1 = contents{cur_Chip};
str1 = get(app.popupmenu_chip, 'Value');
Xmm = X_abs_um/1000;
Ymm = Y_abs_um/1000;

stStr = sprintf('Chip: %s,   X: %.1f mm,   Y: %.1f mm', str1, Xmm, Ymm);
set(app.text_Status, 'Text', stStr)
% eval(sprintf('set(app.text_Status, ''String'', ''Chip: %s,   X: %.1f mm,   Y: %.1f mm'');',...
%     str1, Xmm, Ymm));

plot(app.axes_Manual, Xmm, Ymm, 'ro', 'MarkerFaceColor', 'r');
hold(app.axes_Manual, 'on');
plot(app.axes_Manual, [0, frame_W_um/1000], [Ymm, Ymm], 'r-');
plot(app.axes_Manual, [Xmm, Xmm], [0, frame_H_um/1000], 'r-');
hold(app.axes_Manual, 'off');
set(app.axes_Manual, 'XLim', [0, frame_W_um/1000]);
set(app.axes_Manual, 'YLim', [0, frame_H_um/1000]);
set(app.axes_Manual, 'YDir', 'reverse');
set(app.axes_Manual, 'XTickLabel', []);
set(app.axes_Manual, 'YTickLabel', []);