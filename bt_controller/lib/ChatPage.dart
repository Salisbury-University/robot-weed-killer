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
  static final clientID = 0;

  /// Any delcaration or use of variables that are possibly null must either be conditionally tagged
  /// or null checked. Conditionally tagging a variable: TypeName? var;
  /// Null Checking a variable: TypeName var!;
  /// Conditional Tags and Null checking is REQUIRED as of Flutter v: 2.2.0
  BluetoothConnection? connection;

  // Uses List with the message class type that defines an empty list called 'messages'
  // growable: true allows for the list to grow from beyond null
  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = ''; // buffer to hold messages sent to BT device

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  /// Name: initState()
  /// Type: Method
  /// Parameters: None
  /// Returns nothing -- void
  /// Purpose: Initializes the state of the Chat Page, and sets the server address to
  ///           the bluetooth device in order to make a connection to the device. Sets the state
  ///           of the connecting and disconnecting processes to false after an initial connection
  ///           is made. Also throws errors if a connection cannot be established.
  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      // Uses listen.onDone(){} to check which side closes the bluetooth connection
      // if the isDisconnecting flag is set, then onDone should be fired as a result of
      // a local disconnection. After setting the state of the flag, dispose(), finish() and
      // close() can subsequently be called to finalize the disconnect.
      // If there is a remote disconnect (no flag set), then print the remote disconnection
      // message.
      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnected Locally;');
        } else {
          print('Disconnected Remotely');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
      // Used to catch an error upon failure to connect for any reason
    }).catchError((error) {
      print('Cannot connect, exception occurred');
      print(error);
    });
  }

  /// Name: dispose
  /// Type: Method
  /// Parameters: None
  /// Returns nothing -- void
  /// Purpose: Dispose is used to permanently remove the widget created from the widget tree. Any and all information and states assigned to local
  ///           variables will be released and freed from memory.
  @override
  void dispose() {
    // checks the connection and calls dispose() on itself to avoid a memory leak
    // setState
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    final serverName = widget.server.name ?? "Unknown";
    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to ' + serverName + '...')
              : isConnected
                  ? Text('Live chat with ' + serverName)
                  : Text('Chat log with ' + serverName))),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Wait until connected...'
                            : isConnected
                                ? 'Type your message...'
                                : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: isConnected
                          ? () => _sendMessage(textEditingController.text)
                          : null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
