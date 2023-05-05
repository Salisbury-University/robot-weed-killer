// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:bt_controller/mixin.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../pages/autopage.dart';
import '../pages/manualpage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:page_transition/page_transition.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({ Key? key }) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuPage>
    with BluetoothHandlerMixin, AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // AutomaticClientMixin annotates widget with super.build()
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 247, 247, 247),
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 247, 247, 247),
          width: 370,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 100),

              Stack(alignment: Alignment.center, children: <Widget>[
                // Robotics Logo

    

                Image.asset(
                  'assets/RoboticsLogo.png',
                  fit: BoxFit.fitWidth,
                  height: 340,
                ),
                // Title
                Positioned(
                  top: 295,
                  child: Text(
                    "R.U.P.E.R.T",
                    style: GoogleFonts.roboto(
                      fontSize: 43,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ]),

              SizedBox(height: 20),
              // Divider
              Container(
                padding: EdgeInsets.all(15),
                child: Divider(
                  thickness: 3,
                  color: Color.fromARGB(255, 30, 30, 30),
                ),
              ),

              SizedBox(height: 35),
              // Manual Button
              Align(
                child: SizedBox(
                  width: 295,
                  height: 60,
                  child: NeumorphicButton(
                    // onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     PageTransition(
                    //         type: PageTransitionType.fade, child: HomePage()),
                    //   );
                    // },
                    onPressed: () {
                      _sendToggleManualToBluetooth();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage(), maintainState: true),
                      );
                    },
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(30)),
                      intensity: .9,
                      surfaceIntensity: .5,
                      depth: 5,
                      color: Color.fromARGB(255, 145, 3, 3),
                      lightSource: LightSource.topLeft,
                      //shadowLightColor: Color.fromARGB(255, 76, 116, 149),
                      shadowDarkColorEmboss: Color.fromARGB(255, 76, 116, 149),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Manual',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 228, 228, 228),
                            fontSize: 24,
                          )),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 45),

              Align(
                child: SizedBox(
                  width: 295,
                  height: 60,
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
                      _sendToggleAutoToBluetooth();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return AutoPage();
                        }),
                      );
                    },
                   style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(30)),
                      intensity: .9,
                      surfaceIntensity: .5,
                      depth: 5,
                      color: Color.fromARGB(255, 145, 3, 3),
                      lightSource: LightSource.topLeft,
                      //shadowLightColor: Color.fromARGB(255, 76, 116, 149),
                      shadowDarkColorEmboss: Color.fromARGB(255, 76, 116, 149),
                    ),

                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Automatic',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 228, 228, 228),
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 45),

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
                                      visible: isButtonUnavailable &&
                                          bluetoothState ==
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
                                            value: bluetoothState.isEnabled,
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
                                                isButtonUnavailable = false;

                                                if (connected) {
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
                                                            device = value),
                                                    value:
                                                        devicesList.isNotEmpty
                                                            ? device
                                                            : null,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed:
                                                        isButtonUnavailable
                                                            ? null
                                                            : connected
                                                                ? disconnect
                                                                : connect,
                                                    child: Text(connected
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
                                                  side: BorderSide(
                                                      color: deviceState == 0
                                                          ? colors[
                                                              'neutralBorderColor']!
                                                          : deviceState == 1
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
                                                    deviceState == 0 ? 4 : 0,
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
                                                            color: deviceState ==
                                                                    0
                                                                ? colors[
                                                                    'neutralTextColor']
                                                                : deviceState ==
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

  void _sendToggleManualToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("y")));
    await connection!.output.allSent;
    show('Manual Toggled');
    setState(() {
      deviceState = -1;
    });
  }

  void _sendToggleAutoToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("t")));
    await connection!.output.allSent;
    show('Auto Toggled');
    setState(() {
      deviceState = -1;
    });
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
