import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/form/enrollment_form.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class EnrollmentEdit extends StatelessWidget {
  final EnrollmentUserData item;
  EnrollmentEdit(this.item);

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Redgier medlem",
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: EnrollmentForm(
            item: item,
            saved: null,
          ),
        ),
      ),
    );
  }
}
