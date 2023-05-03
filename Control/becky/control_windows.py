# for Python control of Arduino w/ Bluetooth module HM-06
import keyboard, serial
bluetooth=serial.Serial('com4',9600) # declare serial object (com# differs on Windows machine, for Linux use file from /dev/)
# main loop
while True:
    if keyboard.is_pressed(" "): # activates laser and stops car
        bluetooth.write(b's')
        bluetooth.write(b'+')
        print('laser')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('a'): # handling forward and left simultanious input (turns left)
        bluetooth.write(b'-')
        bluetooth.write(b'q')
        print('wa')
    elif keyboard.is_pressed('w') and keyboard.is_pressed('d'): # handling forward and right simultanious input (turns right)
        bluetooth.write(b'-')
        bluetooth.write(b'e')
        print('wd')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('a'): # handling backward and left simultanious input (turns right)
        bluetooth.write(b'-')
        bluetooth.write(b'z')
        print('as')
    elif keyboard.is_pressed('s') and keyboard.is_pressed('d'): # handling backward and right simultanious input (turns left)
        bluetooth.write(b'-')
        bluetooth.write(b'c')
        print('sd')
    elif keyboard.is_pressed('w'): # goes forward & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'f')
        print('w')
    elif keyboard.is_pressed("s"): # goes backward & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'b')
        print('s')
    elif keyboard.is_pressed("d"): # goes right & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'r')
        print('d')
    elif keyboard.is_pressed("a"): # left forward & deactivates laser
        bluetooth.write(b'-')
        bluetooth.write(b'l')
        print('a')
    elif keyboard.is_pressed("l"): # activates the robot dance function
        bluetooth.write(b'-')
        bluetooth.write(b'p')
        print('l')
    elif keyboard.is_pressed("t"):
        bluetooth.write(b'-')
        bluetooth.write(b't')
        print('auto on')
    elif keyboard.is_pressed("y"):
        bluetooth.write(b'-')
        bluetooth.write(b'y')
        print('auto off')
    else: # handles no input (stops car and deactivates laser)
        bluetooth.write(b's')
        print('s')
        bluetooth.write(b'-')