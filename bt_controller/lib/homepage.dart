// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:bt_controller/widgets/screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:control_pad/control_pad.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vibration/vibration.dart';
// ignore: depend_on_referenced_packages
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

double? deg;
double? dist;

class _HomePageState extends State<HomePage> {
  // Initialize Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;

  late int _deviceState;

  bool isDisconnecting = false;
  var _isSwitchOn = false;

  bool get isConnected => connection != null && connection!.isConnected;

  // Defined for later, as needed
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
    // hide sytem bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled, then request
    // permission to turn on bluetooth as the app starts up
    enableBluetooth();

    // Listen for further state changes
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
    // Avoid any memory leaks and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection!.dispose();
      connection = null;
    }

    super.dispose();
  }

  // Request Bluetooth permission from the user
  Future<bool?> enableBluetooth() async {
    // Retrieve the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first and then retrieve
    // the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      return true;
    } else {
      await getPairedDevices();
    }
    return false;
  }

  // For retrieving and storing paired devices in a list
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // Unless mounted is true, calling [setState] throws an error.
    if (!mounted) return;

    // Store the [devices] list in the [_devicesList] for accessing the
    // list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 17, 17, 17),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 2,
          left: 2,
          top: 2,
          bottom: 2,
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  // Foreground color
                  color: Color.fromARGB(255, 44, 32, 52)),
              child: Row(
                // Row 1
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 35,
                  ),

                  Align(
                    alignment: new Alignment(0, .4),
                    child: NeumorphicButton(
                      onPressed: () {
                        if (_isScreenOn == false) {
                          setState(() {
                            _isScreenOn = true;
                          });
                        } else {
                          setState(() {
                            _isScreenOn = false;
                          });
                        }
                      },
                      style: NeumorphicStyle(
                          shadowLightColor: Colors.black,
                          lightSource: LightSource.bottom,
                          color: Color.fromARGB(255, 177, 236, 157)),
                      child: _isScreenOn
                          ? Text(
                              'Stop',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  letterSpacing: .1,
                                ),
                              ),
                            )
                          : Text(
                              'Start',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  letterSpacing: .1,
                                ),
                              ),
                            ),
                    ),
                  ),
                  //controller(),
                  SizedBox(
                    width: 55,
                  ),
                  //Screen(_isScreenOn),
                  /*SizedBox(
                    width: 5,
                  ),*/
                ],
              ),
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 25,
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 10,
                      lightSource: LightSource.bottom,
                      shadowLightColor: Colors.black,
                    ),
                    child: JoystickView(
                      innerCircleColor: Color.fromARGB(255, 6, 128, 128),
                      backgroundColor: Color.fromARGB(255, 19, 157, 139),
                      onDirectionChanged: (degrees, distance) {
                        deg = degrees;
                        dist = distance;
                        if ((deg! >= 322 || deg! <= 32) && deg != 0) {
                          //debugPrint("FORWARD");
                          if (_connected) {
                            _sendForwardMessageToBluetooth();
                          }
                        } else if (deg! >= 230 && deg! <= 305) {
                          //debugPrint("LEFT");
                          if (_connected) {
                            _sendLeftMessageToBluetooth();
                          }
                        } else if (deg! >= 60 && deg! <= 125) {
                          //debugPrint("RIGHT");
                          if (_connected) {
                            _sendRightMessageToBluetooth();
                          }
                        } else if (deg! >= 155 && deg! <= 225) {
                          //debugPrint("BACKWARD");
                          if (_connected) {
                            _sendBackMessageToBluetooth();
                          }
                        } else if (deg == 0) {
                          //debugPrint("STOP");
                          if (_connected) {
                            _sendBrakeMessageToBluetooth();
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 65,
                  ),
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 10,
                      lightSource: LightSource.bottom,
                      shadowLightColor: Colors.black,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(9)),
                          border: Border.all(
                            color: Color.fromARGB(255, 112, 148, 100),
                            width: 2.5,
                          )),
                      child: Screen(_isScreenOn), // Webview
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Align(
                    alignment: Alignment(0, -.2),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.circle(),
                        shadowLightColor: Colors.black,
                        lightSource: LightSource.bottom,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_connected) {
                            _sendLaserOnToBluetooth();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 234, 19, 19),
                            foregroundColor: Colors.black,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(30)),
                        child: Icon(
                          Icons.local_fire_department_sharp,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RawMaterialButton(
              fillColor: Colors.blue[200],
              shape: CircleBorder(),
              child: Icon(
                Icons.bluetooth,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        elevation: 16,
                        child: SizedBox(
                          height: 450.0,
                          width: 360.0,
                          child: SizedBox(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Visibility(
                                  visible: _isButtonUnavailable &&
                                      _bluetoothState ==
                                          BluetoothState.STATE_ON,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.yellow,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          'Enable Bluetooth',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Switch(
                                        value: _bluetoothState.isEnabled,
                                        onChanged: (bool value) {
                                          future() async {
                                            if (value) {
                                              await FlutterBluetoothSerial
                                                  .instance
                                                  .requestEnable();
                                            } else {
                                              await FlutterBluetoothSerial
                                                  .instance
                                                  .requestDisable();
                                            }

                                            await getPairedDevices();
                                            _isButtonUnavailable = false;

                                            if (_connected) {
                                              _disconnect();
                                            }
                                          }

                                          future().then((_) {
                                            setState(() {});
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Stack(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "PAIRED DEVICES",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                'Device:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DropdownButton(
                                                items: _getDeviceItems(),
                                                onChanged: (value) => setState(
                                                    () => _device = value),
                                                value: _devicesList.isNotEmpty
                                                    ? _device
                                                    : null,
                                              ),
                                              ElevatedButton(
                                                onPressed: _isButtonUnavailable
                                                    ? null
                                                    : _connected
                                                        ? _disconnect
                                                        : _connect,
                                                child: Text(_connected
                                                    ? 'Disconnect'
                                                    : 'Connect'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              side: new BorderSide(
                                                  color: _deviceState == 0
                                                      ? colors[
                                                          'neutralBorderColor']!
                                                      : _deviceState == 1
                                                          ? colors[
                                                              'onBorderColor']!
                                                          : colors[
                                                              'offBorderColor']!,
                                                  width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            elevation:
                                                _deviceState == 0 ? 4 : 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      "DEVICE 1",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: _deviceState == 0
                                                            ? colors[
                                                                'neutralTextColor']
                                                            : _deviceState == 1
                                                                ? colors[
                                                                    'onTextColor']
                                                                : colors[
                                                                    'offTextColor'],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "NOTE: If you cannot find the device in the list, please pair the device by going to the bluetoth settings",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: Text("Bluetooth Settings"),
                                            onPressed: () {
                                              FlutterBluetoothSerial.instance
                                                  .openSettings();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name!),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          print('Connectedto the device');
          connection = _connection;
          setState(() {
            _connected = true;
          });

          connection!.input!.listen(null).onDone(() {
            if (isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      _deviceState = 0;
    });

    await connection?.close();
    show('Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // method to send message
  void _sendRightMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("r")));
    await connection!.output.allSent;
    show('Device Turned Right');
    setState(() {
      _deviceState = 1;
    });
  }

  // Turn left
  void _sendLeftMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("l")));
    await connection!.output.allSent;
    show('Device Turned Left');
    setState(() {
      _deviceState = -1;
    });
  }

  // Method to move car forward
  void _sendForwardMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("f")));
    await connection!.output.allSent;
    show('Device Moved Forward');
    setState(() {
      _deviceState = 1;
    });
  }

  void _sendBackMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("b")));
    await connection!.output.allSent;
    show('Device Moved Backward');
    setState(() {
      _deviceState = -1;
    });
  }

  void _sendBrakeMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("s")));
    await connection!.output.allSent;
    show('Device Stopped');
    setState(() {
      _deviceState = -1;
    });
  }

  void _sendLaserOnToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("+")));
    await connection!.output.allSent;
    setState(() {
      _deviceState = -1;
    });
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    // tryhing without below method
    //_scaffoldKey.currentState!.showSnackBar(
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }
}
