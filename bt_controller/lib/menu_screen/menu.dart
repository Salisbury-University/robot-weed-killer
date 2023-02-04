import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../homepage.dart';

class MenuScreen extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
        // Manual Button
          Container(
            child: NeumorphicButton(
            onPressed: () {
              // Navigate to view page (currently named "homepage.dart")
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) { 
                return HomePage(); }
              )
              );
            },
            style: NeumorphicStyle(
                          lightSource: LightSource.bottom,
                          shadowDarkColor: Colors.black,
                          shadowLightColor: Colors.black,
                          color: Color.fromARGB(255, 14, 114, 101),
                        ),
            child: Text('Manual',),
        ),
        ),
        Container(
            child: NeumorphicButton(
            onPressed: () {
              // Navigate to view page (currently named "homepage.dart")
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) { 
                return HomePage(); }
              )
              );
            },
            style: NeumorphicStyle(
                          lightSource: LightSource.bottom,
                          shadowDarkColor: Colors.black,
                          shadowLightColor: Colors.black,
                          color: Color.fromARGB(255, 14, 114, 101),
                        ),
            child: Text('Automatic',),
        ),
        )
      ],)

    );
  }
}
