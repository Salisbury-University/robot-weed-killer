import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arrow_pad/arrow_pad.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Set Landscape Orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Robot App UI',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  // This widget is the home page of your application. 

  final String title;

  @override
  State<MyHomePage> createState() => Buttons();
}

class Buttons extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {       // This method is rerun every time setState is called.
    return Scaffold(
        body: 
        Column(
          children: <Widget>[
            // "Auto" Button
            Align(
            child:
              ElevatedButton(onPressed: (){
                print("Auto Mode");
              },
                child: Text("Auto")
              ),
            ),

            // Arrow Pad
            Align(
              alignment: Alignment.bottomLeft,
              child:
              ArrowPad(
                height: 90.0,
                width: 90.0,
                innerColor: Colors.blue,
                arrowPadIconStyle: ArrowPadIconStyle.arrow,
                onPressedUp: () => print('up'),
                onPressedLeft: () => print('left'),
                onPressedRight: () => print('right'),
                onPressedDown: () => print('down'),
            ),
            ),

            Align(
              child:
              ElevatedButton(
                onPressed: () {},
                child: Text('FIRE'),
                style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: CircleBorder(),
                padding: EdgeInsets.all(24),
                ),
              ),
            ),
          ]
        ),
    );
  }
}




