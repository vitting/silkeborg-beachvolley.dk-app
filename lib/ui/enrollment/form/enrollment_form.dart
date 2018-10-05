import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/postcal_codes_data.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers_class.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:validate/validate.dart';
import './enrollment_form_functions.dart' as formFunctions;

class EnrollmentForm extends StatefulWidget {
  final ValueChanged<bool> saved;
  final EnrollmentUserData item;
  EnrollmentForm({@required this.saved, this.item});
  @override
  _EnrollmentFormState createState() => _EnrollmentFormState();
}

class _EnrollmentFormState extends State<EnrollmentForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _birtdateController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilenumberController = TextEditingController();
  EnrollmentUserData _user = new EnrollmentUserData();
  final _formKey = GlobalKey<FormState>();
  bool _isPostalCodeValid = false;
  bool _checkIfMemberExists = true;
  String _saveButtonText = "Indsend formular";
  @override
  void initState() {
    _postalCodeController.addListener(_getCity);

    /// Form is in Edit current item mode
    if (widget.item != null) {
      _checkIfMemberExists = false;
      _saveButtonText = "Opdater";
      _user = widget.item;
      _nameController.text = _user.name;
      _adressController.text = _user.street;
      _postalCodeController.text = _user.postalCode.toString();
      _emailController.text = _user.email;
      _mobilenumberController.text = _user.phone.toString();
      _birtdateController.text = DateTimeHelpers.ddmmyyyy(_user.birthdate);
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _adressController.dispose();
    _birtdateController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _mobilenumberController.dispose();
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

  Widget _nameField() {
    return TextFormField(
      controller: _nameController,
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
      controller: _adressController,
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
        if (value.isEmpty || int.tryParse(value.trim()) == null)
          return "Indtast dit postnummer";
        if (!_isPostalCodeValid)
          return "Det indtastede postnummer existere ikke";
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
        });
  }

  Widget _birthdayField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Fødselsdato",
        hintText: "Tryk på knappen og bruger kalenderen",
        suffixIcon: IconButton(
          color: Colors.deepOrange[700],
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              _selectDate(context, date: _user.birthdate);
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
      controller: _emailController,
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
      controller: _mobilenumberController,
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
        textColor: Colors.deepOrange[700],
        icon: Icon(Icons.check_circle),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            if (_checkIfMemberExists &&
                !await formFunctions.checkIfMemberExistsAndSave(context, _user))
              return;

            SystemHelpers.hideKeyboardWithNoFocus(context);

            await _user.save();

            if (widget.saved != null) {
              widget.saved(true);
            } else {
              Navigator.of(context).pop();
            }
          }
        },
        label: Text(_saveButtonText),
      ),
    );
  }

  Future<void> _getCity() async {
    _isPostalCodeValid = false;
    if (_postalCodeController.text.length == 4) {
      int postalCode = int.tryParse(_postalCodeController.text);
      if (postalCode != null) {
        _cityController.text = await PostalCode.getCity(postalCode);
        _isPostalCodeValid = true;
      }
    }
  }

  //Datepicker dialog
  Future<Null> _selectDate(BuildContext context, {DateTime date}) async {
    DateTime picked = await formFunctions.selectDate(context, date);

    if (picked != null && picked != DateTime.now()) {
      _user.birthdate = picked;
      setState(() {
        _birtdateController.text = DateTimeHelpers.ddmmyyyy(picked);
      });
    }
  }
}
