import keyboard,serial, time
ser=serial.Serial('com5',9600)
while True:
    if keyboard.is_pressed('w'):
        ser.write(b'f')
    elif keyboard.is_pressed("s"):
        ser.write(b'b')
    elif keyboard.is_pressed("d"):
        ser.write(b'r')
    elif keyboard.is_pressed("a"):
        ser.write(b'l')
    elif keyboard.is_pressed(" "):
        ser.write(b'+')
    else:
        ser.write(b's')
        ser.write(b'-')
