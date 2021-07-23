% 2021. 01. 11

% iMeasy_Multi_v1.0.0 -> easySCAN_v1.1.0

% Change Function name from ResetXY

% function ResetXY(app)
function ResetStage(app, stageMatrix)

% stageMatrix : [is X, is Y, is Z]. is X, Y, Z = 0 (false) or 1 (true).

% global X_curDir X_abs_um MovDiff_um Y_curDir Y_abs_um Reset_flag
global X_curDir X_abs_um MovDiff_um Y_curDir Y_abs_um Reset_flag...
    Z_curDir Z_abs_um

Reset_flag = 1;

if stageMatrix(1) == 1

    TX = strcat('$S#', 'X', '#', 'F', '#', '999999');
    [~] = comm2port(app, 'Main_port', TX, []);                
    X_curDir = 'B';
    X_abs_um = MovDiff_um;
    set(app.edit_X, 'Value', X_abs_um);
    
end

if stageMatrix(2) == 1

    TX = strcat('$S#', 'Y', '#', 'F', '#', '999999');
    [~] = comm2port(app, 'Main_port', TX, []);        
    Y_curDir = 'B';
    Y_abs_um = MovDiff_um;
    set(app.edit_Y, 'Value', Y_abs_um);
    
end

if stageMatrix(3) == 1
    
    TX = strcat('$S#', 'Z', '#', 'F', '#', '999999');
    [~] = comm2port(app, 'Main_port', TX, []);        
    Z_curDir = 'B';
    Z_abs_um = MovDiff_um;
    set(app.edit_Z, 'Value', Z_abs_um);
    
end

Reset_flag = 0;