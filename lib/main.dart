import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ws_germany_ae3/pages/login_page.dart';
      
void main() {
  runApp( MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}      