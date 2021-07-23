% 2020. 11. 27

% FS100_Player_v1_6_0 -> iMeasy_Multi_v1_0_6

% Don't use WAIT_handles
% Timeout 15 -> 1
% Default timeout : 40 (after reconnected successfully)

function TryReconnectPort(TgtPortStr)

% global WAIT_handles WAITstr DeviceName Ch1_Inten;

eval(sprintf('global %s;', TgtPortStr));

eval(sprintf('TgtPortComStr = %s.Port;', TgtPortStr));
eval(sprintf('EmptyChk = isempty(%s);', TgtPortStr));
        
if ~EmptyChk

    eval(sprintf('delete(%s);', TgtPortStr));

end

% try
%    
%     delete(WAIT_handles.figure1);
%     
% end

% eval(sprintf('WAITstr = ''Reconnecting the %s......'';', DeviceName));

% run WAIT.m; 

while 1
        
    try 
        
        eval(sprintf('%s = serial(TgtPortComStr);', TgtPortStr));  
        eval(sprintf(...
            'set(%s, ''BaudRate'', 9600, ''DataBits'', 8, ''parity'', ''none'', ''stopbits'', 1, ''FlowControl'', ''none'');',...
            TgtPortStr));
%         eval(sprintf('%s.Timeout = 0.1;', TgtPortStr));
        eval(sprintf('%s.Terminator = ''CR'';', TgtPortStr));
%         eval(sprintf('%s.Timeout = 15;', TgtPortStr));    
        eval(sprintf('%s.Timeout = 1;', TgtPortStr));    
        eval(sprintf('fopen(%s);', TgtPortStr));        
        
        tic;
        t = 0;

        while t<1

            t = toc;

        end
        
%         eval(sprintf('%s.Timeout = 40;', TgtPortStr));                                    
        break;
        
    end
    
    pause(0.05);
    
end