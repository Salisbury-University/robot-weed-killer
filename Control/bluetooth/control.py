import keyboard,serial
bluetooth=serial.Serial('com6',9600)
bluetooth.flushInput()
while True:
    if keyboard.is_pressed('w') and keyboard.is_pressed('a'):
        bluetooth.write(b'q')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('d'):
        bluetooth.write(b'e')
    elif keyboard.is_pressed('w'):
        bluetooth.write(b'f')
    elif keyboard.is_pressed("s"):
        bluetooth.write(b'b')
    elif keyboard.is_pressed("d"):
        bluetooth.write(b'r')
    elif keyboard.is_pressed("a"):
        bluetooth.write(b'l')
    elif keyboard.is_pressed(" "):
        bluetooth.write(b'+')
    else:
        bluetooth.write(b's')
        bluetooth.write(b'-')