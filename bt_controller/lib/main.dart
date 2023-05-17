import 'package:flutter/material.dart';
import './menu_screen/menu.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) => runApp(RoundupApp()));
}

class RoundupApp extends StatelessWidget {
  const RoundupApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: "Roundup Controller",
      home: MenuPage(),
    );
  }
}
