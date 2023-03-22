package com.example.alumni_tracking_system

import io.flutter.embedding.android.FlutterFragmentActivity

  class MainActivity: FlutterFragmentActivity() {
      override fun configureFlutterEngine(flutterEngine: FlutterEngine) { 
        GeneratedPluginRegistrant.registerWith(flutterEngine) 
      }
}
