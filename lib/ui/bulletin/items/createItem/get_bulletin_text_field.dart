import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

class BulletinTextField extends StatelessWidget {
  final ValueChanged<bool> onPressedSave;
  final Function onPressedPhoto;
  final Function onSave;
  final bool showPhotoButton;
  final String initalValue;

  const BulletinTextField(
      {Key key,
      @required this.onPressedSave,
      @required this.onPressedPhoto,
      @required this.onSave,
      this.showPhotoButton = false,
      this.initalValue = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLength: 500,
      maxLines: 6,
      initialValue: initalValue,
      decoration: new InputDecoration(
          labelText: FlutterI18n.translate(
              context, "bulletin.getBulletinTextField.string1"),
          suffixIcon:
              Column(mainAxisSize: MainAxisSize.min, children: _setButtons())),
      validator: (String value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "bulletin.getBulletinTextField.string2");
      },
      onSaved: onSave,
      onEditingComplete: () {
        onPressedSave(true);
      },
    );
  }

  List<Widget> _setButtons() {
    List<Widget> widgets = [
      IconButton(
          icon: Icon(Icons.check_circle,
              color: SilkeborgBeachvolleyTheme.buttonTextColor),
          onPressed: () {
            onPressedSave(true);
          })
    ];

    if (showPhotoButton) {
      widgets.add(IconButton(
          icon: Icon(Icons.add_a_photo,
              color: SilkeborgBeachvolleyTheme.buttonTextColor),
          onPressed: onPressedPhoto));
    }

    return widgets;
  }
}
