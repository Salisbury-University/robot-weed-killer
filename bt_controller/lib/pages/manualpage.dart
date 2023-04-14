// ignore_for_file: prefer_const_constructors
// ignore: depend_on_referenced_packages

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
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx/webviewx.dart';
import '../menu_screen/menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  // webviewx
  late WebViewXController webviewController;
  
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
      body: Stack(
        children: <Widget>[
          // Webviewx Widget 
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: WebViewX(width: 900, height: 900),
                  ),
                ),
            ]),
          ),
           
            
            
          Container( 
            child: WebViewAware(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 290
                ),
                Container(
                  child:  Align(
                    alignment: FractionalOffset.bottomCenter,
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
                        color:  Color.fromARGB(255, 96, 96, 96),
                      ),
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
                                  color: Color.fromARGB(255, 216, 216, 216),
                                  letterSpacing: .1,
                                ),
                              ),
                            ),
                    ),
                    
                    ),
                  ),

                  //controller(),

                ],
              ),
             ),
            ),
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  WebViewAware( 
                    child:Neumorphic(
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 10,
                      lightSource: LightSource.bottom,
                      shadowLightColor: Colors.black,
                    ),
                    child: JoystickView(
                      innerCircleColor: Color.fromARGB(255, 20, 20, 20),
                      backgroundColor: Color.fromARGB(255, 62, 62, 62),
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
                  ),
                  //Screen(_isScreenOn), // Webview
                  SizedBox(
                    width: 420,
                  ),
                  Align(
                    alignment: Alignment(0, 0),
                      child: SizedBox( height: 100, width: 100,
                       child: NeumorphicButton(
                        onPressed: () {
                          if (_connected) {
                            _sendLaserOnToBluetooth();
                          }
                        },
                        style: NeumorphicStyle (
                            color: Color.fromARGB(255, 234, 19, 19),
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: 10,
                            lightSource: LightSource.topRight,
                            shadowLightColor: Colors.black54,
                        ),
                        
                        child:Align(
                          alignment: Alignment.center,
                          child: Icon(
                          Icons.local_fire_department_sharp,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                    ),
                  
                ],
              ),
            ),
            RawMaterialButton(
              fillColor: Color.fromARGB(255, 0, 135, 253),
              shape: CircleBorder(),
              child: Icon(
                Icons.arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) { 
                  return MenuPage(); })
                ); 
              },
            )
          ],
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
