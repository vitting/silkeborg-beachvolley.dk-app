import "package:flutter/material.dart";
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:validate/validate.dart';

class UserCredentials {
  String email = "";
  String password = "";
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _userCredentials = new UserCredentials();

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Silkeborg Beachvolley",
      body: _main()
    );
  }

  Widget _main() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _emailField(), 
              _passwordField(), 
              _buttons()
          ],
          )),
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
      onSaved: (String value) {
        _userCredentials.email = value.trim();
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Kodeord",
          helperText:
              "Mindst 8 tegn skal indeholde et stort og lille bogstav og et tal"),
      validator: (String value) {
        if (value.isEmpty) return "Indtast dit kodeord";

        /*
                  8 characters. Letters and numbers. 
                  Minimum one lowercase letter and uppercase letter and number
                  */
        RegExp regex =
            new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})");
        if (!regex.hasMatch(value.trim())) return "Ikke valid kodeord";
      },
      keyboardType: TextInputType.text,
      obscureText: true,
      onSaved: (String value) {
        _userCredentials.password = value.trim();
      },
    );
  }

  Widget _buttons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _formKey.currentState.reset();
                }
              },
              child: Text('Login'),
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _formKey.currentState.reset();
                }
              },
              child: Text('Opret'),
            )
          ],
        ),
      ),
    );
  }
}
