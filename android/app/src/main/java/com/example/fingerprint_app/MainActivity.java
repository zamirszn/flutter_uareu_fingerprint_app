package com.example.fingerprint_app;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEng) {
    GeneratedPluginRegistrant.registerWith(flutterEng);

    new FingerPrintPlugin().attachToEngine(this, flutterEng);
  }
}
