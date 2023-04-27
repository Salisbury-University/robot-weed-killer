// ignore_for_file: prefer_const_constructors

import 'package:bt_controller/mixin.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../pages/autopage.dart';
import '../pages/manualpage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webviewx/webviewx.dart';



class MenuPage extends StatefulWidget {
  @override
  State<MenuPage> createState() => _MenuScreenState();
  // webviewx
  late WebViewXController webviewController;
}

double? deg;
double? dist;

class _MenuScreenState extends State<MenuPage> with BluetoothHandler {
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
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
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
/*
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
  } */
/*
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
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(115, 60, 60, 60),
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 64, 64, 64),
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 90),

              Stack(alignment: Alignment.center, children: <Widget>[
                // Robotics Logo
                Image.asset(
                  'assets/RoboticsLogo.png',
                  fit: BoxFit.fitWidth,
                  height: 320,
                ),
                // Title
                Positioned(
                  top: 272,
                  child: Text(
                    "R.U.P.E.R.T",
                    style: GoogleFonts.secularOne(
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ]),

              SizedBox(height: 25),
              // Divider
              Container(
                padding: EdgeInsets.all(15),
                child: Divider(
                  thickness: 3,
                  color: Color.fromARGB(255, 30, 30, 30),
                ),
              ),

              SizedBox(height: 40),
              // Manual Button
              Align(
                child: SizedBox(
                  width: 300,
                  height: 55,
                  child: NeumorphicButton(
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     PageTransition(
                    //         type: PageTransitionType.fade, child: HomePage()),
                    //   );
                    // },
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }),
                      );
                    },
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(30)),
                      intensity: .2,
                      surfaceIntensity: .5,
                      depth: 20,
                      color: Color.fromARGB(255, 46, 46, 46),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Manual',
                          style: GoogleFonts.adamina(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 228, 228, 228),
                            fontSize: 20,
                          )),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              Align(
                child: SizedBox(
                  width: 300,
                  height: 55,
                  child: NeumorphicButton(
                    // Navigate to autopage.dart
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     PageTransition(
                    //         type: PageTransitionType.fade, child: AutoPage()),
                    //   );
                    // },
                      onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return AutoPage();
                        }),
                      );
                    },
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      intensity: .2,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(30)),
                      depth: 9,
                      color: Color.fromARGB(255, 46, 46, 46),
                      //lightSource:LightSource.topRight
                    ),

                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Automatic',
                        style: GoogleFonts.adamina(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 228, 228, 228),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 40),

              SizedBox(
                height: 60,
                width: 60,
                child: RawMaterialButton(
                  fillColor: Color.fromARGB(255, 75, 164, 237),
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                                  disconnect();
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
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    'Device:',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  DropdownButton(
                                                    items: getDeviceItems(),
                                                    onChanged: (value) =>
                                                        setState(() =>
                                                            _device = value),
                                                    value:
                                                        _devicesList.isNotEmpty
                                                            ? _device
                                                            : null,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed:
                                                        _isButtonUnavailable
                                                            ? null
                                                            : _connected
                                                                ? disconnect
                                                                : connect,
                                                    child: Text(_connected
                                                        ? 'Disconnect'
                                                        : 'Connect'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                      BorderRadius.circular(
                                                          4.0),
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
                                                            color: _deviceState ==
                                                                    0
                                                                ? colors[
                                                                    'neutralTextColor']
                                                                : _deviceState ==
                                                                        1
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
                                                child:
                                                    Text("Bluetooth Settings"),
                                                onPressed: () {
                                                  FlutterBluetoothSerial
                                                      .instance
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
/*
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
      //show('No device selected');
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
        //show('Device connected');

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
    //show('Device disconnected');
    if (!connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  } */
}
