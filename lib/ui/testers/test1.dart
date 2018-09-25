import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Test1Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "test1",
      body: Container(
      child: RaisedButton(
        onPressed: () async {
          List<String> a = ["asdas", "sfsdf", "dsfsdfs", "dfsdf", "rrtfwe"];

          
          a.any((String value) {
            print("BEFORE: $value");
            if (value == "sfsdf") return true;
            print("AFTER: $value");
            return false;
          });


          // Firestore.instance.collection("test").add({"id": "fsdfsdf", "list": ["sdfsfd", "abc", "cba"]});
          // DocumentReference a = Firestore.instance.collection("test").document("-LN2JqhNl4U2_pjSYX51");
          // a.updateData({
          //   "list": ["ABCD", "DFG", "DDDD"]
          // });

          // DocumentReference a = Firestore.instance.collection("test").document("-LN2JqhNl4U2_pjSYX51");
          // a.updateData({
          //   "list": FieldValue.arrayRemove("DDDD")
          // });
          
          // QuerySnapshot a = await Firestore.instance.collection("test").where("list", arrayContains: "abc").getDocuments();
          // print(a.documents.length);
          
          
        },
        child: Text("Test1"),
      ),
    ),
    );
  }
}
