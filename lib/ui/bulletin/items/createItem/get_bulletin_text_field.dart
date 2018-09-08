import 'package:flutter/material.dart';

class BulletinTextField extends StatelessWidget {
  final Function onPressedSave;
  final Function onPressedPhoto;
  final Function onSave;

  const BulletinTextField({Key key, @required this.onPressedSave, @required this.onPressedPhoto, @required this.onSave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLength: 500,
      maxLines: 6,
      decoration: new InputDecoration(
          labelText: "Opslag",
          suffixIcon: Column(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.send),
                onPressed: onPressedSave
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: onPressedPhoto                    
              )
            ],
          )),
      validator: (String value) {
        if (value.isEmpty) return "Opslaget skal udfyldes";
      },
      onSaved: onSave,
    );
  }
}
