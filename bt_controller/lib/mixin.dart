// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

mixin BluetoothHandlerMixin<T extends StatefulWidget> on State<T> {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;

  late int deviceState;

  bool isDisconnecting = false;
  bool get isConnected => connection != null && connection!.isConnected;
  bool _keepAlive = false;

  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? device;
  bool connected = false;
  bool isButtonUnavailable = false;

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
        bluetoothState = state;
      });
    });

    deviceState = 0; // normal state

    enableBluetooth();

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        bluetoothState = state;
        if (bluetoothState == BluetoothState.STATE_OFF) {
          isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });

    _keepAlive = true;
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
    _keepAlive = false;
  }

  Future<bool?> enableBluetooth() async {
    bluetoothState = await FlutterBluetoothSerial.instance.state;

    if (bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      debugPrint('Error');
    }

    if (!mounted) return;

    setState(() {
      devicesList = devices;
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      devicesList.forEach((device) {
        items.add(DropdownMenuItem(value: device, child: Text(device.name!)));
      });
    }
    return items;
  }

  void connect() async {
    setState(() {
      isButtonUnavailable = true;
    });

    if (device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(device?.address)
            .then((_connection) {
          debugPrint('Connected to device');
          connection = _connection;
          setState(() {
            connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              debugPrint('Disconnecting locally');
            } else {
              debugPrint('Disconneted remotely');
            }

            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          debugPrint('Cannot connect, exception occurred');
          debugPrint(error);
        });
        show('Device connected');

        setState(() => isButtonUnavailable = false);
      }
    }
  }

  void disconnect() async {
    setState(() {
      isButtonUnavailable = true;
      deviceState = 0;
    });

    await connection?.close();
    show('Device disconnected');
    if (connection!.isConnected) {
      setState(() {
        connected = false;
        isButtonUnavailable = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (this is AutomaticKeepAliveClientMixin) {
      AutomaticKeepAliveClientMixin mixin =
          this as AutomaticKeepAliveClientMixin;

      // ignore: invalid_use_of_protected_member
      mixin.updateKeepAlive();
    }
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await Future.delayed(Duration(milliseconds: 100));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
        ),
        duration: duration,
      ));
    }
  }
}
