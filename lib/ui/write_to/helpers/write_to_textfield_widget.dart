import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';

class WriteToTextfield extends StatefulWidget {
  final ValueChanged<String> onTextFieldSubmit;
  final Color backgroundColor;

  const WriteToTextfield(
      {Key key, this.onTextFieldSubmit, this.backgroundColor = Colors.white70})
      : super(key: key);

  @override
  WriteToTextfieldState createState() {
    return new WriteToTextfieldState();
  }
}

class WriteToTextfieldState extends State<WriteToTextfield> {
  TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
      child: TextField(
        controller: _textFieldController,
        textInputAction: TextInputAction.send,
        onSubmitted: (String value) {
          widget.onTextFieldSubmit(value);
          if (value.trim().isNotEmpty) _textFieldController.clear();
        },
        inputFormatters: [LengthLimitingTextInputFormatter(500)],
        maxLines: 1,
        style: TextStyle(
            decorationStyle: TextDecorationStyle.solid, color: Colors.black),
        decoration: InputDecoration(
            suffixIcon: IconButton(
                icon: Icon(Icons.send),
                color: SilkeborgBeachvolleyTheme.buttonTextColor,
                onPressed: () {
                  widget.onTextFieldSubmit(_textFieldController.text);
                  if (_textFieldController.text.trim().isNotEmpty) {
                    _textFieldController.clear();
                    SystemHelpers.hideKeyboardWithNoFocus(context);
                  }
                }),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black45, width: 2.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
            ),
            hintText: FlutterI18n.translate(
                context, "writeTo.writeToTextfieldWidget.string1")),
      ),
    );
  }
}
