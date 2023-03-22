
import 'package:alumni_tracking_system/constant.dart';
import 'package:alumni_tracking_system/firebase_options.dart';
import 'package:alumni_tracking_system/admin/homepage.dart';
import 'package:alumni_tracking_system/login.dart';
import 'package:alumni_tracking_system/register.dart';
import 'package:alumni_tracking_system/splashscreen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';



void main    () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          // Check for Errors
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'nsb',
              scaffoldBackgroundColor: white,
              appBarTheme: const AppBarTheme(
                backgroundColor: blue,
              ),
            ),
            home: LoginPage(),
          );
        });
  }
}
