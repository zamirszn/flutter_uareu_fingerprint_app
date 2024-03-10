// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:fingerprint_app/data_source/database_helper.dart';
import 'package:fingerprint_app/models/finger_print_model.dart';
import 'package:fingerprint_app/utils/finger_print_method_channel.dart';
import 'package:fingerprint_app/utils/globals.dart';
import 'package:fingerprint_app/utils/show_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.fingerprint),
          onPressed: () {
            initFingerPrint();
          },
          label: const Text("Add Fingerprint Record")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (scannedFingerintImage != null)
            Image.memory(scannedFingerintImage!),
        ],
      ),
    );
  }

  void initFingerPrint() async {
    bool? isfingerprintInitialized = await fingerPrintMethodChannel.init();
    if (isfingerprintInitialized != null && isfingerprintInitialized == true) {
      startScan();
    } else {
      showErrorDialog("Error initializing", context);
    }
  }

  Uint8List? scannedFingerintImage;

  void startScan() async {
    scannedFingerintImage = null;
    setState(() {});
    fingerPrintMethodChannel.scan();
    fingerPrintMethodChannel.onScanMethod(
      context,
      (data) {
        scannedFingerintImage = data;
        setState(() {});
        for (var i = 0; i < 1000; i++) {
          saveImage(data);
        }
      },
    );
  }

  void saveFingerPrintToDb(String scannedFingerintPath) async {
    FingerprintModel fingerprint = FingerprintModel(
        dateCreated: DateTime.now(), fingerprintPath: scannedFingerintPath);

    await dbHelper.insertFingerprintRecord(fingerprint);
  }

  void saveImage(Uint8List data) async {
    String? documentsDir = (await getExternalStorageDirectory())?.path;

    String localPath = '$documentsDir/$fileName';

    if (!File(localPath).existsSync()) {
      final file = File(localPath);
      await file.writeAsBytes(data.cast<int>());
      print("scanned fp image saved ${file.path}");

      saveFingerPrintToDb(fileName);
    }
  }
}
