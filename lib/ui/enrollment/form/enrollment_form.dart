import 'dart:async';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/postcal_codes_data.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:validate/validate.dart';
import './enrollment_form_functions.dart' as formFunctions;

class EnrollmentForm extends StatefulWidget {
  final ValueChanged<bool> onFormSaved;
  final EnrollmentUserData item;
  const EnrollmentForm({@required this.onFormSaved, this.item});
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
  bool _showSaving = false;
  String _saveButtonText;
  @override
  void initState() {
    _postalCodeController.addListener(_getCity);

    /// Form is in Edit current item mode
    if (widget.item != null) {
      _checkIfMemberExists = false;
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
    if (widget.item != null) {
      _saveButtonText =
          FlutterI18n.translate(context, "enrollment.enrollmentForm.string2");
    } else {
      _saveButtonText =
          FlutterI18n.translate(context, "enrollment.enrollmentForm.string1");
    }
    return LoaderSpinnerOverlay(
      show: _showSaving,
      text: FlutterI18n.translate(context, "enrollment.enrollmentForm.string20"),
      child: _main(context),
    );
  }

  Widget _main(BuildContext context) {
    return ListView(
      children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _nameField(context),
                _adressField(context),
                _postalcodeField(context),
                _city(context),
                _birthdayField(context),
                _emailField(context),
                _mobilenumberField(context),
                _saveButton(context),
              ],
            ))
      ],
    );
  }

  Widget _nameField(BuildContext context) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string3")),
      validator: (String value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string4");
      },
      keyboardType: TextInputType.text,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      onSaved: (String value) {
        _user.name = value.trim();
      },
    );
  }

  Widget _adressField(BuildContext context) {
    return TextFormField(
      controller: _adressController,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string5")),
      validator: (String value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string6");
      },
      keyboardType: TextInputType.text,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      onSaved: (String value) {
        _user.street = value.trim();
      },
    );
  }

  Widget _postalcodeField(BuildContext context) {
    return TextFormField(
      controller: _postalCodeController,
      decoration: InputDecoration(
        labelText:
            FlutterI18n.translate(context, "enrollment.enrollmentForm.string7"),
      ),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value.trim()) == null)
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string8");
        if (!_isPostalCodeValid)
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string9");
      },
      keyboardType: TextInputType.number,
      inputFormatters: [LengthLimitingTextInputFormatter(4)],
      onSaved: (String value) {
        _user.postalCode = int.parse(value.trim());
      },
    );
  }

  Widget _city(BuildContext context) {
    return TextFormField(
        enabled: false,
        controller: _cityController,
        decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string10"),
        ),
        onSaved: (String value) {
          _user.city = value;
        });
  }

  Widget _birthdayField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: FlutterI18n.translate(
            context, "enrollment.enrollmentForm.string11"),
        hintText: FlutterI18n.translate(
            context, "enrollment.enrollmentForm.string12"),
        suffixIcon: IconButton(
            color: SilkeborgBeachvolleyTheme.buttonTextColor,
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              _selectDate(context, date: _user.birthdate);
            }),
      ),
      controller: _birtdateController,
      validator: (String value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string13");
        if (!DateTimeHelpers.isVvalidDateFormat(value))
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string14");
      },
      keyboardType: TextInputType.datetime,
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
    );
  }

  Widget _emailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string15")),
      validator: (String value) {
        if (value.isEmpty)
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string16");
        try {
          Validate.isEmail(value.trim());
        } catch (e) {
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string17");
        }
      },
      keyboardType: TextInputType.emailAddress,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      onSaved: (String value) {
        _user.email = value.trim();
      },
    );
  }

  Widget _mobilenumberField(BuildContext context) {
    return TextFormField(
      controller: _mobilenumberController,
      decoration: InputDecoration(
          labelText: FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string18")),
      validator: (String value) {
        if (value.isEmpty || int.tryParse(value.trim()) == null)
          return FlutterI18n.translate(
              context, "enrollment.enrollmentForm.string19");
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
        textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
        icon: Icon(Icons.check_circle),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              _showSaving = true;              
            });
            _formKey.currentState.save();

            if (_checkIfMemberExists && !await formFunctions.checkIfMemberExistsAndSave(context, _user)) {
              setState(() {
                _showSaving = false;              
              });
              return null;
            }
              

            SystemHelpers.hideKeyboardWithNoFocus(context);
            
            await _user.save(MainInherited.of(context).loggedInUser.uid);
            setState(() {
              _showSaving = false;              
            });
            if (widget.onFormSaved != null) {
              widget.onFormSaved(true);
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
