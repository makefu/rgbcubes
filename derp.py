import serial
a= serial.Serial('/dev/ttyUSB0',115200)
#a= serial.Serial('/dev/ttyUSB0',9600)

import time
for i in range(10000):
    time.sleep(5)
    if i % 3== 0:
        print(1)
        a.write('BUTT\xFF\x00\x00')
        pass
    elif i % 3 == 1:
        print(2)
        a.write('BUTT\x00\xFF\x00')
        pass
    elif i % 3 == 2:
        print(3)
        a.write('BUTT\x00\x00\xFF')
    a.flush()
    #print(a.readline())
