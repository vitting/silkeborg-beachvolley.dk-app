import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class LivescoreCreateEdit extends StatefulWidget {
  final LivescoreData match;

  const LivescoreCreateEdit({Key key, this.match}) : super(key: key);
  @override
  _LivescoreCreateEditState createState() => _LivescoreCreateEditState();
}

class _LivescoreCreateEditState extends State<LivescoreCreateEdit> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TextEditingController _matchDateController = TextEditingController();
  TextEditingController _matchTimeController = TextEditingController();
  LivescoreData _match;
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    if (widget.match != null) {
      _match = widget.match;
    } else {
      _match = LivescoreData(
          title: "",
          namePlayer1Team1: "",
          namePlayer1Team2: "",
          namePlayer2Team1: "",
          namePlayer2Team2: "",
          matchDate: DateTime.now());
    }

    _matchDateController.text = DateTimeHelpers.ddmmyyyy(_match.matchDate);
    _matchTimeController.text = DateTimeHelpers.hhnn(_match.matchDate);
  }

  @override
  void dispose() {
    _matchDateController.dispose();
    _matchTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
          title: "Live score opret kamp",
          body: LoaderSpinnerOverlay(
        show: _saving,
        showModalBarrier: true,
        text: "Opretter kampen",
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: <Widget>[
                Form(
                  key: _formState,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _match.title,
                        keyboardType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(250)],
                        textInputAction: TextInputAction.next,
                        onSaved: (String value) {
                          _match.title = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty) return "Titel skal udfyldes";
                        },
                        decoration: InputDecoration(labelText: "Titel"),
                      ),
                      Row(
                        children: <Widget>[
                          Flexible(
                              child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  textAlign: TextAlign.center,
                                  controller: _matchDateController,
                                  decoration: InputDecoration(
                                      labelText: "Kamp dato",
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed: () async {
                                          _selectDate(context);
                                        },
                                      )),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "Kamp dato skal udfyldes";
                                  })),
                          Flexible(
                              child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  textAlign: TextAlign.center,
                                  controller: _matchTimeController,
                                  decoration: InputDecoration(
                                      labelText: "Kamp tid",
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.access_time),
                                        onPressed: () async {
                                          _selectTime(context);
                                        },
                                      )),
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return "Kamp tid skal udfyldes";
                                  }))
                        ],
                      ),
                      TextFormField(
                        initialValue: _match.namePlayer1Team1,
                        keyboardType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        textInputAction: TextInputAction.next,
                        onSaved: (String value) {
                          _match.namePlayer1Team1 = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Navnet på spiller 1 team 1 skal udfyldes";
                        },
                        decoration: InputDecoration(
                            labelText: "Navn: spiller 1 team 1"),
                      ),
                      TextFormField(
                        initialValue: _match.namePlayer2Team1,
                        keyboardType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        textInputAction: TextInputAction.next,
                        onSaved: (String value) {
                          _match.namePlayer2Team1 = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Navn: spiller 2 team 1 skal udfyldes";
                        },
                        decoration: InputDecoration(
                            labelText: "Navn: spiller 2 team 1"),
                      ),
                      TextFormField(
                        initialValue: _match.namePlayer1Team2,
                        keyboardType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        textInputAction: TextInputAction.next,
                        onSaved: (String value) {
                          _match.namePlayer1Team2 = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Navn: på spiller 1 team 2 skal udfyldes";
                        },
                        decoration: InputDecoration(
                            labelText: "Navn: spiller 1 team 2"),
                      ),
                      TextFormField(
                        initialValue: _match.namePlayer2Team2,
                        keyboardType: TextInputType.text,
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        textInputAction: TextInputAction.next,
                        onSaved: (String value) {
                          _match.namePlayer2Team2 = value;
                        },
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Navn: spiller 2 team 2 skal udfyldes";
                        },
                        decoration: InputDecoration(
                            labelText: "Navn på spiller 2 team 2"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: FlatButton.icon(
                          icon: Icon(Icons.save),
                          label: Text("Opret kampen"),
                          onPressed: () async {
                            if (_formState.currentState.validate()) {
                              setState(() {
                                _saving = true;
                              });

                              _formState.currentState.save();
                              await _match.save();

                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _match.matchDate,
        firstDate: _match.matchDate,
        lastDate: new DateTime(_match.matchDate.year + 1),
        initialDatePickerMode: DatePickerMode.day);

    if (picked != null) {
      setState(() {
        _matchDateController.text = DateTimeHelpers.ddmmyyyy(picked);
        _match.matchDate = DateTime(picked.year, picked.month, picked.day,
            _match.matchDate.hour, _match.matchDate.minute);
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_match.matchDate));

    if (picked != null) {
      setState(() {
        _matchTimeController.text = picked.format(context);
        _match.matchDate = DateTime(
            _match.matchDate.year,
            _match.matchDate.month,
            _match.matchDate.day,
            picked.hour,
            picked.minute);
      });
    }
  }
}
