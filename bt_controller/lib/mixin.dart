// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

mixin BluetoothHandler<T extends StatefulWidget> on State<T> {
  // Initialize bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Get instance of bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track bt connection
  BluetoothConnection? connection;

  late int _deviceState;

  bool isDisconnecting = false;
  var _isSwitchOn = false;

  bool get isConnected => connection != null && connection!.isConnected;

  // Defined to show bluetooth device list
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;
  bool _isScreenOn = false;

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green[700]!,
    'offTextColor': Colors.red[700]!,
    'neutralTextColor': Colors.blue,
  };

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    enableBluetooth();

    // Listen for any state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leaks and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<bool?> enableBluetooth() async {
    // Retrieve current bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If bluetooth is off, turn it on first and retrieve paired devices
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // Retrieving and storing paired devices
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // to get list of paired devices; will catch a platform exception
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      debugPrint("Error");
    }

    // Unless the device state is "mounted" i.e: associated with the widget tree and attached to a BuildContext, setState will throw an error.
    // To prevent: return from getPairedDevices()
    if (!mounted) return;

    // Store the devices list in [_devicesList] for accessing the list outside of this method
    setState(() {
      _devicesList = devices;
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      // ignore: avoid_function_literals_in_foreach_calls
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(child: Text(device.name!), value: device));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      debugPrint('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          debugPrint('Connected to device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              debugPrint('Disconnecting locally');
            } else {
              debugPrint('Disconnecting remotely');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          debugPrint('Cannot connect, exception occurred');
          debugPrint(error);
        });

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // method to disconnect bluetooth
  void disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection?.close();
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // method to send message
  void sendRightMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("r")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = 1;
    });
  }

  // Turn left
  void sendLeftMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("l")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = -1;
    });
  }

  // Method to move car forward
  void sendForwardMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("f")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = 1;
    });
  }

  void sendBackMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("b")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = -1;
    });
  }

  void sendBrakeMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("s")));
    //connection!.output.add(Uint8List.fromList(utf8.encode("s")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = -1;
    });
  }

  void sendLaserOnToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("+")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = -1;
    });
  }

  void setControlTransition() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("t")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = -1;
    });
  }
}
