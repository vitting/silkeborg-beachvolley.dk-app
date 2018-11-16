import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/no_data_widget.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/create/write_to_create_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/detail/write_to_detail_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_data.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_row.dart';

class WriteTo extends StatefulWidget {
  static final String routeName = "/writeto";

  @override
  WriteToState createState() {
    return new WriteToState();
  }
}

class WriteToState extends State<WriteTo> {
  Future<List<WriteToData>> list;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: FlutterI18n.translate(context, "writeTo.writeToMain.title1"),
        floatingActionButton: FloatingActionButton(
          backgroundColor: SilkeborgBeachvolleyTheme.buttonTextColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => WriteToCreate(
                      user: MainInherited.of(context).loggedInUser,
                    )));
          },
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
          backgroundColor: Colors.deepOrange[700],
          color: Colors.white,
          child: _main(),
          onRefresh: () {
            setState(() {
              list = WriteToData.getAllMessagesByUserId(
                  MainInherited.of(context).userId);
            });
            return Future.value(true);
          },
        ));
  }

  Widget _main() {
    list = WriteToData.getAllMessagesByUserId(MainInherited.of(context).userId);
    return FutureBuilder(
      future: list,
      // future: WriteToData.getAllMessagesByUserId(MainInherited.of(context).userId),
      builder:
          (BuildContext context, AsyncSnapshot<List<WriteToData>> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();
        if (snapshot.hasData && snapshot.data.length == 0)
          return NoData(
              FlutterI18n.translate(context, "writeTo.writeToMain.string1"));

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int position) {
            return WriteToRow(
              item: snapshot.data[position],
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
    );
  }
}
