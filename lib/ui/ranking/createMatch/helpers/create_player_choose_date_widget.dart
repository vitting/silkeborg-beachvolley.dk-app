import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';

class CreatePlayerChooseDate extends StatefulWidget {
  final Color color;
  final ValueChanged<DateTime> datePicked;
  const CreatePlayerChooseDate(
      {Key key, @required this.color, @required this.datePicked})
      : super(key: key);

  @override
  CreatePlayerChooseDateState createState() {
    return new CreatePlayerChooseDateState();
  }
}

class CreatePlayerChooseDateState extends State<CreatePlayerChooseDate> {
  String _dateText = "";

  @override
  Widget build(BuildContext context) {
    _dateText = FlutterI18n.translate(context, "ranking.createPlayerChooseDateWidget.string1");
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: Icon(
                FontAwesomeIcons.calendarPlus,
                size: 30.0,
                color: widget.color,
              ),
            ),
            Text(_dateText)
          ],
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day);

    widget.datePicked(picked);

    if (picked != null) {
      setState(() {
        _dateText = DateTimeHelpers.ddmmyyyy(picked);
      });
    }
  }
}
