stx = char(2);
etx = char(3);

delete(instrfind)

% Connect to device
% portName = seriallist;
portName = "COM10";
portDevice = serialport(portName, 9600);
configureTerminator(portDevice, "CR")
flush(portDevice)

% Check Status
flush(portDevice)
command = "61011001000152"; % ASCII
TX = strcat(stx, command, etx);
writeline(portDevice, TX)
response = read(portDevice, 16, "char");
RX = response(2:end-1);
% hexResponse = compose("%X", response);
hexRX = compose("%X", RX);
disp(RX)

% Software Revision
flush(portDevice)
command = "61011001000154"; % ASCII
TX = strcat(stx, command, etx);
writeline(portDevice, TX)
response = read(portDevice, 16, "char");
RX = response(2:end-1);
% hexResponse = compose("%X", response);
hexRX = compose("%X", RX);
disp(RX)

% Instrument Type : ALIAS Autosampler
flush(portDevice)
command = "61011001000186"; % ASCII
TX = strcat(stx, command, etx);
writeline(portDevice, TX)
response = read(portDevice, 16, "char");
RX = response(2:end-1);
% hexResponse = compose("%X", response);
hexRX = compose("%X", RX);
disp(RX)

% Action Tray
flush(portDevice)
command = "61100830000001";
TX = strcat(stx, command, etx);
writeline(portDevice, TX)
response = read(portDevice, 16, "char");
RX = response(2:end-1);
hexResponse = compose("%X", response);
hexRX = compose("%X", RX);
disp(response)
disp(hexResponse)

