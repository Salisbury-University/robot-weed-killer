#keyboard for reading user input, serial for sending bytes to arduino
import keyboard,serial
#create our serial named ser
ser=serial.Serial('com5',9600)
#infinite loop to read user input
while True:
    if keyboard.is_pressed('w'):
        #sends forward signal
        ser.write(b'f')
    elif keyboard.is_pressed("s"):
        #sends reverse signal
        ser.write(b'b')
    elif keyboard.is_pressed("d"):
        #sends turn right signal
        ser.write(b'r')
    elif keyboard.is_pressed("a"):
        #sends turn left signal
        ser.write(b'l')
    elif keyboard.is_pressed(" "):
        #sends laser fire signal
        ser.write(b'+')
    else:
        #sends stop brake and disable laser signal
        ser.write(b's')
        ser.write(b'-')
