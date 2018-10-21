import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class PhotoAddPhoto extends StatelessWidget {
  final ValueChanged<String> menuItemOnTap;
  const PhotoAddPhoto({Key key, this.menuItemOnTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(FlutterI18n.translate(context, "bulletin.photoAddPhotoWidget.title")),
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text(FlutterI18n.translate(context, "bulletin.photoAddPhotoWidget.string1")),
                onTap: () {
                  menuItemOnTap("gallery");
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text(FlutterI18n.translate(context, "bulletin.photoAddPhotoWidget.string2")),
                onTap: () {
                  menuItemOnTap("camera");
                },
              )
            ],
          ),
        );
  }
}