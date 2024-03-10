import 'package:fingerprint_app/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FingerPrintMethodChannel {
  static const MethodChannel _channel =
      MethodChannel('fingerPrintMethodChannel');

  Future<bool?> init() async {
    try {
      bool isInitialized = await _channel.invokeMethod('init');
      return isInitialized;
    } catch (e) {
      print('init error: $e');
      return null;
    }
  }

  Future scan() async {
    try {
      await _channel.invokeMethod('scan');
    } catch (e) {
      print('Error connecting to device: $e');
      return null;
    }
  }

  Future<double?> startMatching(
      String queryFingerprint,) async {
    try {
      double matchScore = await _channel.invokeMethod('match', {
        "queryFingerprint": queryFingerprint,
      });

      return matchScore;
    } catch (e) {
      print('error matching prints: $e');
      return null;
    }
  }

  Future onScanMethod(
      BuildContext context, Function(Uint8List data) callback) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "onScanMethod") {
        Map scanMapData = call.arguments;

        if (scanMapData.isNotEmpty) {
          String? scanText = scanMapData["scanText"];
          Uint8List? imgData = scanMapData["imgData"];
          String? scanTextError = scanMapData["scanTextError"];

          if (imgData == null &&
              scanTextError != null &&
              scanTextError.isNotEmpty) {
            showErrorDialog(scanTextError, context);
          } else if (imgData != null && scanText!.contains("success")) {
            callback(imgData);

            // scannedImageData = imgData;
            // print("scan success $scannedImageData");
          }
        }
      }
    });
  }
}

FingerPrintMethodChannel fingerPrintMethodChannel = FingerPrintMethodChannel();
