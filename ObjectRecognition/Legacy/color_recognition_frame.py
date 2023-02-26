import cv2 # import OpenCV 
import numpy as np  # import numpy for matrix stuff
cap = cv2.VideoCapture(0) # sets video capture to laptop webcam 0
# main loop
while True:
    _, frame = cap.read() # frame displays camera capture
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    lower_green = np.array([0, 120, 0]) # specified color range for green
    upper_green = np.array([255, 200, 255])
    
    mask = cv2.inRange(hsv, lower_green, upper_green) # mask creation for green colors in stream
    res = cv2.bitwise_and(frame, frame, mask = mask) # frame size
    
    cv2.imshow('frame', frame) # show frames
    cv2.imshow('mask', mask)
    cv2.imshow('res', res)
    
    key = cv2.waitKey(1) # listen for esc press for exit
    if key == 27: # escape key
        break

cap.release() # close image capture and created windows
cv2.destroyAllWindows()