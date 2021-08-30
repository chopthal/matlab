function rx = AliasCommunication(portDevice, stx, etx, id, ai, pfc, value)

if isempty(stx)   
    stx = char(2);    
end

if isempty(etx)    
    etx = char(3);    
end

if isempty(id)
    id = "61";    
end

if isempty(ai)
    ai = "01";
end

if isempty(pfc) || isempty(value)
    disp('PFC and Value are required fields!')
    rx = [];
    return
end

flush(portDevice)

tx = strcat(stx, id, ai, pfc, value, etx);
writeline(portDevice, tx)
response = read(portDevice, 16, "char");
rx = response(2:end-1);

% disp(rx)
% hexRX = compose("%X", RX);
% disp(hexRX)