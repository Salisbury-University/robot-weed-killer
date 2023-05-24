import 'package:flutter/material.dart';
import './menu_screen/menu.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bt_controller/connection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) => runApp(ChangeNotifierProvider(
            create: (_) => BluetoothHandlerProvider(),
            child: RoundupApp(),
          )));
}

class RoundupApp extends StatelessWidget {
  const RoundupApp({Key? key}) : super(key: key);
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
