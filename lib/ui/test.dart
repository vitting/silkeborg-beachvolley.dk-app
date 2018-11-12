import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<String> names = [
  "Christian Nicolaisen",
  "Allan Nielsen",
  "Mads Langer",
  "Mogens Kjeldsen",
  "Hanne Jense",
  "Kim Nielsen"
];

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "test",
        body: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                QuerySnapshot snapshot = await Firestore.instance
                    .collection("write_to_sbv")
                    .where("sendToUserId",
                        isEqualTo: "bpxa64leuva3kh8FA7EzQbDBIfr1")
                    .where("type", isEqualTo: "message")
                    .where("deleted", isEqualTo: false)
                    .orderBy("createdDate", descending: true)
                    .getDocuments();

                    print("NUMBER OF DOCS: ${snapshot.documents.length}");
              },
              child: Text("TEST"),
            )
          ],
        ));
  }
}
