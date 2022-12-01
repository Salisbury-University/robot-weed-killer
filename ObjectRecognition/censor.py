import winsound, keyboard # import winsound for beeping, and keyboard to read press

# set beep frequency & duration
frequency = 1000
duration = 750

# listens for keyboard input to play beep
while True:
    if keyboard.read_key() != "":
        winsound.Beep(frequency, duration)
