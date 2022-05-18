% 2020. 02. 20

% iMLH300_v1.1.1

% Fixing error on first connection.
% Adding function
% - comm2portExcReconn.m


function [RX_out, Err] = comm2portExcReconn(TgtPortStr, TX, RX_wanted)

eval(sprintf('global %s;', TgtPortStr));

eval(sprintf('TgtPort = %s;', TgtPortStr));
RX_out = [];
Err = 0;

flushinput(TgtPort);
% CTX = strcat(call_sign, TX);

try

    fprintf(TgtPort, TX);
    
catch
    
    Err = 1;           

    return;
    
end

t = 0;
tic;

while (TgtPort.BytesAvailable==0)&&(t<TgtPort.Timeout)

    pause(0.05);
    
    t = toc;
    
end

ret = fscanf(TgtPort);
RX_out = ret(1:(end-1));

if (isempty(ret))
   
    Err = 1;   
    
    return;
    
end

if ~isempty(RX_wanted)
    
    if ~strcmp(RX_out, RX_wanted)    

        Err = 1;          
        
    end
    
end