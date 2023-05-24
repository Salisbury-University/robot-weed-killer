// ignore_for_file: prefer_const_constructors
// ignore: depend_on_referenced_packages
// ignore_for_file: unused_field
import 'dart:convert';

import 'package:bt_controller/connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:page_transition/page_transition.dart';
import 'package:webviewx/webviewx.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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

class _AutoPageState extends State<AutoPage> with TickerProviderStateMixin {
  // Map
  // declared to show relevant information when a marker is tapped on the map
  final pageController = PageController();
  int selectedIndex = 0; // used to update scale for animations
  var currentLocation = AppConstants.myLocation;

  final MapController mapController = MapController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Get instance of the Bluetooth

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
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          // Webviewx Widget
          // ignore: avoid_unnecessary_containers
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
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
                      child: WebViewX(
                        width: 200,
                        height: 200,
                        initialContent: 'http://192.168.4.1',
                        initialSourceType: SourceType.url,
                        onWebViewCreated: (controller) {
                          controller.loadContent(
                              'http://192.168.4.1', SourceType.url);
                        },
                      ),
                    ),
                  ),
                  Container(height: 70),
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
              onPressed: () {
                _sendToggleToBluetooth();
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
              // },
              )
        ],
      ),
    );
  }

  void _sendToggleToBluetooth() async {
    final _handler =
        Provider.of<BluetoothHandlerProvider>(context, listen: false);
    _handler.connection!.output.add(Uint8List.fromList(utf8.encode("t")));
    await _handler.connection!.output.allSent;
    _handler.show(context, 'Auto Toggled');
    setState(() {
      _handler.deviceState = -1;
    });
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
