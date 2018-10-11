import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/event_datetime_type_enum.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/tournament_calendar/helpers/torunament_data_class.dart';
import 'package:validate/validate.dart';

class CreateTournamentItem extends StatefulWidget {
  final TournamentData tournament;
  final String title;

  const CreateTournamentItem({Key key, this.tournament, this.title})
      : super(key: key);
  @override
  _CreateTournamentItemState createState() => _CreateTournamentItemState();
}

class _CreateTournamentItemState extends State<CreateTournamentItem> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TournamentData _data;
  TextEditingController _startDateController;
  TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _data = widget.tournament ??
        TournamentData(
            title: "",
            body: "",
            link: "",
            startDate: DateTime.now(),
            endDate: DateTime.now());

    _startDateController =
        TextEditingController(text: DateTimeHelpers.ddmmyyyy(_data.startDate));
    _endDateController =
        TextEditingController(text: DateTimeHelpers.ddmmyyyy(_data.endDate));
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: widget.title,
      body: _main(),
    );
  }

  Widget _main() {
    return Card(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Form(
                  key: _formState,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: TextFormField(
                                  controller: _startDateController,
                                  onSaved: (_) {},
                                  validator: (String value) {
                                    if (value.isEmpty)
                                      return "Udyld start dato";
                                  },
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    labelText: "Start dato",
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      onPressed: () {
                                        _selectDate(
                                            context, DateTimeType.startDate);
                                      },
                                    ),
                                  ))),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _endDateController,
                              onSaved: (_) {},
                              validator: (String value) {
                                if (value.isEmpty) return "Udyld slut dato";
                              },
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  labelText: "Slut dato",
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today),
                                    onPressed: () {
                                      _selectDate(
                                          context, DateTimeType.endDate);
                                    },
                                  )),
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        initialValue: _data.title,
                        keyboardType: TextInputType.text,
                        decoration:
                            InputDecoration(labelText: "Sted / kort titel"),
                        inputFormatters: [LengthLimitingTextInputFormatter(25)],
                        onSaved: (String value) {
                          _data.title = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty) return "Udfyld sted / kort titel";
                        },
                      ),
                      TextFormField(
                        initialValue: _data.body,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Tekst"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(500)
                        ],
                        onSaved: (String value) {
                          _data.body = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty) return "Udfyld tekst";
                        },
                      ),
                      TextFormField(
                        initialValue: _data.link,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Link til hjemmeside",
                            helperText: "Link er ikke påkrævet"),
                        onSaved: (String value) {
                          _data.link = value.toLowerCase().trim();
                        },
                        validator: (String value) {
                          if (value.trim().isNotEmpty) {
                            RegExp exp = RegExp(
                                "^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\$");
                            try {
                              Validate.matchesPattern(
                                  value.toLowerCase().trim(), exp);
                            } catch (e) {
                              return "Det indtastede link er ikke et valid link";
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FlatButton.icon(
                    textColor: Colors.deepOrange[700],
                    icon: Icon(Icons.save),
                    label: Text("Gem turnering"),
                    onPressed: () {
                      if (_formState.currentState.validate()) {
                        _formState.currentState.save();
                        Navigator.of(context).pop<TournamentData>(_data);
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(
      BuildContext context, DateTimeType dateTimeType) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _setDate(dateTimeType),
        firstDate: new DateTime(DateTime.now().year - 1),
        lastDate: new DateTime(DateTime.now().year + 1),
        initialDatePickerMode: DatePickerMode.day);

    if (picked != null) {
      setState(() {
        String formattedDate = DateTimeHelpers.ddmmyyyy(picked);
        switch (dateTimeType) {
          case DateTimeType.startDate:
            _startDateController.text = formattedDate;
            _endDateController.text = formattedDate;
            _data.startDate = picked;
            _data.endDate = picked;
            break;
          case DateTimeType.endDate:
            _endDateController.text = formattedDate;
            _data.endDate = picked;
            break;
          default:
            print(formattedDate);
        }
      });
    }
  }

  DateTime _setDate(DateTimeType type) {
    DateTime date;
    if (type == DateTimeType.startDate) date = _data.startDate;
    if (type == DateTimeType.endDate) date = _data.endDate;
    return date;
  }
}
