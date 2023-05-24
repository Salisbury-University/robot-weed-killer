// ignore_for_file: prefer_const_constructors
// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:bt_controller/connection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:control_pad/control_pad.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:webviewx/webviewx.dart';
import 'package:bt_controller/menu_screen/menu.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  // webviewx
  late WebViewXController webviewController;
}

double? deg;
double? dist;

class _HomePageState extends State<HomePage> {
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
  }

  @override
  Widget build(BuildContext context) {
    final _handler =
        Provider.of<BluetoothHandlerProvider>(context, listen: false);

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
                          if (_handler.connected) {
                            _sendDriveMessageToBluetooth("f");
                          }
                        } else if (deg! >= 230 && deg! <= 305) {
                          if (_handler.connected) {
                            _sendDriveMessageToBluetooth("l");
                          }
                        } else if (deg! >= 60 && deg! <= 125) {
                          if (_handler.connected) {
                            _sendDriveMessageToBluetooth("r");
                          }
                        } else if (deg! >= 155 && deg! <= 225) {
                          if (_handler.connected) {
                            _sendDriveMessageToBluetooth("b");
                          }
                        } else if (deg == 0) {
                          if (_handler.connected) {
                            _sendDriveMessageToBluetooth("s");
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
                        if (_handler.connected) {
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
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: MenuPage()),
                );
              }
              // onPressed: () {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) {
              //       return MenuPage();
              //     }),

              //   );
              //   // Navigator.of(context).pop(                                  // Back to Menu
              //   //         MenuPage(),
              //   //         );
              // },
              )
        ],
      ),
    );
  }

  // method to send message
  void _sendDriveMessageToBluetooth(String ch) async {
    final _handler =
        Provider.of<BluetoothHandlerProvider>(context, listen: false);
    _handler.connection!.output.add(Uint8List.fromList(utf8.encode(ch)));
    await _handler.connection!.output.allSent;
    _handler.show(context, 'Device Turned Right');
    setState(() {
      _handler.deviceState = 1;
    });
  }

  void _sendLaserOnToBluetooth() async {
    final _handler =
        Provider.of<BluetoothHandlerProvider>(context, listen: false);
    _handler.connection!.output.add(Uint8List.fromList(utf8.encode("+")));
    await _handler.connection!.output.allSent;
    setState(() {
      _handler.deviceState = -1;
    });
  }
}
