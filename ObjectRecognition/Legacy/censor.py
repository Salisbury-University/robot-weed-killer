import winsound, time, keyboard
print ("Press space to bleep.")
while True:
    if (keyboard.is_pressed(57)):
        winsound.Beep(1000, 1000) 