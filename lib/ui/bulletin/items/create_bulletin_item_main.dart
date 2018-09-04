import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/bulletinItemCreator_class.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_formatters.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

enum EventDateTimeType { startDate, endDate, startTime, endTime }

String radioGroupValue = BulletinType.news;

class CreateBulletinItem extends StatefulWidget {
  @override
  _CreateBulletinItemState createState() => _CreateBulletinItemState();
}

class _CreateBulletinItemState extends State<CreateBulletinItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _startDateController =
      new TextEditingController();
  final TextEditingController _endDateController = new TextEditingController();
  final TextEditingController _startTimeController =
      new TextEditingController();
  final TextEditingController _endTimeController = new TextEditingController();
  bool _saving = false;
  String _selectedBulletinType = BulletinType.news;
  String _selectedBulletinBody = "";
  DateTime _selectedEventStartDate;
  DateTime _selectedEventEndDate;
  TimeOfDay _selectedEventStartTime;
  TimeOfDay _selectedEventEndTime;
  String _selectedEventLocation;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley",
        body: ModalProgressHUD(
            opacity: 0.5, child: _main(), inAsyncCall: _saving));
  }

  Widget _main() {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        _chooseBulletinType(),
        _createBulletinItemForm(context)
      ],
    );
  }

  Widget _chooseBulletinType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Opslags type",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16.0),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20.0, end: 20.0, top: 10.0),
          child: Column(
            children: <Widget>[
              RadioListTile<String>(
                dense: true,
                title: Text("Nyhed"),
                secondary: Icon(FontAwesomeIcons.newspaper),
                groupValue: radioGroupValue,
                value: BulletinType.news,
                onChanged: (value) {
                  setState(() {
                    _selectedBulletinType = value;
                    radioGroupValue = value;
                  });
                },
              ),
              RadioListTile<String>(
                dense: true,
                title: Text("Begivenhed"),
                secondary: Icon(FontAwesomeIcons.calendarTimes),
                groupValue: radioGroupValue,
                value: BulletinType.event,
                onChanged: (value) {
                  setState(() {
                    _selectedBulletinType = value;
                    radioGroupValue = value;
                  });
                },
              ),
              RadioListTile<String>(
                dense: true,
                title: Text("Spil"),
                secondary: Icon(FontAwesomeIcons.volleyballBall),
                groupValue: radioGroupValue,
                value: BulletinType.play,
                onChanged: (value) {
                  setState(() {
                    _selectedBulletinType = value;
                    radioGroupValue = value;
                  });
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _createBulletinItemForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: _fieldsToShowInForm(context)),
    );
  }

  List<Widget> _fieldsToShowInForm(BuildContext context) {
    List<Widget> widgets = [];

    if (radioGroupValue == BulletinType.event) {
      widgets = _eventFields(context);
      widgets.add(_bulletinTextField(context));
    } else {
      widgets.add(_bulletinTextField(context));
    }

    return widgets;
  }

  Widget _bulletinTextField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      maxLength: 500,
      maxLines: 6,
      decoration: new InputDecoration(
          labelText: "Opslag",
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                _formKey.currentState.reset();

                setState(() {
                  _saving = true;
                });
                await _saveBulletinItem();
                setState(() {
                  radioGroupValue = BulletinType.news;
                  _saving = false;
                });
                Navigator.of(context).pop();
              }
            },
          )),
      validator: (String value) {
        if (value.isEmpty) return "Opslaget skal udfyldes";
      },
      onSaved: (String value) {
        _selectedBulletinBody = value;
      },
    );
  }

  List<Widget> _eventFields(BuildContext context) {
    List<Widget> widgets = [
      Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.center,
              controller: _startDateController,
              decoration: InputDecoration(
                  labelText: "Start dato",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      _selectDate(context, EventDateTimeType.startDate);
                    },
                  )),
              validator: (value) {
                if (value.isEmpty) return "Udfyld Start dato";
              },
              onSaved: (value) {},
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.center,
              controller: _endDateController,
              decoration: InputDecoration(
                  labelText: "Slut dato",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      _selectDate(context, EventDateTimeType.endDate);
                    },
                  )),
              validator: (value) {
                if (value.isEmpty) return "Udfyld Slut dato";
              },
              onSaved: (value) {},
            ),
          )
        ],
      ),
      Row(
        children: <Widget>[
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.center,
              controller: _startTimeController,
              decoration: InputDecoration(
                  labelText: "Start tid",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      _selectTime(context, EventDateTimeType.startTime);
                    },
                  )),
              validator: (value) {
                if (value.isEmpty) return "Udfyld Start tid";
              },
              onSaved: (value) {},
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: TextFormField(
              keyboardType: TextInputType.datetime,
              textAlign: TextAlign.center,
              controller: _endTimeController,
              decoration: InputDecoration(
                  labelText: "Slut tid",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () async {
                      _selectTime(context, EventDateTimeType.endTime);
                    },
                  )),
              validator: (value) {
                if (value.isEmpty) return "Udfyld Slut tid";
              },
              onSaved: (value) {},
            ),
          )
        ],
      ),
      TextFormField(
        keyboardType: TextInputType.text,
        maxLength: 100,
        decoration: InputDecoration(
          labelText: "Sted"
        ),
        onSaved: (value) {
          _selectedEventLocation = value;
        },
        validator: (value) {
          if (value.isEmpty) return "Sted skal udfyldes";
        },
      )
    ];
    return widgets;
  }

  Future<Null> _selectDate(
      BuildContext context, EventDateTimeType eventDateTimeType) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(DateTime.now().year),
        lastDate: new DateTime(DateTime.now().year + 1),
        initialDatePickerMode: DatePickerMode.day);

    if (picked != null) {
      setState(() {
        String formattedDate = DateTimeFormatters.formatDateDDMMYYY(picked);
        switch (eventDateTimeType) {
          case EventDateTimeType.startDate:
            _startDateController.text = formattedDate;
            _endDateController.text = formattedDate;
            _selectedEventStartDate = picked;
            _selectedEventEndDate = picked;
            break;
          case EventDateTimeType.endDate:
            _endDateController.text = formattedDate;
            _selectedEventEndDate = picked;
            break;
          default:
            print(formattedDate);
        }
      });
    }
  }

  Future<Null> _selectTime(
      BuildContext context, EventDateTimeType eventDateTimeType) async {
    TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        switch (eventDateTimeType) {
          case EventDateTimeType.startTime:
            _startTimeController.text = picked.format(context);
            _endTimeController.text =
                picked.replacing(hour: picked.hour + 2).format(context);
            _selectedEventStartTime = picked;
            _selectedEventEndTime = picked.replacing(hour: picked.hour + 2);
            break;
          case EventDateTimeType.endTime:
            _endTimeController.text = picked.format(context);
            _selectedEventEndTime = picked;
            break;
          default:
            print(picked);
        }
      });
    }
  }

  Future<void> _saveBulletinItem() async {
    var item = await BulletinItemCreator.createBulletinItem(
        body: _selectedBulletinBody,
        type: _selectedBulletinType,
        eventLocation: _selectedEventLocation,
        eventStartDate: _selectedEventStartDate,
        eventEndDate: _selectedEventEndDate,
        eventStartTime: _selectedEventStartTime,
        eventEndTime: _selectedEventEndTime);

    await BulletinFirestore.saveBulletinItem(item);
  }
}
