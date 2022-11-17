/// ChatPage.dart
/// Allows any smartphone with this app installed to connect to the HC-05
/// module and send byte messages to it which communicates with the Arduino MEGA.
/// Import needed to use BluetoothDevice objects, and testing connections.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

/// Name: ChatPage
/// Type: Class extending StatefulWidget
/// Purpose: The class ChatPage is created and extends a Stateful widget
///         because its state relies on the other class _ChatPage as the state
///         is constantly changing whenever a device is connnected or disconnected.
///         If messages are being sent, the state must be set when the messages are
///         encoded to UTF-8 for Arduino interpretation
///
class ChatPage extends StatefulWidget {
  /// Server is a variable declared for communicating with the bluetooth device, and its
  /// type is found in the flutter_bluetooth_serial package.
  /// Variables of any type that are declared in a class that extends StatefulWidget MUST
  /// be immutable, because StatefulWidget inherits widget, which is, @immutable.
  final BluetoothDevice server; // final is immutable

  const ChatPage(
      {required this.server}); // const is also an immutable assignment

  @override
  _ChatPage createState() => new _ChatPage();
}

/// Name: _Message
/// Type: Class
/// Purpose: The class holds instances of message data sent to the bluetooth
///          device.
class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

/// Name: _ChatPage
/// Type: Class -- extends the State of ChatPage that was created
/// Purpose: _ChatPage will contain all of the functions and assignments necessary
///           for the chat page to function properly. It uses the state created
///           by the StatefulWidget in ChatPage to change the state of the Widget to
///           account for changes, connetions, and disconnects.
/// Methods Contained: initState(), dispose(), _onDataReceived(Uint8List), and _sendMessage(String)
class _ChatPage extends State<ChatPage> {
  static final clientId = 0;

  /// Any delcaration or use of variables that are possibly null must either be conditionally tagged
  /// or null checked. Conditionally tagging a variable: TypeName? var;
  /// Null Checking a variable: TypeName var!;
  /// Conditional Tags and Null checking is REQUIRED as of Flutter v: 2.2.0
  BluetoothConnection? connection;
}
