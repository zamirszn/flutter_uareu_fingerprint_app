import 'dart:io';
import 'dart:typed_data';

import 'package:fingerprint_app/data_source/database_helper.dart';
import 'package:fingerprint_app/models/finger_print_model.dart';
import 'package:fingerprint_app/screens/scan_page.dart';
import 'package:fingerprint_app/utils/finger_print_method_channel.dart';
import 'package:fingerprint_app/utils/show_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
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
        saveCurrentImageScan(data);

        // startMatching(data);
      },
    );
  }

  void saveCurrentImageScan(Uint8List scannedImageData) async {
    String? documentsDir = (await getExternalStorageDirectory())?.path;
    String fileName =
        "${DateFormat("yyyy_MM_dd_HH_mm_ss").format(DateTime.now())}.png";
    String localPath = '$documentsDir/$fileName';

    final file = File(localPath);
    await file.writeAsBytes(scannedImageData.cast<int>());
    print("temp img saved ${file.path}");

    startMatching(file.path);
  }

  void startMatching(String queryFingerPrint) async {
    showLoadingDialog(message: "Finding a match", context: context);

    double? matchScore =
        await fingerPrintMethodChannel.startMatching(queryFingerPrint);

        if (matchScore != null) {
        print("match score $matchScore");
      }

   
  }

  void initFingerPrint() async {
    bool? isfingerprintInitialized = await fingerPrintMethodChannel.init();
    if (isfingerprintInitialized != null && isfingerprintInitialized == true) {
      startScan();
    } else {
      showErrorDialog("Error initializing", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.fingerprint),
          onPressed: () {
            initFingerPrint();
          },
          label: const Text("Scan Fingerprint")),
      appBar: AppBar(
        title: const Text("Match"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (scannedFingerintImage != null) Image.memory(scannedFingerintImage!),
      ]),
    );
  }
}
