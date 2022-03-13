import 'package:ecommerce_int2/screens/splash_page.dart';
import 'package:ecommerce_int2/services/interceptors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_properties.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget home = MaterialApp(
      title: 'iKadai', debugShowCheckedModeBanner: false, home: SplashScreen());

  void _initAmplifyFlutter() async {
    print("configured");
    final prefs = await SharedPreferences.getInstance();
    themeChange(true);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _initAmplifyFlutter();
    return home;
  }
}
