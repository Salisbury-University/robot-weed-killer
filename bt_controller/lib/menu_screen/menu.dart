// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:bt_controller/connection.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../pages/autopage.dart';
import '../pages/manualpage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:page_transition/page_transition.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuPage> {
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

  @override
  Widget build(BuildContext context) {
    final _handler =
        Provider.of<BluetoothHandlerProvider>(context, listen: false);

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
                    onPressed: () {
                      _sendToggleToBluetooth("y");
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade, child: HomePage()),
                      );
                    },
                    // onPressed: () {
                    //   _sendToggleManualToBluetooth();
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) => HomePage(), maintainState: true),
                    //   );
                    // },
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
                    onPressed: () {
                      _sendToggleToBluetooth("t");
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade, child: AutoPage()),
                      );
                    },
                    // onPressed: () {
                    //   _sendToggleAutoToBluetooth();
                    //   Navigator.of(context).push(
                    //     MaterialPageRoute(builder: (context) {
                    //       return AutoPage();
                    //     }),
                    //   );
                    // },
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
                                      visible: _handler.isButtonUnavailable &&
                                          _handler.bluetoothState ==
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
                                            value: _handler
                                                .bluetoothState.isEnabled,
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

                                                await _handler
                                                    .getPairedDevices();
                                                _handler.isButtonUnavailable =
                                                    false;

                                                if (_handler.connected) {
                                                  _handler.disconnect(context);
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
                                                    items: _handler
                                                        .getDeviceItems(),
                                                    onChanged: (value) =>
                                                        setState(() => _handler
                                                            .device = value),
                                                    value: _handler.devicesList
                                                            .isNotEmpty
                                                        ? _handler.device
                                                        : null,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: _handler
                                                            .isButtonUnavailable
                                                        ? null
                                                        : () {
                                                            if (_handler
                                                                .connected) {
                                                              _handler
                                                                  .disconnect(
                                                                      context);
                                                            } else {
                                                              _handler.connect(
                                                                  context);
                                                            }
                                                          },
                                                    child: Text(
                                                        _handler.connected
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
                                                      color: _handler
                                                                  .deviceState ==
                                                              0
                                                          ? _handler.colors[
                                                              'neutralBorderColor']!
                                                          : _handler.deviceState ==
                                                                  1
                                                              ? _handler.colors[
                                                                  'onBorderColor']!
                                                              : _handler.colors[
                                                                  'offBorderColor']!,
                                                      width: 3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                elevation:
                                                    _handler.deviceState == 0
                                                        ? 4
                                                        : 0,
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
                                                            color: _handler
                                                                        .deviceState ==
                                                                    0
                                                                ? _handler
                                                                        .colors[
                                                                    'neutralTextColor']
                                                                : _handler.deviceState ==
                                                                        1
                                                                    ? _handler
                                                                            .colors[
                                                                        'onTextColor']
                                                                    : _handler
                                                                            .colors[
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

  void _sendToggleToBluetooth(String ch) async {
    final _handler =
        Provider.of<BluetoothHandlerProvider>(context, listen: false);
    _handler.connection!.output.add(Uint8List.fromList(utf8.encode(ch)));
    await _handler.connection!.output.allSent;
    _handler.show(context, 'Manual Toggled');
    setState(() {
      _handler.deviceState = -1;
    });
  }
}
