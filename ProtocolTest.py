import serial
import serial.tools.list_ports as list_ports


def HexList2AsciiString(*hexLists):  
  concatAsciiList = []
  
  for hexList in hexLists:
    for hexUnit in hexList:      
      concatAsciiList.append(chr(int(hexUnit, 16)))
  asciiString = "".join(concatAsciiList)

  return asciiString


# Hex string list (Check the device Status)
# Fixed value
STX = ['02']
ID = ['36', '31']
ETX = ['03']
# Variable value
AI_status = ['30', '31']
PFC_status = ['31', '30', '30', '31']
VALUE_status = ['20', '20', '30', '31', '35', '32']

AI_clear = ['30', '31']
PFC_clear = ['34', '30', '30', '38']
VALUE_clear = ['20', '20', '20', '20', '20', '31']

AI = ['30', '31']
PFC = ['35', '35', '33', '30']
VALUE = ['20', '20', '20', '20', '20', '31']

# Boot ID part# : 0840.141
# SW (FW) part# : 0840.110
# Boot ID(Hardware version) : 2.10
# Software (firmware) version : 1.13
# Instrument type : 12(ALIAS Autosampler)
# TX = HexList2AsciiString(STX, ID, AI_status, PFC_status, VALUE_status, ETX)
TX = HexList2AsciiString(STX, ID, AI_clear, PFC_clear, VALUE_clear, ETX)
TX2 = HexList2AsciiString(STX, ID, AI, PFC, VALUE, ETX)

# Device connection
baudRate = 9600
# parity = None
dataBits = 8
# stopBits = 1
timeout = 0.75
terminator = "CR"
rxSize = 16

targetPort = 'COM4'

device = serial.Serial(port=targetPort, baudrate=baudRate, timeout=timeout)
device.flush()

# print(TX.encode())
# device.write(TX.encode())
# RX = device.read(size=16)
# print('TX =', TX)
# print('RX =', RX)


# for i in range(0, 100):
device.write(TX2.encode())
RX2 = device.read(size=16)
print('TX2 =', TX2)
print('RX2 =', RX2)
# print('RX_decode =', RX.decode())

# listPorts = list_ports.comports()
# device.in_waiting()
# device.writelines(lines)
# device.read(size)
# RX = device.read_until(expected=terminator, size=16)



