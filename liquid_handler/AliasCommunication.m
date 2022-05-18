function rx = AliasCommunication(portDevice, stx, etx, id, ai, pfc, value)

if isempty(stx)   
    stx = char(2);    
else
    stx = char(stx);
end

if isempty(etx)    
    etx = char(3);  
else
    etx = char(etx);
end

if isempty(id)
    id = "61";    
end

if isempty(ai)
    ai = "01";
end

if isempty(pfc) || isempty(value)
    disp('PFC and Value are required fields!')
    rx = '';
    return
end

flush(portDevice)

tx = strcat(stx, id, ai, pfc, value, etx);
% disp(tx)
writeline(portDevice, tx)

if strcmp(pfc, '1000') || strcmp(pfc, '1001')
    readLength = 16;
else
    readLength = 1;
end
% response = read(portDevice, 16, "char");
response = read(portDevice, readLength, "char");
rx = response(2:end-1);

if strcmp(response, '')
    rx = 'ACK';
%     disp('ACK')
elseif strcmp(response, '')
    rx = 'NACK';
%     disp('NACK')
elseif strcmp(response, '')
    rx = 'NACK0';
%     disp('NACK0')
end

% rx = response(2:end-1);

% disp(rx)
% hexRX = compose("%X", RX);
% disp(hexRX)