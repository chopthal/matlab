% Connect to device
delete(instrfind)
portList = serialportlist("available");
port = "COM3";
baudrate = 9600;

s = serialport(port, baudrate);
s.Timeout = 1;
configureTerminator(s, "LF")
configureCallback(s, "terminator", @test_instrcallback)

TX = '$D#NAME';
writeline(s, TX)
% pause(1)

for i = 1:1000
    disp(i)
    t = tic;
    tend = 0;
    while tend < 1
        pause(0.01)
        tend = toc(t);
    end    
end