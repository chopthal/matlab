% 2021. 08. 09

% iMeasy_Multi_v1.0.0 -> easySCAN_v2.0.0

% 

function disp_Manual_inform_canvas(app)

% global X_abs_um Y_abs_um step_per_um_X step_per_um_Y cur_Chamb cur_Chip
global X_abs_um Y_abs_um CurrentChamber CurrentChip ChipInform

% eval(sprintf('global C%d_Chamb%d_X_um C%d_Chamb%d_Y_um', cur_Chip, cur_Chamb, cur_Chip, cur_Chamb));
% 
% eval(sprintf('C_Chamb_X_um = C%d_Chamb%d_X_um;', cur_Chip, cur_Chamb));
% eval(sprintf('C_Chamb_Y_um = C%d_Chamb%d_Y_um;', cur_Chip, cur_Chamb));

C_Chamb_X_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 1};
C_Chamb_Y_um = ChipInform(CurrentChip).ChamberRange{CurrentChamber, 2};

if (C_Chamb_X_um(2) - C_Chamb_X_um(1) == 0) || (C_Chamb_Y_um(2) - C_Chamb_Y_um(1) == 0)

    cla(app.axes_Canvas)
    set(app.axes_Canvas, 'Visible', 'off')
    return;
    
else
    
    set(app.axes_Canvas, 'Visible', 'on')
    
end

posX = floor(X_abs_um - C_Chamb_X_um(1));
posY = floor(Y_abs_um - C_Chamb_Y_um(1));

chamW = C_Chamb_X_um(2) - C_Chamb_X_um(1);
chamH = C_Chamb_Y_um(2) - C_Chamb_Y_um(1);

plot(app.axes_Canvas, posX, posY, 'ro', 'MarkerFaceColor', 'r')
hold(app.axes_Canvas, 'on')

plot(app.axes_Canvas, [0, chamW], [posY, posY], 'r-');
plot(app.axes_Canvas, [posX, posX], [0, chamH], 'r-');
hold(app.axes_Canvas, 'off')

set(app.axes_Canvas, 'XLim', [-2, chamW+2]);
set(app.axes_Canvas, 'YLim', [-2, chamH+2]);
set(app.axes_Canvas, 'YDir', 'reverse');
set(app.axes_Canvas, 'XTickLabel', []);
set(app.axes_Canvas, 'YTickLabel', []);

app.axes_Canvas.XLim(1) = app.axes_Canvas.XLim(1)-1;
app.axes_Canvas.XLim(2) = app.axes_Canvas.XLim(2)+1;
