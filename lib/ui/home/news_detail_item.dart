import 'package:flutter/material.dart';

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
    String title = widget.item["title"];
    String body = widget.item["body"];
    String author = widget.item["author"];
    String date = widget.item["date"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(author),
              Text(
                date,
                style: TextStyle(fontSize: 10.0),
              ),
            ],
          ),
          leading: Icon(Icons.face),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
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
            suffixIcon: IconButton(
              icon: Icon(Icons.insert_comment),
              onPressed: () {
                print(newComment.text);
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
      title: Row(
        children: <Widget>[Text(commentAuthor), Text(commentDate)],
      ),
      leading: Icon(Icons.people),
      subtitle: Text(commentBody),
    );
  }
}
