// ignore_for_file: prefer_const_constructors
// ignore: depend_on_referenced_packages
// ignore_for_file: unused_field

import 'package:bt_controller/mixin.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:webviewx/webviewx.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import '../menu_screen/menu.dart';
import '../const.dart';
import '../constants/marker.dart';

// ignore: must_be_immutable
class AutoPage extends StatefulWidget {
  @override
  State<AutoPage> createState() => _AutoPageState();
  // webviewx
  late WebViewXController webviewController;

  //@override
  //State<MapPage> createState() => _MapPageState();
}

double? deg;
double? dist;

class _AutoPageState extends State<AutoPage>
    with TickerProviderStateMixin, BluetoothHandler {
  // Map
  // declared to show relevant information when a marker is tapped on the map
  final pageController = PageController();
  int selectedIndex = 0; // used to update scale for animations
  var currentLocation = AppConstants.myLocation;

  final MapController mapController = MapController();

  // Bluetooth
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
  /* List<BluetoothDevice> _devicesList = []; */
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;
  bool _isScreenOn = false;

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
      if (kDebugMode) {
        print("Error");
      }
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
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          // Webviewx Widget
          // ignore: avoid_unnecessary_containers
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: 
                <Widget>[
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: FlutterMap(
                    mapController: mapController,
                    // there are more available options on map than just these settings
                    options: MapOptions(
                      minZoom: 5,
                      maxZoom: 18,
                      zoom: 11,
                      center: currentLocation,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://api.mapbox.com/styles/v1/zm009/clfzq1jz4003p01k6mwpn89kq/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoiem0wMDkiLCJhIjoiY2xlejMxcnR4MG41ZTNwcnhrZGxqNmM5dCJ9.wbrN7cncpM0-phqVxms6Ug",
                        additionalOptions: {
                          'mapStyleId': AppConstants.mapBoxStyleId,
                          'accessToken': AppConstants.mapBoxAccessToken,
                        },
                      ),
                      MarkerLayer(
                        markers: [
                          for (int i = 0; i < mapMarkers.length; i++)
                            Marker(
                                height: 40,
                                width: 40,
                                point: mapMarkers[i].location ??
                                    AppConstants.myLocation,
                                builder: (_) {
                                  return GestureDetector(
                                    onTap: () {
                                      selectedIndex = i;
                                      currentLocation =
                                          mapMarkers[i].location ??
                                              AppConstants.myLocation;
                                      _animatedMapMove(currentLocation, 11.5);
                                      setState(() {});
                                    },
                                    child: AnimatedScale(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      scale: selectedIndex == i ? 1 : 0.7,
                                      child: AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: selectedIndex == i ? 1 : 0.5,
                                          child: SvgPicture.asset(
                                              'assets/icons/map-marker.svg')),
                                    ),
                                  );
                                })
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),

          // ignore: avoid_unnecessary_containers
          Container(
            child: WebViewAware(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        )),
                    child: SizedBox(
                      height: 180,
                      width: 320,
                      child: WebViewX( width: 200, height: 200,
                          initialContent: 'http://192.168.4.1',
                          initialSourceType: SourceType.url,
                          onWebViewCreated: (controller) {
                          controller.loadContent('http://192.168.4.1', SourceType.url);
                        }, 
                      ),
                    ),
                  ),
                  Container(height: 70),

                  /*
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
                  ), */

                  //controller(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          RawMaterialButton(
              fillColor: Color.fromARGB(255, 0, 135, 253),
              shape: CircleBorder(),
              child: Icon(
                Icons.arrow_left,
                color: Colors.white,
              ),
              // onPressed: () {
              //   Navigator.push(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.fade, child: MenuPage()),
              //   );
              // }
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

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    /** 
     * TODO: Fix the animation zoom; zooms out too far when selecting a pin on map 
     * 
     */
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create an animation controller that contains a second long duration and a ticker provider
    // (vsync)
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
