import 'dart:async';
import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers_class.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_firestore.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_class.dart';
import 'package:validate/validate.dart';

class Enrollment extends StatefulWidget {
  static final routeName = "/enrollment";
  Enrollment();
  @override
  _EnrollmentState createState() => _EnrollmentState();
}

class _EnrollmentState extends State<Enrollment> {
  final _birtdateController = TextEditingController();
  final _user = new EnrollmentUser(createdDate: DateTime.now());
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _birtdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _main();
  }

  Widget _main() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _nameField(),
            _adressField(),
            _postalcodeField(),
            _birthdayField(),
            _emailField(),
            _mobilenumberField(),
            _sendButton(context),
          ],
        ));
  }

  //Datepicker dialog
  Future<Null> _selectDate(BuildContext context) async {
    var picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime(DateTime.now().year + 1),
        initialDatePickerMode: DatePickerMode.year);

    if (picked != null && picked != DateTime.now()) {
      _user.birthdate = picked;
      setState(() {
        _birtdateController.text = DateTimeHelpers.ddmmyyyy(picked);
      });
    }
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Navn"),
      validator: (String value) {
        if (value.isEmpty) return "Indtast dit navn";
      },
      keyboardType: TextInputType.text,
      maxLength: 30,
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
        _user.postalCode = int.parse(value.trim());
      },
    );
  }

  Widget _birthdayField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Fødselsdato",
        hintText: "Tryk på knappen og bruger kalenderen",
        suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate(context);
            }),
      ),
      controller: _birtdateController,
      validator: (String value) {
        if (value.isEmpty) return "Indtast fødselsdato";
        if (!DateTimeHelpers.isVvalidDateFormat(value)) return "Indtast fødselsdato i formatet dd-mm-yyyy"; 
      },
      keyboardType: TextInputType.datetime,
      maxLength: 10
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
        _user.phone = int.parse(value.trim());
      },
    );
  }

  Widget _sendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _formKey.currentState.reset();
            _birtdateController.text = "";
            EnrollmentFirestore.saveEnrollment(_user);
            SystemHelpers.hideKeyboardWithNoFocus(context);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Tak for din indmeldelse i Silkeborg Beachvolley. Fortsæt til info om indbetaling."),
            ));
          }
        },
        child: Text('Indsend formular'),
      ),
    );
  }
}
