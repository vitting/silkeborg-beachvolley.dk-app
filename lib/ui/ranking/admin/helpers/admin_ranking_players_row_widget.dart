import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(photoUrl),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(name),
              ),
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  rowOnMenuTap(true);
                },
              )
            ],
          )),
    );
  }
}
