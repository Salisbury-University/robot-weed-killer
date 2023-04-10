# bt_controller

Flutter project that contains the main components of the mobile application. These components are: Menu, Manual Control Screen, and Automated Screen.

## Components

### Menu

* The landing page of the applicationp; this is the first page that shows up when the app is loaded on a mobile phone.
* Allows user to select from manual control of the robot, and automated pathing
* Bluetooth menu button expands popup to select any available devices to pair
* Preferred screen orientation is portrait mode

### Manual Control

* Uses the bluetooth connection data from the menu screen to enable manual control of the robot
* Comprised of a virtual joystick and fire button, layered on top of a webview widget
* Webview used to view camera perspective when controlling the robot.

### Automated View

* Contains a map widget that is currently in a picture-in-a-picture (ideally will expand upon gesture detected and replace camera view)
* No control buttons, will only handle any issues on disconnect
* Back button to return to the menu screen -> currently testing solutions to stop the robot if the user leaves either control page

## Getting Started

If this project is inherited by another Software Engineering Group, visit the docs below to learn how to write a first Flutter app and their "cookbook" for useful samples.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Navigator Class: Used to retain data across screens](https://api.flutter.dev/flutter/widgets/Navigator-class.html)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
