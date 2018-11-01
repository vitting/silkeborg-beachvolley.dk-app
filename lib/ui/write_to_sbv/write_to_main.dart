import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:validate/validate.dart';

class WriteTo extends StatelessWidget {
  static final String routeName = "/writeto";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Skriv til os",
      body: Card(
        child: Form(
          key: _formKey,
          child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Navn"
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onSaved: (String value) {

              },
              validator: (String value) {
                if (value.isEmpty) return "Udfyld navn";
              }, 
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "E-mail"
              ),
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSaved: (String value) {

              },
              validator: (String value) {
                if (value.isEmpty) return "Udfyld e-mail";
                try {
                  Validate.isEmail(value.trim());
                } catch (e) {
                  return "E-mail er ikke valid";
                }
              }, 
            ),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Din besked"
              ),
              maxLength: 500,
              onSaved: (String value) {

              },
              validator: (String value) {
                if (value.isEmpty) return "Udfyld besked";
              }, 
            ),
            FlatButton.icon(
              icon: Icon(Icons.send),
              label: Text("Send besked"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                }
              },
            )
          ],
        ),
        )
      ),
      
    );
  }
}