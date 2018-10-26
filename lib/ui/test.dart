import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_firestore.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "test",
        body: StreamBuilder(
                stream: LivescoreFirestore.getAllStartedMatchesAsStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  try {
                    if (!snapshot.hasData) return LoaderSpinner();

                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int position) {
                        DocumentSnapshot ref =
                            snapshot.data.documents[position];
                        LivescoreData item = LivescoreData.fromMap(ref.data);
                        return Text(item.setsPlayed[0].setNumber.toString());
                      },
                    );
                  } catch (e) {
                    print(e);
                    return Container();
                  }
                },
              ));
  }
}
