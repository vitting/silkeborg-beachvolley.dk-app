import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/form/enrollment_form.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class EnrollmentEdit extends StatelessWidget {
  final EnrollmentUserData item;
  const EnrollmentEdit(this.item);

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: FlutterI18n.translate(context, "enrollment.enrollmentEditMain.title"),
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: EnrollmentForm(
            item: item,
            onFormSaved: null,
          ),
        ),
      ),
    );
  }
}
