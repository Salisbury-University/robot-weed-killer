import numpy as np
import cv2

cap = cv2.VideoCapture(0) # video capture
# main loop
while True:

	_, imageFrame = cap.read() # read from camera feed

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
	for pic, contour in enumerate(contours):
		area = cv2.contourArea(contour)
		if(area > 300):
			x, y, w, h = cv2.boundingRect(contour)
			imageFrame = cv2.rectangle(imageFrame, (x, y),
									(x + w, y + h),
									(0, 255, 0), 2)
			cv2.putText(imageFrame, "Green Color", (x, y),
						cv2.FONT_HERSHEY_SIMPLEX,
						1.0, (0, 255, 0))

	# quit on 'q' press
	cv2.imshow("Green Detection", imageFrame)
	if cv2.waitKey(10) & 0xFF == ord('q'):
		cap.release()
		cv2.destroyAllWindows()
		break