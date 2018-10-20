import 'package:flutter/material.dart';

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
                title: Text("Indsæt billede fra"),
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Galleri"),
                onTap: () {
                  menuItemOnTap("gallery");
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Kamera"),
                onTap: () {
                  menuItemOnTap("camera");
                },
              )
            ],
          ),
        );
  }
}