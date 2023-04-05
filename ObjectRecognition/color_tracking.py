import numpy as np
import cv2

try:
	print("Trying connection")
	cap = cv2.VideoCapture(0) # video capture
	print("Connected")
except:
	print("No connection :(")

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
	for pic, contour in enumerate(contours): # loop through the contours
		area = cv2.contourArea(contour)
		if(area > 300):
			x, y, w, h = cv2.boundingRect(contour) # coordinates to draw the rectangle
			imageFrame = cv2.rectangle(imageFrame, (x, y), (x + w, y + h), (0, 255, 0), 2) # draw rectangle
			cv2.putText(imageFrame, "Green Color" + " ({}, {})".format(x, y), (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0)) # show text and coordinates
		print("Found green object at ({}, {})".format(x, y)) # print found object to console
		'''
		# framesize 1024 x 768

		if(x > cap.get(cv2.CAP_PROP_FRAME_WIDTH)/2): # left side object
			print("Object to the left of the robot, turning left...")
			bluetooth.write('l')
		elif(x < cap.get(cv2.CAP_PROP_FRAME_WIDTH)/2): # right side object
			print("Object to the right of the robot, turning right...")
			bluetooth.write('r')
		else:
			print("No objects detected")
			
		'''
	# quit on 'q' press
	cv2.imshow("Green Detection", imageFrame)
	if cv2.waitKey(10) & 0xFF == ord('q'):
		cap.release()
		cv2.destroyAllWindows()
		break