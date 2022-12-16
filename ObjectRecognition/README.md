## Object & Color Recognition

```
This directory contains all files relating to the autonomous part of our project.
Both are sourced from external OpenCV projects, modified to fit our needs.

Note: to run all .py files, first install OpenCV. (can be done with 'pip install opencv-python')

color_recognition.py contains the OpenCV scripting to recognize specfied colors of the center of the provided camera image frame.
Using this, we can determine if our camera is looking at a weed (green), and allow firing of the laser.
This script will throw an error on non-windows devices, because it imports winsound which is tied to an OS call.

censor.py will play a beep on a windows machine upon button press
This is used to spare some of our feelings and morale when Zach's blood pressure is high and he yells at us :(

jk :)

Mohammerd
```
