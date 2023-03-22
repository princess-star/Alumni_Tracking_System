import 'dart:async';
import 'package:alumni_tracking_system/constant.dart';
import 'package:alumni_tracking_system/login.dart';
import 'package:flutter/material.dart';

import 'constant.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: pink2,
      body: Center(
        child: Image(
          image: AssetImage("res/pic/svfclogo.png"),
          width: 150,
        ),
      ),
    );
  }
}
