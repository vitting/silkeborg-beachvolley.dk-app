import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_payment_data.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class EnrollmentDetail extends StatelessWidget {
  final EnrollmentUserData enrollment;

  const EnrollmentDetail({Key key, this.enrollment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Medlemsinfo",
      body: Card(
        child: ListView(
          children: <Widget>[
            Container(
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _row(FontAwesomeIcons.idCard, enrollment.id),
                    _row(
                        Icons.calendar_today,
                        DateTimeHelpers.ddmmyyyyHHnn(
                            enrollment.creationDate)),
                    _row(Icons.person, enrollment.name),
                    _row(Icons.location_city,
                        "${enrollment.street}\n${enrollment.postalCode} ${enrollment.city}"),
                    _row(Icons.email, enrollment.email),
                    _row(Icons.phone, enrollment.phone.toString()),
                    _row(Icons.cake,
                        "${DateTimeHelpers.ddmmyyyy(enrollment.birthdate)} / ${enrollment.age} år"),
                    _payments()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _payments() {
    List<Widget> widgets = enrollment.payment.map<Widget>((EnrollmentPaymentData data) {
      return Text("${DateTimeHelpers.ddmmyyyy(data.date)}");
    }).toList();
    return ListView(
      shrinkWrap: true,
      children: widgets,
    );
  }

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 18.0,
            color: Colors.blue[700],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(text),
            ),
          )
        ],
      ),
    );
  }
}
