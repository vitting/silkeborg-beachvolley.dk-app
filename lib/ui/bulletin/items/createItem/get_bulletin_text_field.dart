import 'package:flutter/material.dart';

class BulletinTextField extends StatelessWidget {
  final Function onPressedSave;
  final Function onPressedPhoto;
  final Function onSave;
  final bool showPhotoButton;

  const BulletinTextField(
      {Key key,
      @required this.onPressedSave,
      @required this.onPressedPhoto,
      @required this.onSave,
      this.showPhotoButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLength: 500,
      maxLines: 6,
      decoration: new InputDecoration(
          labelText: "Opslag",
          suffixIcon: Column(
            mainAxisSize: MainAxisSize.min,
            children: _setButtons()
          )),
      validator: (String value) {
        if (value.isEmpty) return "Opslaget skal udfyldes";
      },
      onSaved: onSave,
    );
  }

  List<Widget> _setButtons() {
    List<Widget> widgets = [
      IconButton(icon: Icon(Icons.send), onPressed: onPressedSave)
    ];

    if (showPhotoButton) {
      widgets.add(
          IconButton(icon: Icon(Icons.add_a_photo), onPressed: onPressedPhoto));
    }

    return widgets;
  }
}
