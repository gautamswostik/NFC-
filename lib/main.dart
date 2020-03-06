import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'readnfc.dart';
import 'writenfc.dart';
void main(){
  runApp(NFCRE()
  );
}

class NFCRE extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.limeAccent,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: const Text("NFC"),
        ),
        body: Builder(builder: (context) {
          return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height:150),
          Center(
            child: Text('Hover your phone over your NFC Device',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),),
          ),
          SizedBox(height: 40,),
          Center(
            child: new Image.asset('assets/nfc.png',),
          ),
          SizedBox(height:50,),
          new RaisedButton(
            child:
            Text('Go To Scanner',
            style: TextStyle(
              color:Colors.white,
            ),
            ),
            color: Colors.purple,
            onPressed:(){
              Navigator.pushNamed(context, "readnfc");
            }),
            SizedBox(height:50,),
          new RaisedButton(
            child:
            Text('Go TO Writer',
            style: TextStyle(
              color:Colors.white,
            ),
            ),
            color: Colors.purple,
            onPressed:(){
              Navigator.pushNamed(context, "write");
            }),
        ],
      );
        }),
      ),
      routes: {
        "readnfc": (context) => ReadNFC(),
        "write": (context) =>WriteNFC(),
      },
    );
  }
}
