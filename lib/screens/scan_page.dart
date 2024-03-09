// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:fingerprint_app/utils/finger_print_method_channel.dart';
import 'package:fingerprint_app/utils/show_message.dart';
import 'package:flutter/material.dart';

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
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => const ChooseRemoteTypeScreen(),
            // ));
          },
          label: const Text("Scan Fingerprint")),
      body: Container(
        child: Column(
          children: [
            if (scannedFingerintImage != null)
              Image.memory(scannedFingerintImage!),
          ],
        ),
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
      },
    );
  }
}

FingerPrintMethodChannel fingerPrintMethodChannel = FingerPrintMethodChannel();
