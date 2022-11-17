These control functions are deprecated in the sense of they are not tied to the Flutter app build of the project.

The serial folder contains the Arduino code for the device to read serial input for driving and laser firing, along with the Python code to drive the car through a command prompt.

The bluetooth folder contains the Arduino code for the device to read serial input over bluetooth to drive and fire the laser, along with the Python code to initiate a bluetooth connection and send commands to the car. Connection to the bluetooth module is needed to be initiated from device settings beforehand, or Python cannot esablish the conneciton. The com port may need to be adjusted as nessecary.
