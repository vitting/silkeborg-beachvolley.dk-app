import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
final Firestore firestore = Firestore.instance;
final uuid = new Uuid();

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              loadData();
            },
            child: Text("Knap1"),
          )
        ],
      )
    );
  }

/*
1. loadData is call
2. a thread is created
3. Static dataLoader is calls with a communication port. 
4. dataLoader opens a communication port back to loadData. 
5. dataLoader tells loadData the port i listens to (sendPort).
6. dataLoader waits for messages to receive.
7. LoadData calls sendReceive with it's listen port and data

 */
  loadData() async {
    //VI opretter en port vi kan modtage data på. 
    ReceivePort receivePort = ReceivePort();
    //Vi opretter tråden og fortæller hviklen funcktion der skal køre i tråden og hvad
    //vores modtager port er
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message

    //Vi siger til tråden at når den er klar så send os hvad trådens modtager port er
    SendPort sendPort = await receivePort.first;

    //VI kalder en metode sendReceive med hvad vores tråds port er. og noget data
    List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

    print(msg.length);
  }

   static dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort); // Vi fortæller loadData hvilken port vi bruger.

    await for (var msg in port) { //Venter på at vi får data ind fra sendReceive
      String data = msg[0]; // Modtaget fra sendReceiver
      SendPort replyTo = msg[1];  // Modtaget fra sendReceiver. 
                                  //Fortæller os hvilken port vi kan sende data tilbage til.

      //Udfører arbejdet
      String dataURL = data; 
      http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
      replyTo.send(json.decode(response.body)); // Vi sender det bearbejde data tilbage til sendReceive
    }
  }

  //Modtager fra loadData hvilken port vi skal bruge for at snakke med tråden
  Future sendReceive(SendPort port, msg) { 
    //Vi opretter en modtager port.
    ReceivePort response = ReceivePort();
    //Vi sender en besked til Tråden med data og hvilken port den kan sende data tilbage til.
    port.send([msg, response.sendPort]);
    //Vi modtager data fra Tråden
    return response.first; 
  }
}


/*
import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart';

class DecodeParam {
  final File file;
  final SendPort sendPort;
  DecodeParam(this.file, this.sendPort);
}

void decode(DecodeParam param) {
  // Read an image from file (webp in this case).
  // decodeImage will identify the format of the image and use the appropriate
  // decoder.
  Image image = decodeImage(param.file.readAsBytesSync());
  // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
  Image thumbnail = gaussianBlur(copyResize(image, 120), 5);
  param.sendPort.send(thumbnail);
}

// Decode and process an image file in a separate thread (isolate) to avoid
// stalling the main UI thread.
void main() async {
  ReceivePort receivePort = new ReceivePort();

  await Isolate.spawn(decode,
      new DecodeParam(new File('test.webp'), receivePort.sendPort));

  // Get the processed image from the isolate.
  Image image = await receivePort.first;

  new File('thumbnail.png').writeAsBytesSync(encodePng(image));
}
 */