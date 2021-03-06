import 'dart:async';

import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_committed_data.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_item_data.dart';

showCommittedDialog(BuildContext context, BulletinItemData item,
    [String title = "Tilmeldte"]) async {
  List widgets = await _buildCommittedDialogItems(item);

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(title: Text(title), children: widgets);
      });
}

Future<List> _buildCommittedDialogItems(BulletinItemData item) async {
  List<CommittedData> data = await item.getCommitted();
  return data.map((CommittedData committed) {
    return ListTile(
      title: Text(committed.name),
      leading: CircleProfileImage(url: committed.photoUrl),
    );
  }).toList();
}
