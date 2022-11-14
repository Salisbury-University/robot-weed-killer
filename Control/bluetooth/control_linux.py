# for Python control of Arduino w/ Bluetooth module HM-06
import keyboard, serial
bluetooth=serial.Serial('/dev/rfcomm0',9600) # declare serial object
# main loop
while True:
    if keyboard.is_pressed(" "): # activates laser and stops car
        bluetooth.write(b's')
        bluetooth.write(b'+')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('a'): # handling forward and left simultanious input (turns left)
        bluetooth.write(b'-')
        bluetooth.write(b'q')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('d'): # handling forward and right simultanious input (turns right)
        bluetooth.write(b'-')
        bluetooth.write(b'e')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('a'): # handling backward and left simultanious input (turns right)
        bluetooth.write(b'-')
        bluetooth.write(b'z')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('d'): # handling backward and right simultanious input (turns left)
        bluetooth.write(b'-')
        bluetooth.write(b'c')
    elif keyboard.is_pressed('w'): # goes forward & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'f')
    elif keyboard.is_pressed("s"): # goes backward & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'b')
    elif keyboard.is_pressed("d"): # goes right & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'r')
    elif keyboard.is_pressed("a"): # left forward & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'l')
    else: # handles no input (stops car and deactivates laser)
        bluetooth.write(b's')
        bluetooth.write(b'-')
