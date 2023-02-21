import cv2, winsound # import OpenCV for import, winsound for beep
frequency = 1000 # frequency of beep
duration = 500 # duration of beep
count = 0 # keep track of
cap = cv2.VideoCapture(0) # sets video capture to laptop webcam 0
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280) # sets capture resolution, scale to ESP32 camera resolution
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)
color = "NULL"
# main loop
while True:
    _, frame = cap.read() # frame displays camera capture
    hsv_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    height, width, _ = frame.shape

    # center coordinates
    cx = int(width / 2)
    cy = int(height / 2)

    # pick pixel value of center
    pixel_center = hsv_frame[cy, cx]
    hue_value = pixel_center[0]

    # defines color names to identify captured hue range
    if hue_value < 5:
        color = ""
    elif hue_value < 22:
        color = ""
    elif hue_value < 33:
        color = ""
    elif hue_value < 78:
        if color == "GREEN": # check for continous green centered in frame
            count += 1
        else:
            count = 0
        color = "GREEN"
    elif hue_value < 131:
        color = ""
    elif hue_value < 170:
        color = ""
    else:
        color = ""

    # check if camera is centered on green for 100 ticks
    if count > 100:
        winsound.Beep(frequency, duration) # beep
        count = 0 # reset count

    # identifies the center pixel
    pixel_center_bgr = frame[cy, cx]
    b, g, r = int(pixel_center_bgr[0]), int(pixel_center_bgr[1]), int(pixel_center_bgr[2])

    # displays color name on python window
    cv2.rectangle(frame, (cx - 220, 10), (cx + 200, 120), (255, 255, 255), -1)
    cv2.putText(frame, color, (cx - 180, 100), 0, 3, (b, g, r), 5)
    cv2.circle(frame, (cx, cy), 5, (25, 25, 25), 3)

    # creates frame for displaying camera feed
    cv2.imshow("Color Recognition", frame)
    key = cv2.waitKey(1) # listen for esc press for exit
    # exit key
    if key == 27:
        break

# close image capture and created windows
cap.release()
cv2.destroyAllWindows()
