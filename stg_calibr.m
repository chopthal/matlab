% 2020. 10. 23

% iMeasy_M_v1_1_0 -> iMeasy_Multi_v1.0.0

% comm2port input 'app'

% function calibr_err = stg_calibr
function calibr_err = stg_calibr(app)

% global Main_port StgStepFile StageList max_step;
global StgStepFile StageList max_step;

calibr_err = 0;

% [~] = comm2port('Main_port', '$S#Z#B#40000', []);
[~] = comm2port(app, 'Main_port', '$S#Z#B#40000', []);

for i = 1:length(StageList)
    
    Stage = StageList{i};
    
    eval(sprintf('global max_step_%s;', Stage));
    
    eval(sprintf(...
        'RX_%sB = comm2port(app, ''Main_port'', ''$S#%s#B#%d'', []);',...
        Stage, Stage, max_step));        
    eval(sprintf('err_%sB = ~strcmp(RX_%sB, ''$S#%s#B#%d#EM'');', Stage, Stage, Stage, max_step));    

    eval(sprintf(...
        'RX_%sF = comm2port(app, ''Main_port'', ''$S#%s#F#%d'', []);',...
        Stage, Stage, max_step));            
    eval(sprintf('err_%sF = ~strcmp(RX_%sF, ''$S#%s#F#%d#EM'');', Stage, Stage, Stage, max_step));    

    eval(sprintf('max_step_%s = comm2port(app, ''Main_port'', ''$S#S'', []);', Stage, Stage));
    eval(sprintf('max_step_%s = str2double(max_step_%s(6:(end-3)));', Stage, Stage));
    
    eval(sprintf('max_step_ = max_step_%s;', Stage));
    
    if isempty(max_step_)
        
        eval(sprintf('err_%sS = 1;', Stage));
        
    else
        
        eval(sprintf('err_%sS = 0;', Stage));
        
    end
    
end

if err_XB||err_XF||err_XS||err_YB||err_YF||err_YS||err_ZB||err_ZF||err_ZS
    
    for i = 1:length(StageList)
    
        Stage = StageList{i};

        eval(sprintf('max_step_%s = [];', Stage));


    end
    
    calibr_err = 1;
    
else
    
    for i = 1:length(StageList)
    
        Stage = StageList{i};
        
        eval(sprintf('global %s_abs_step;', Stage));
        
        eval(sprintf('%s_abs_step = 0;', Stage));
        
    end
    
    save(StgStepFile, 'max_step_X', 'max_step_Y', 'max_step_Z');
            
end

