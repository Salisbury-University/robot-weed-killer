import cv2 # opencv

cap = cv2.VideoCapture(0) # sets video capture to laptop webcam 0
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 1280) # sets capture resolution, scale to ESP32 camera resolution
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 720)

# main loop
while True:
    _, frame = cap.read()
    hsv_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    height, width, _ = frame.shape

    cx = int(width / 2)
    cy = int(height / 2)

    # pick pixel value
    pixel_center = hsv_frame[cy, cx]
    hue_value = pixel_center[0]
    
    # defines color names to identify captured hue range
    color = "Undefined"
    if hue_value < 5:
        color = "RED"
    elif hue_value < 22:
        color = "ORANGE"
    elif hue_value < 33:
        color = "YELLOW"
    elif hue_value < 78:
        color = "GREEN"
    elif hue_value < 131:
        color = "BLUE"
    elif hue_value < 170:
        color = "VIOLET"
    else:
        color = "RED"
    
    # identifies the center pixel
    pixel_center_bgr = frame[cy, cx]
    b, g, r = int(pixel_center_bgr[0]), int(pixel_center_bgr[1]), int(pixel_center_bgr[2])

    # displays color name on python window
    cv2.rectangle(frame, (cx - 220, 10), (cx + 200, 120), (255, 255, 255), -1)
    cv2.putText(frame, color, (cx - 200, 100), 0, 3, (b, g, r), 5)
    cv2.circle(frame, (cx, cy), 5, (25, 25, 25), 3)
    
    # creates frame for displaying camera feed
    cv2.imshow("Frame", frame)
    key = cv2.waitKey(1)
    # exit key
    if key == 27:
        break
      
# close image capture and created windows
cap.release()
cv2.destroyAllWindows()