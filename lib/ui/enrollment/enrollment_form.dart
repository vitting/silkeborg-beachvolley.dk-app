import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/postcal_codes_data.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers_class.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollmentExists.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:validate/validate.dart';
import "../../helpers/confirm_dialog_functions.dart" as confirmDialogFunctions;

class EnrollmentForm extends StatefulWidget {
  final ValueChanged<bool> saved;
  EnrollmentForm({@required this.saved});
  @override
  _EnrollmentFormState createState() => _EnrollmentFormState();
}

class _EnrollmentFormState extends State<EnrollmentForm> {
  final _birtdateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _user = new EnrollmentUserData();
  final _formKey = GlobalKey<FormState>();
  bool _isPostalCodeValid = false;

  
  @override
    void initState() {
      _postalCodeController.addListener(_getCity);
      super.initState();
    }

  @override
  void dispose() {
    _birtdateController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _main();
  }

  Widget _main() {
    return ListView(
      children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _nameField(),
                _adressField(),
                _postalcodeField(),
                _city(),
                _birthdayField(),
                _emailField(),
                _mobilenumberField(),
                _saveButton(context),
              ],
            ))
      ],
    );
  }

  Future<void> _getCity() async {
  _isPostalCodeValid = false;
  if (_postalCodeController.text.length == 4)  { 
    int postalCode = int.tryParse(_postalCodeController.text);
    if (postalCode != null) {
      _cityController.text = await PostalCode.getCity(postalCode);
      _isPostalCodeValid = true;
    }
  }
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
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      onSaved: (String value) {
        _user.street = value.trim();
      },
    );
  }

  Widget _postalcodeField() {
    return TextFormField(
      controller: _postalCodeController,
      decoration: InputDecoration(
        labelText: "Postnummer",
      ),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value.trim()) == null) return "Indtast dit postnummer";
        if (!_isPostalCodeValid) return "Det indtastede postnummer existere ikke";
      },
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(4)],
      onSaved: (String value) {
        _user.postalCode = int.parse(value.trim());
      },
    );
  }

  Widget _city() {
    return TextFormField( 
      enabled: false,
      controller: _cityController,
      decoration: InputDecoration(
        labelText: "By",
      ),
      onSaved: (String value) {
        _user.city = value;
      }
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
        if (!DateTimeHelpers.isVvalidDateFormat(value))
          return "Indtast fødselsdato i formatet dd-mm-yyyy";
      },
      keyboardType: TextInputType.datetime,
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
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
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
      inputFormatters: [LengthLimitingTextInputFormatter(8)],
      onSaved: (String value) {
        _user.phone = int.parse(value.trim());
      },
    );
  }

  Widget _saveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: FlatButton.icon(
        textColor: Colors.blue,
        icon: Icon(Icons.send, color: Colors.blue),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            if (await _checkIfMemberExistsAndSave(context)) {
              _formKey.currentState.reset();
              _birtdateController.text = "";
              SystemHelpers.hideKeyboardWithNoFocus(context);
              await _user.save();
              widget.saved(true);
            }
          }
        },
        label: Text('Indsend formular'),
      ),
    );
  }

  Future<bool> _checkIfMemberExistsAndSave(BuildContext context) async {
    bool value = true;
    if (Home.loggedInUser != null) {
      EnrollmentExists enrollmentExists = await _user.checkIfValuesExists();

      if (enrollmentExists.emailExists || enrollmentExists.phoneExists) {
        ConfirmDialogAction result = await confirmDialogFunctions.confirmDialog(
            context,
            title: Text("Info"),
            actionLeft: ConfirmDialogAction.no,
            actionRight: ConfirmDialogAction.yes,
            body: <Widget>[
              _getDialogText(enrollmentExists),
              Text("Vil du fortsætte med at oprette medlemmet?")
            ]);

        result == ConfirmDialogAction.yes ? value = true : value = false;
      }
    }

    return value;
  }

  Text _getDialogText(EnrollmentExists enrollmentExists) {
    String text =
        "Der er allerede oprettet [MEMBERCOUNT] [MEMBEREMAIL][MEMEBERAND][MEMBERPHONE].";
    text = enrollmentExists.emailCount > 1 || enrollmentExists.phoneCount > 1
        ? text.replaceFirst("[MEMBERCOUNT]", "flere medlemmer")
        : text.replaceFirst("[MEMBERCOUNT]", "et medlem");
    text = enrollmentExists.emailExists
        ? text.replaceFirst("[MEMBEREMAIL]", "under den angivne e-mail adresse")
        : text.replaceFirst("[MEMBEREMAIL]", "");
    text = enrollmentExists.emailExists && enrollmentExists.phoneExists
        ? text.replaceFirst("[MEMEBERAND]", " og ")
        : text.replaceFirst("[MEMEBERAND]", "");
    text = enrollmentExists.phoneExists
        ? text.replaceFirst("[MEMBERPHONE]", " under det angivne mobilnummer")
        : text.replaceFirst("[MEMBERPHONE]", "");

    return Text(text);
  }
}
