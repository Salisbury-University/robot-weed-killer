import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../homepage.dart';

class MenuScreen extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(115, 60, 60, 60),
      body: Center(
        child: Container(
          color:Color.fromARGB(255, 64, 64, 64),
          width: 300,
          //child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Rupert!',
                  style: TextStyle(color: Colors.black,),
                  textAlign: TextAlign.center,),
                Container(
                  padding:EdgeInsets.all(15),
                  child: Divider(
                    thickness: 2,
                    color: Colors.black,
                  ),
                ),
          // Manual Button
                Container(
                  child: Align(
                    child: SizedBox(
                      width: 200,
                        child: ElevatedButton(
                            // Navigate to view page (currently named "homepage.dart")
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) { 
                                  return HomePage(); 
                                }),
                              );
                            },
              
                          child: Text('Manual',),
                        ),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(  
                        // Navigate to view page (currently named "homepage.dart")
                        onPressed: () {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) { 
                          return HomePage(); })
                        );
                        },
                        child: Text('Automatic',),
                      ),
                    ),
                  ),
                ),
          ],)
        ),
      //),
      ),
    );
  }
}