import 'dart:async';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/home/create_news_main.dart';
import 'package:silkeborgbeachvolley/ui/home/news_list_item.dart';
import 'package:silkeborgbeachvolley/ui/home/testdata.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley",
        body: _main(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _openCreateNewsDialog();
          },
        ),
        actions: <Widget>[
          PopupMenuButton<int>(
            initialValue: 1,
            onSelected: (value) async {
              if (value == 1) {
                Navigator.pushNamed(context, "/settings");   
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Indstillinger"),
                  value: 1,
                )
              ];
            },
            icon: Icon(Icons.more_vert),
          )
        ]);
  }

  Widget _main() {
    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      itemBuilder: (BuildContext context, int position) {
        return NewsListItem(data[position], position);
      },
    );
  }

  Future _openCreateNewsDialog() async {
    CreateNewsValues createNewsValues = await Navigator.of(context)
        .push(new MaterialPageRoute<CreateNewsValues>(
            builder: (BuildContext context) {
              return new CreateNews();
            },
            fullscreenDialog: false));

    if (createNewsValues != null) {
      print(createNewsValues.body + "/" + createNewsValues.type.toString());
    }
  }
}
