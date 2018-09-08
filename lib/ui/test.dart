import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
// import 'package:multiple_image_picker/multiple_image_picker.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_firebase_class.dart';
import 'package:silkeborgbeachvolley/ui/testers/test2.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


final FirebaseStorage storage = FirebaseStorage.instance;
final Firestore firestore = Firestore.instance;
final uuid = new Uuid();

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  List<File> _imageFiles = [];

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    // print("BUILD Width: ${size.width} / Height: ${size.height}");
  
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onLongPress: () {
              // _delete(file);
            },
            child: Image.file(null),
          ),
          RaisedButton(
            onPressed: () async {
              String link2;
              print(link2);
              File image = await ImagePicker.pickImage(source: ImageSource.gallery);
              File file = await Test2.processNewsImage(image);
              _imageFiles.add(file);
              
              //Vi skal lave det sådan at hvis man sletter et billede inden man opretter nyheden så skal den fjernes

              // print("************LINK $link");
              // if (image != null) {
              //   Uri downloadLink = await Test2.resizeImageTo1200(image);
              //   print(downloadLink);
              //   if (downloadLink != null) {
              //     setState(() {
              //       _images.add(image);
              //     });
              //   }
              // }
            },
            child: Text("Image file"),
          ),
          RaisedButton(
            onPressed: () async {
              File image = await ImagePicker.pickImage(source: ImageSource.camera);
              if (image != null) {
                setState(() {
                  _imageFiles.add(image);
                });
              }
            },
            child: Text("Image camera"),
          ),
          ListView.builder(
            itemCount: _imageFiles.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int position) {
              
              return Image.file(_imageFiles[position], height: 100.0, width: 300.0,);
            },
          )
        ],
      )
    );
  }
}


// CustomScrollView(
//         slivers: <Widget>[
//           SliverList(
//             delegate: SliverChildListDelegate(<Widget>[
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//               Text("TEST"),
//             ]),
//           ),
//           SliverList(
//                 delegate: SliverChildListDelegate(<Widget> [
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3"),
//                   Text("Test2"),
//                   Text("Test3")
//                 ]),
//               )
//         ],
//       )