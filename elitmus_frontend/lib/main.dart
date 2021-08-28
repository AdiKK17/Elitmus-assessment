import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';
import 'auth_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    new Timer(Duration(milliseconds: 100), checkLogin);
  }

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("isLoggedIn");
    if (value == "yes") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthenticationPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Text(
          "Hello",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
