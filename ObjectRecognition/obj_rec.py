import cv2
import urllib.request
import numpy as np

url='http://192.168.4.1/cam-lo.jpg' # ip for camera stream
cv2.namedWindow("live transmission", cv2.WINDOW_AUTOSIZE) # window to show livestream

while True:
    img_resp=urllib.request.urlopen(url)
    imgnp=np.array(bytearray(img_resp.read()),dtype=np.uint8)
    imageFrame=cv2.imdecode(imgnp,-1)
    hsvFrame = cv2.cvtColor(imageFrame, cv2.COLOR_BGR2HSV) # convert brg to hsv

	# range for detecting green
    green_lower = np.array([25, 52, 72], np.uint8)
    green_upper = np.array([102, 255, 255], np.uint8)
    green_mask = cv2.inRange(hsvFrame, green_lower, green_upper)
	
    kernal = np.ones((5, 5), "uint8") # transform & dilation to track specific color
	
	# For green color
    green_mask = cv2.dilate(green_mask, kernal)
    res_green = cv2.bitwise_and(imageFrame, imageFrame, mask = green_mask)

	# contour to track green
    contours, hierarchy = cv2.findContours(green_mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    for pic, contour in enumerate(contours): # loop through the contours
        area = cv2.contourArea(contour)
        if(area > 300):
            x, y, w, h = cv2.boundingRect(contour) # coordinates to draw the rectangle
            imageFrame = cv2.rectangle(imageFrame, (x, y), (x + w, y + h), (0, 255, 0), 2) # draw rectangle
            cv2.putText(imageFrame, "Green Color" + " ({}, {})".format(x, y), (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0)) # show text and coordinates
            print("Found green object at ({}, {})".format(x, y)) # print found object to console
 
    cv2.imshow("Green Detection", imageFrame) # show processed image frame

    # quit condition (q)
    key=cv2.waitKey(5)
    if key==ord('q'):
        break

# closes program
cv2.destroyAllWindows()