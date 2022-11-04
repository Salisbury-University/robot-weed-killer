# for Python control of Arduino over wired serial connection
import keyboard, serial
ser=serial.Serial('/dev/rfcomm0',9600) # declare serial object
# main loop
while True:
    if keyboard.is_pressed(" "): # activates laser and stops car
        ser.write(b's')
        ser.write(b'+')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('a'): # handling forward and left simultanious input (turns left)
        ser.write(b'-')
        ser.write(b'q')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('d'): # handling forward and right simultanious input (turns right)
        ser.write(b'-')
        ser.write(b'e')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('a'): # handling backward and left simultanious input (turns right)
        ser.write(b'-')
        ser.write(b'z')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('d'): # handling backward and right simultanious input (turns left)
        ser.write(b'-')
        ser.write(b'c')
    elif keyboard.is_pressed('w'): # goes forward & deactivates laser
        ser.write(b'-')
        ser.write(b'f')
    elif keyboard.is_pressed("s"): # goes backward & deactivates laser
        ser.write(b'-')
        ser.write(b'b')
    elif keyboard.is_pressed("d"): # goes right & deactivates laser
        ser.write(b'-')
        ser.write(b'r')
    elif keyboard.is_pressed("a"): # left forward & deactivates laser
        ser.write(b'-')
        ser.write(b'l')
    else: # handles no input (stops car and deactivates laser)
        ser.write(b's')
        ser.write(b'-')
