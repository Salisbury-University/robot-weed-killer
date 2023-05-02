// ignore_for_file: prefer_const_constructors
// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:bt_controller/mixin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:control_pad_plus/control_pad_plus.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:webviewx/webviewx.dart';
import 'package:bt_controller/menu_screen/menu.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  // webviewx
  late WebViewXController webviewController;
}

double? deg;
double? dist;

class _HomePageState extends State<HomePage> with BluetoothHandlerMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

    // Listen for further state changes
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
                        child: WebViewX(
                          width: 900,
                          height: 900,
                          initialContent: 'http://192.168.4.1',
                          initialSourceType: SourceType.url,
                          onWebViewCreated: (controller) {
                            controller.loadContent(
                                'http://192.168.4.1', SourceType.url);
                          },
                        )),
                  ),
                ]),
          ),

          Container(
            child: WebViewAware(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(height: 290),
                  /* Container(
                    child: Align(
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
                          color: Color.fromARGB(255, 96, 96, 96),
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
                  ), */

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
                  child: Neumorphic(
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
                          if (connected) {
                            _sendForwardMessageToBluetooth();
                          }
                        } else if (deg! >= 230 && deg! <= 305) {
                          //debugPrint("LEFT");
                          if (connected) {
                            _sendLeftMessageToBluetooth();
                          }
                        } else if (deg! >= 60 && deg! <= 125) {
                          //debugPrint("RIGHT");
                          if (connected) {
                            _sendRightMessageToBluetooth();
                          }
                        } else if (deg! >= 155 && deg! <= 225) {
                          //debugPrint("BACKWARD");
                          if (connected) {
                            _sendBackMessageToBluetooth();
                          }
                        } else if (deg == 0) {
                          //debugPrint("STOP");
                          if (connected) {
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
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: NeumorphicButton(
                      onPressed: () {
                        if (connected) {
                          _sendLaserOnToBluetooth();
                        }
                      },
                      style: NeumorphicStyle(
                        color: Color.fromARGB(255, 201, 17, 17),
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: 10,
                        lightSource: LightSource.topRight,
                        shadowLightColor: Colors.black54,
                      ),
                      child: Align(
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
          SizedBox(
            height: 10,
          ),
          RawMaterialButton(
            fillColor: Color.fromARGB(255, 0, 135, 253),
            shape: CircleBorder(),
            child: Icon(
              Icons.arrow_left,
              color: Colors.white,
            ),
            // onPressed: () {
            //           Navigator.push(
            //             context,
            //             PageTransition(
            //               type: PageTransitionType.fade,
            //               child: MenuPage() ),
            //             );
            //         }
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return MenuPage();
                }),
              );
            },
          )
        ],
      ),
    );
  }

  // method to send message
  void _sendRightMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("r")));
    await connection!.output.allSent;
    show('Device Turned Right');
    setState(() {
      deviceState = 1;
    });
  }

  // Turn left
  void _sendLeftMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("l")));
    await connection!.output.allSent;
    show('Device Turned Left');
    setState(() {
      deviceState = -1;
    });
  }

  // Method to move car forward
  void _sendForwardMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("f")));
    await connection!.output.allSent;
    show('Device Moved Forward');
    setState(() {
      deviceState = 1;
    });
  }

  void _sendBackMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("b")));
    await connection!.output.allSent;
    show('Device Moved Backward');
    setState(() {
      deviceState = -1;
    });
  }

  void _sendBrakeMessageToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("s")));
    await connection!.output.allSent;
    show('Device Stopped');
    setState(() {
      deviceState = -1;
    });
  }

  void _sendLaserOnToBluetooth() async {
    connection!.output.add(Uint8List.fromList(utf8.encode("+")));
    await connection!.output.allSent;
    setState(() {
      deviceState = -1;
    });
  }
}
