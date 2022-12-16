# Roundup: Robot Control App
## Course: COSC 425/426
## Client: Dr. Giulia Franchi


# Team: Kids Against Weed
# Product: RoundUp (Not the chemical)
---
# Teammates:
* Zach Moore
* Emily Hitchcock
* Garrett Jolly
* Nick Krisulevicz
* Dane Akers
---
# Contents of Repository:

## Control:
* Contains code to run the robot
* Written in Arduino code
* Activates laser and powers wheels

## Camera:
* Contains code to run the ESP32 camera
* Written in Arduino code
* Allows camera to set up web server
* Web server has an IP address that the app connects to
* Streams video to the web server

## Images:
* Contains images for the user interface
* Contains images for the app logo and splash screen
* Contains reticule for laser point of impact in app

## Legacy:
* Contains code, files and instructions from previous group who worked on the project
* Much of the contents of this directory have been phased out or changed by current team

##B luetooth Module:
* Contains code to allow data stream from bluetooth module on robot
* Written in Arduino code
* Allows for external devices to provide commands to the robot to execute

## Object Recognition
* Contains code to process image signal from the ESP32 camera
* Using Python with the OpenCV library

---
# Accomplishments:

## Zach Moore
  - ReactNative app development
  - Installed app on provided
  - Formatted and started use of the GitHub repository
  - Created main branch and test branch of repository
  - Worked with ReactNippleJS before it was scrapped
  - Linked a library for ReactNippleJS
  - Researched implementation for WiFi Reborn
  - Made executive decision with team to switch to Flutter
  - Created byte stream from app on phone to send inputs to robot
  - Created functinonality in app with Flutter
  - Refined robot inputs to control the robot more precisely
  - Got the video stream from the web host to play on the app
  - Survived high blood pressure with minimal years shaved off expected lifespan

## Emily Hitchcock
  - React Native app development
  - Created user interface in React Native
  - Researched best components, widgets, and packages to use for the UI
  - Recreated the React Native UI in Flutter
  - Styled the app to appeal to user and provide usability
  - Positioned all buttons and UI features in user-friendly fashion
  - Added function to visual user interface features

## Garrett Jolly
  - Completed Arduino code to run the robot and operate laser
  - Implemented code to operate robot wirelessly
  - Fine tuned robot to respond to user input and drive accordingly
  - Programmed bluetooth module to establish connection
  - Created outputs from the Arduino based on the pins on the board
  - Added bluetooth functionality to robot
  - Created web host for camera 

## Dane Akers
  - Optimized cable mamagement on robot
  - Installed bluetooth module
  - Installed laser and wired it up
  - Fixed damaged motor mount and corrected camber of drive wheels
  - Created wiring harness out of loose wires for motor power
  - Fixed broken motor mount
  - Installed camera onto the robot
  - Spliced wiring harness for camera for power and video transmitting
  - Got video to stream from camera on robot to web host

## Nick Krisulevicz
  - Researched and found camera
  - Made executive decision to remove HuskyLens camera after hardware limitation was discovered
  - Worked on hardware repairs with Dane
  - Administrative tasks and organized client and professor meetings
  - Implemented HuskyLens code, which was subsequently scrapped when HuskyLens was ruled out
  - Implemented ESP32 camera code
  - Installed mount for camera to attach it to the robot
  - Updated readme on a per-meeting basis
  - Organized directories in the repository
  - Provided comments for all uncommented code
