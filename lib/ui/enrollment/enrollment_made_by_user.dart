import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/chip_header.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/helpers/loader_spinner.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/helpers/enrollment_user_data_class.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class EnrollmentMadeByUser extends StatefulWidget {
  @override
  EnrollmentMadeByUserState createState() {
    return new EnrollmentMadeByUserState();
  }
}

class EnrollmentMadeByUserState extends State<EnrollmentMadeByUser> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Mine indmeldser",
        body: FutureBuilder(
          future: EnrollmentUserData.getAllAddedByUser(),
          builder: (BuildContext context,
              AsyncSnapshot<List<EnrollmentUserData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) return LoaderSpinner();

            if (snapshot.data.length == 0) return Card(
              child: Center(
                child: ChipHeader("Der blev ikke fundet nogen indmeldelser!", fontSize: 15.0,),
              ),
            );

            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int position) {
                    EnrollmentUserData item = snapshot.data[position];
                    return Card(
                      child: ListTile(
                        title: ListBody(
                          children: <Widget>[
                            _row(
                                Icons.calendar_today,
                                DateTimeHelpers.ddmmyyyyHHnn(item.creationDate),
                                "Oprettelses dato"),
                            _row(Icons.person, item.name, "Navn"),
                            _row(
                                Icons.location_city,
                                "${item.street}, ${item.postalCode}",
                                "Adresse"),
                            _row(Icons.email, item.email, "E-mail"),
                            _row(Icons.phone, item.phone.toString(),
                                "Telefonnummer"),
                            _row(
                                Icons.cake,
                                DateTimeHelpers.ddmmyyyy(item.birthdate),
                                "Fødselsdato"),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          },
        ));
  }

  Widget _row(IconData icon, String text, String tooltip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Tooltip(
        message: tooltip,
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
      ),
    );
  }
}
