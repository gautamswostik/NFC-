import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class ReadNFC extends StatefulWidget {
  @override
  _ReadNFCState createState() => _ReadNFCState();
}

class _ReadNFCState extends State<ReadNFC> {
  List<Text> _messageList = List();
  StreamSubscription<NDEFMessage> _stream;

  StreamSubscription<NDEFMessage> _stream123;
  List<NDEFMessage> _tags = [];

    void _readNFC(BuildContext context) {
    try {
      var subscription = NFC.readNDEF().listen(
          (tag) {
        setState(() {
          _tags.insert(0, tag);
        });
      },
          onDone: () {
        setState(() {
          _stream123 = null;
        });
      },
          onError: (e) {
        setState(() {
          _stream123 = null;
        });

        if (!(e is NFCUserCanceledSessionException)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Error!"),
              content: Text(e.toString()),
            ),
          );
        }
      });

      setState(() {
        _stream123 = subscription;
      });
    } catch (err) {
      print("error: $err");
    }
  }

  void _startScanning() {
    setState(() {
      _stream = NFC.readNDEF(once: true).listen((NDEFMessage message) {
        print("Read NDEF message with ${message.records.length} records");
        for (NDEFRecord record in message.records) {
          _messageList.add(Text(
              "Record '${record.id ?? "[NO ID]"}' with TNF '${record.tnf}', type '${record.type}', payload '${record.payload}' and data '${record.data}' and language code '${record.languageCode}'"));
              _stopScanning();
        }
      });
    });
  }

  void _stopScanning() {
    _stream?.cancel();
    setState(() {
      _stream = null;
    });
  }

  void _toggleScan() {
    if (_stream == null) {
      _startScanning();
    } else {
      _stopScanning();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[900],
      appBar: AppBar(
        title: Text('NFC Scanner'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/nfc.png',
            ),
          ),
          SizedBox(
            height: 50,
          ),
          new RaisedButton(
              child: Text(
                'Scan',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.purple,
              onPressed: () {
                _toggleScan();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SecondRoute(_messageList)));
              }),
        ],
      ),
    );
  }
}
class SecondRoute extends StatefulWidget {
  final List<Text> messageList;
  SecondRoute(this.messageList);
  @override
  _SecondRouteState createState() => _SecondRouteState();
}
class _SecondRouteState extends State<SecondRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Nfc Data'),
      ),
      body: Container(
        child: Column(
          children: widget.messageList,
        ),
      ),
    );
  }
}
