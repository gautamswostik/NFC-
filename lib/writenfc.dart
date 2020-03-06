import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'dart:async';
import 'dart:io';

class RecordEditor {
  TextEditingController mediaTypeController;
  TextEditingController payloadController;
  TextEditingController langcodeController;

  RecordEditor() {
    mediaTypeController = TextEditingController();
    payloadController = TextEditingController();
  }
}

class WriteNFC extends StatefulWidget {
  @override
  _WriteNFCState createState() => _WriteNFCState();
}

class _WriteNFCState extends State<WriteNFC> {
  StreamSubscription<NDEFMessage> _stream;
  List<RecordEditor> _records = [];
  bool _hasClosedWriteDialog = false;

  void _addRecord() {
    setState(() {
      _records.add(RecordEditor());
    });
  }

  void _write(BuildContext context) async {
    List<NDEFRecord> records = _records.map((record) {
      return NDEFRecord.type(
        record.mediaTypeController.text,
        record.payloadController.text,
      );
    }).toList();
    NDEFMessage message = NDEFMessage.withRecords(records);

    // Show dialog on Android (iOS has it's own one)
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.purple,
          title: const Text(
            "Hover over your NFC deviece",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _hasClosedWriteDialog = true;
                _stream?.cancel();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    // Write to the first tag scanned
    await NFC.writeNDEF(message).first;
    if (!_hasClosedWriteDialog) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("NFC Writter"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          SizedBox(
            height: 250,
          ),
          Center(
            child: OutlineButton(
              child: const Text("Add NFC Tag"),
              onPressed: _addRecord,
            ),
          ),
          for (var record in _records)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Record", style: Theme.of(context).textTheme.body2),
                  TextFormField(
                    controller: record.mediaTypeController,
                    decoration: InputDecoration(
                      hintText: "Media type",
                    ),
                  ),
                  TextFormField(
                    controller: record.payloadController,
                    decoration: InputDecoration(
                      hintText: "Payload",
                    ),
                  ),
                ],
              ),
            ),
          Center(
            child: RaisedButton(
              child: const Text(
                "Add TAG",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.purple,
              onPressed: _records.length > 0 ? () => _write(context) : null,
            ),
          ),
        ],
      ),
    );
  }
}
