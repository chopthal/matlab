% Connect to device
portList = serialportlist("available");
port = "COM3";
baudrate = 9600;

s = serialport(port, baudrate);
s.Terminator = 'CR';
s.BytesAvailableFcnCount = 40;
s.BytesAvailableFcnMode = 'terminator';
s.BytesAvailableFcn = {@instrcallback};

protocol = "$L#1#ON#100";
writeline(s, protocol)