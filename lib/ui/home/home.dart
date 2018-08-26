import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/home/news_list_item.dart';
import 'package:silkeborgbeachvolley/ui/home/testdata.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      itemBuilder: (BuildContext context, int position) {
        return NewsListItem(data[position], position);
      } ,
    );
  }
}
