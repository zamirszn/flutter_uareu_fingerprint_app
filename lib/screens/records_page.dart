import 'package:fingerprint_app/data_source/database_helper.dart';
import 'package:fingerprint_app/models/finger_print_model.dart';
import 'package:fingerprint_app/utils/show_message.dart';
import 'package:flutter/material.dart';

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  void initState() {
    getAllRecords();
    super.initState();
  }

  List<FingerprintModel> fingerPrintRecords = [];

  void getAllRecords() async {
    try {
      List<FingerprintModel> records = await dbHelper.queryFingerprintRecords();
      fingerPrintRecords = records;
      setState(() {});
    } catch (e) {
      showErrorDialog(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Records")),
      body: ListView.builder(
        itemCount: fingerPrintRecords.length,
        itemBuilder: (context, index) {
          FingerprintModel fingerPrint = fingerPrintRecords[index];
          return ListTile(
            trailing:
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
            title: Text(fingerPrint.id.toString() ?? ""),
            subtitle: Text("created on :${fingerPrint.dateCreated}"),
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )),
          );
        },
      ),
    );
  }
}
