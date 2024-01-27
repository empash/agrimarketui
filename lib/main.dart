import 'dart:io';

import 'package:agrimarket/providers/user.dart';
import 'package:agrimarket/screens/farmer_screen.dart';
import 'package:agrimarket/screens/home_screen.dart';
import 'package:agrimarket/screens/serviceprovider_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: User()),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);
    Widget widget = const HomeScreen();
    String userType = user.getUser['userType'];
    if (userType.isNotEmpty) {
      if (userType == 'farmer') {
        widget = const FarmerScreen();
      } else {
        widget = const ServiceProviderScreen();
      }
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget,
      theme: ThemeData(
        colorSchemeSeed: Colors.lightBlue,
        dialogBackgroundColor: Colors.white,
      ),
    );
  }
}
