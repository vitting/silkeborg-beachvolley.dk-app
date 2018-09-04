import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';
import "package:intl/intl.dart";
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:validate/validate.dart';

class User {
  String name = "";
  String street = "";
  String postalCode = "";
  String birthdate = "";
  String email = "";
  String phone = "";
}

class Enrollment extends StatefulWidget {
  @override
  _EnrollmentState createState() => _EnrollmentState();
}

class _EnrollmentState extends State<Enrollment> {
  final _birtdateController = TextEditingController();
  final _user = new User();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _birtdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Sileborg Beachvolley",
      body: _main(),
    );
  }

  //Datepicker dialog
  Future<Null> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1940),
        lastDate: new DateTime(new DateTime.now().year + 1),
        initialDatePickerMode: DatePickerMode.year);

    if (picked != null && picked != new DateTime.now()) {
      setState(() {
        //initializeDateFormatting loads the specified local
        initializeDateFormatting("da", null).then((_) {
          _birtdateController.text = new DateFormat.yMd("da").format(picked);
        });
      });
    }
  }

  Widget _main() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _nameField(),
              _adressField(),
              _postalcodeField(),
              _birthdayField(),
              _emailField(),
              _mobilenumberField(),
              _sendButton(),
            ],
          )),
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Navn"),
      validator: (String value) {
        if (value.isEmpty) return "Indtast dit navn";
      },
      keyboardType: TextInputType.text,
      maxLength: 30,
      autofocus: true,
      onSaved: (String value) {
        _user.name = value.trim();
      },
    );
  }

  Widget _adressField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Addresse"),
      validator: (String value) {
        if (value.isEmpty) return "Indtast din addresse";
      },
      keyboardType: TextInputType.text,
      maxLength: 50,
      onSaved: (String value) {
        _user.street = value.trim();
      },
    );
  }

  Widget _postalcodeField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Postnummer",
      ),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value.trim()) == null)
          return "Indtast dit postnummer";
      },
      keyboardType: TextInputType.number,
      maxLength: 4,
      onSaved: (String value) {
        _user.postalCode = value.trim();
      },
    );
  }

  Widget _birthdayField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Fødselsdato",
        hintText: "dag/måned/år",
        suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            }),
      ),
      controller: _birtdateController,
      validator: (String value) {
        if (value.isEmpty) return "Indtast fødselsdato";

        try {
          DateFormat.yMd("da").parse(value.trim());
        } catch (e) {
          return "Indtast fødselsdato som dag/måned/år";
        }
      },
      keyboardType: TextInputType.datetime,
      maxLength: 10,
      onSaved: (String value) {
        _user.birthdate = value.trim();
      },
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "E-mail"),
      validator: (String value) {
        if (value.isEmpty) return "Indtast din e-mail addresse";
        try {
          Validate.isEmail(value.trim());
        } catch (e) {
          return "Indtast en gyldig e-mail addresse";
        }
      },
      keyboardType: TextInputType.emailAddress,
      maxLength: 50,
      onSaved: (String value) {
        _user.email = value.trim();
      },
    );
  }

  Widget _mobilenumberField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Mobilnummer"),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value.trim()) == null)
          return "Indtast dit mobilnummer";
      },
      keyboardType: TextInputType.phone,
      maxLength: 8,
      onSaved: (String value) {
        _user.phone = value.trim();
      },
    );
  }

  Widget _sendButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _formKey.currentState.reset();
            _birtdateController.text = "";
          }

          Scaffold
              .of(context)
              .showSnackBar(SnackBar(content: Text('Tak for din indmeldelse')));
        },
        child: Text('Send'),
      ),
    );
  }
}
