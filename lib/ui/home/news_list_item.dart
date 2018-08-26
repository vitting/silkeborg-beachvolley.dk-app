import 'package:flutter/material.dart';

class NewsListItem extends StatelessWidget {
  final Map<String, Object> item;
  final int index;

  NewsListItem(this.item, this.index);

  @override
  Widget build(BuildContext context) {
    final String _title = item["title"];
    final String _body = item["body"];
    final String _iconType = item["type"];
    final String _date = item["date"];
    final List<Map> _comments = item["comments"];
    final String _numberOfComments = _comments.length.toString();

    return ListBody(
      children: <Widget>[
        ListTile(
          title: Text(_title),
          subtitle: _body != ""
              ? Text(_body, maxLines: 3, overflow: TextOverflow.ellipsis)
              : null,
          leading: Icon(
              _iconType == "info" ? Icons.info : Icons.store_mall_directory,
              size: 40.0),
          onTap: () {
            print(index.toString());
          },
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 74.0, top: 2.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.access_time, size: 12.0),
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 5.0),
                  child: Text(
                    _date,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 12.0),
                  )),
              Padding(
                padding: EdgeInsetsDirectional.only(start: 20.0),
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 12.0,
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.only(start: 5.0),
                  child: Text(
                    _numberOfComments,
                    style: TextStyle(fontSize: 12.0),
                  ))
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}
