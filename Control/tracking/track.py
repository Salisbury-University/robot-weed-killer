import cv2
import numpy as np
import requests
import urllib
import time
import serial

# Initialize the serial connection to the robot
ser = serial.Serial('com4', 9600)

# Define the IP address of the camera
CAMERA_IP = "http://192.168.4.1/cam-lo.jpg"

# Define the lower and upper bounds of the green color we want to track
lower_green = np.array([25, 52, 72])
upper_green = np.array([102, 255, 255])

while True:
    # Get the current image from the camera
    try:
        img_resp = requests.get(CAMERA_IP)
        img_arr = np.array(bytearray(img_resp.content), dtype=np.uint8)
        frame = cv2.imdecode(img_arr, -1)
    except Exception as e:
        print(f"Error getting image from camera: {e}")
        continue

    # Convert the frame to the HSV color space
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    # Threshold the frame to get only the green objects
    mask = cv2.inRange(hsv, lower_green, upper_green)

    # Find the contours of the green objects
    contours, hierarchy = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

    # If we find any green objects
    if len(contours) > 0:
        # Find the largest contour (i.e. the object that is closest to the camera)
        largest_contour = max(contours, key=cv2.contourArea)

        # Find the area of the largest contour
        area = cv2.contourArea(largest_contour)

        # If the area of the contour is not zero
        if area > 0:
            # Find the centroid of the largest contour
            M = cv2.moments(largest_contour)
            cx = int(M['m10'] / M['m00'])
            cy = int(M['m01'] / M['m00'])

            # Send commands over the serial connection to drive towards the object
            # (You will need to define the commands for your specific robot)
            # For example, you might send the commands: "forward", "left", "right", etc.
            if cx < 320:
                ser.write(b'l')
            else:
                ser.write(b'r')

            if cy < 240:
                ser.write(b'f')
            else:
                ser.write(b's')

    # Display the webcam stream with the green objects highlighted
    cv2.imshow("Camera Feed", cv2.bitwise_and(frame, frame, mask=mask))

    # Exit the program if the 'q' key is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release the camera capture and close the serial connection

ser.close()

# Destroy all windows
cv2.destroyAllWindows()
