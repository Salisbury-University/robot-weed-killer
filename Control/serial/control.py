import keyboard,serial
ser=serial.Serial('com3',9600)
while True:
    if keyboard.is_pressed('w') and keyboard.is_pressed('a'):
        ser.write(b'q')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('d'):
        ser.write(b'e')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('a'):
        ser.write(b'z')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('d'):
        ser.write(b'c')
    elif keyboard.is_pressed('w'):
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