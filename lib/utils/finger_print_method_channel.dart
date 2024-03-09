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
      print('Error connecting to device: $e');
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
    return null;
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

          if (imgData == null && scanTextError != null) {
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
