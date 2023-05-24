import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';

class BluetoothHandlerProvider extends ChangeNotifier {
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;

  late int deviceState;

  bool isDisconnecting = false;
  bool get isConnected => connection != null && connection!.isConnected;

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

  BluetoothHandlerProvider() {
    enableBluetooth();
    FlutterBluetoothSerial.instance.state.then((state) {
      bluetoothState = state;
      notifyListeners();
    });

    deviceState = 0; // normal state

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      bluetoothState = state;
      if (bluetoothState == BluetoothState.STATE_OFF) {
        isButtonUnavailable = true;
      }
      getPairedDevices();
      notifyListeners();
    });
  }

  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }
    super.dispose();
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

    devicesList = devices;
    notifyListeners();
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

  void connect(BuildContext context) async {
    isButtonUnavailable = true;
    notifyListeners();

    if (device == null) {
      show(context, 'No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(device?.address)
            .then((_connection) {
          debugPrint('Connected to device');
          connection = _connection;
          connected = true;
          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              debugPrint('Disconnecting locally');
            } else {
              debugPrint('Disconnected remotely');
            }

            if (this.hasListeners) {
              notifyListeners();
            }
          });
        }).catchError((error) {
          debugPrint('Cannot connect, exception occurred');
          debugPrint(error);
        });
        show(context, 'Device connected');

        isButtonUnavailable = false;
        notifyListeners();
      }
    }
  }

  void disconnect(BuildContext context) async {
    isButtonUnavailable = true;
    deviceState = 0;
    notifyListeners();

    await connection?.close();
    show(context, 'Device disconnected');
    if (connection!.isConnected) {
      connected = false;
      isButtonUnavailable = false;
      notifyListeners();
    }
  }

  Future show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      duration: duration,
    ));
  }
}
