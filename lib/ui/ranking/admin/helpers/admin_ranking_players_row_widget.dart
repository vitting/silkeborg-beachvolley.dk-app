import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';

class AdminRankingPlayersRow extends StatelessWidget {
  final String name;
  final String photoUrl;
  final ValueChanged<bool> rowOnTap;
  final ValueChanged<bool> rowOnMenuTap;

  const AdminRankingPlayersRow(
      {Key key, this.name, this.photoUrl, this.rowOnTap, this.rowOnMenuTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          onTap: () {
            rowOnTap(true);
          },
          leading: CircleProfileImage(url: photoUrl),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(name),
              ),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  rowOnMenuTap(true);
                },
              )
            ],
          )),
    );
  }
}
