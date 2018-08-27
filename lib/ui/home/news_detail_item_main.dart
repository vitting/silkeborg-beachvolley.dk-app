import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class NewsDetailItem extends StatefulWidget {
  final item;
  NewsDetailItem(this.item);

  @override
  _NewsDetailItemState createState() => _NewsDetailItemState();
}

class _NewsDetailItemState extends State<NewsDetailItem> {
  List<Map> _comments;

  @override
  void initState() {
    super.initState();
    _comments = widget.item["comments"];
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley", body: _main());
  } 

  Widget _main() {
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: _comments.length + 1,
      itemBuilder: (BuildContext context, int position) {
        if (position == 0) {
          return _firstItem();
        }
        return _commentItem(position);
      },
    );
  }

  Widget _firstItem() {
    String body = widget.item["body"];
    String author = widget.item["author"];
    String date = widget.item["date"];
    int numberOfComments = _comments.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(author),
              Row(
                children: <Widget>[
                  Icon(Icons.access_time, size: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      date,
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 5.0),
                    child: Icon(Icons.chat_bubble_outline, size: 10.0),
                  ),
                  Text(
                    numberOfComments.toString(),
                    style: TextStyle(fontSize: 10.0)
                  )
                ],
              )
            ],
          ),
          leading: Icon(Icons.face),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Text(body),
        ),
        _addComment()
      ],
    );
  }

  Widget _addComment() {
    TextEditingController newComment = new TextEditingController();

    return ListBody(
      children: <Widget>[
        TextField(
          controller: newComment,
          decoration: InputDecoration(
              labelText: "Skriv kommentar",
              suffixIcon: IconButton(
                icon: Icon(Icons.insert_comment),
                onPressed: () {
                  if (newComment.text.isNotEmpty) {
                    var comment = {
                      "body": newComment.text,
                      "author": "Irene Nissen",
                      "date": "26-07-2018 11:58"
                    };

                    newComment.clear();

                    setState(() {
                      _comments.add(comment);
                    });
                  }
                },
              )),
        )
      ],
    );
  }

  Widget _commentItem(int position) {
    Map commentItem = _comments[position - 1];
    String commentBody = commentItem["body"];
    String commentAuthor = commentItem["author"];
    String commentDate = commentItem["date"];

    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(commentAuthor), 
          Row(
            children: <Widget>[
              Icon(Icons.access_time, size: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  commentDate,
                  style: TextStyle(
                    fontSize: 10.0
                  )
                ),
              )
            ],  
          )
        ],
      ),
      leading: Icon(Icons.people),
      subtitle: Text(commentBody),
    );
  }
}
