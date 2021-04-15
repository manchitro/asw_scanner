import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asw_scanner/pages/loading.dart';
import 'package:asw_scanner/pages/login.dart';
import 'package:asw_scanner/pages/loginWeb.dart';
import 'package:asw_scanner/pages/dashboard.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light));
  runApp(MaterialApp(
    title: 'ASW Scanner',
    theme: ThemeData(fontFamily: 'Nunito'),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/login': (context) => Login(),
      '/loginweb': (context) => LoginWeb(),
      '/dashboard': (context) => Dashboard(),
      // '/scanner': (context) => Scanner(),
    },
  ));
}
