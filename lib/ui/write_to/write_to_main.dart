import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/create/write_to_create_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';
import 'package:silkeborgbeachvolley/ui/write_to/detail/write_to_detail_main.dart';

class WriteTo extends StatefulWidget {
  static final String routeName = "/writeto";

  @override
  WriteToState createState() {
    return new WriteToState();
  }
}

class WriteToState extends State<WriteTo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: FlutterI18n.translate(context, "writeTo.writeToMain.title"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SilkeborgBeachvolleyTheme.buttonTextColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) => WriteToCreate()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: WriteToData.getAllMessagesByUserId(
            MainInherited.of(context).loggedInUser.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return LoaderSpinner();
          if (snapshot.hasData && snapshot.data.documents.length == 0)
            return NoData(
                FlutterI18n.translate(context, "writeTo.writeToMain.string1"));

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int position) {
              WriteToData doc =
                  WriteToData.fromMap(snapshot.data.documents[position].data);

              return WriteToRow(
                item: doc,
                onRowTap: (WriteToData item) {
                  Navigator.of(context).push(MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => WriteToDetail(
                            item: item,
                          )));
                },
              );
            },
          );
        },
      ),
    );
  }
}
