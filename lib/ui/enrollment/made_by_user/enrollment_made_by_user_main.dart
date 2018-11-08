import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';
import 'package:silkeborgbeachvolley/helpers/datetime_helpers.dart';
import 'package:silkeborgbeachvolley/ui/helpers/list_item_card_widget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/edit/enrollment_edit_main.dart';
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
        title: FlutterI18n.translate(
            context, "enrollment.enrollmentMadeByUser.title"),
        body: FutureBuilder(
          future: EnrollmentUserData.getAllAddedByUser(
              MainInherited.of(context).loggedInUser.uid),
          builder: (BuildContext context,
              AsyncSnapshot<List<EnrollmentUserData>> snapshot) {
            if (snapshot.hasError) {
              print(
                  "ERROR enrollment_made_by_user FutureBuilder: ${snapshot.error}");
              return Container();
            }
            if (!snapshot.hasData) return LoaderSpinner();

            if (snapshot.hasData && snapshot.data.length == 0)
              return Card(
                child: Center(
                  child: ChipHeader(
                    FlutterI18n.translate(
                        context, "enrollment.enrollmentMadeByUser.string1"),
                    fontSize: 15.0,
                  ),
                ),
              );

            return Container(
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int position) {
                      EnrollmentUserData item = snapshot.data[position];
                      return ListItemCard(
                        child: ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            color: SilkeborgBeachvolleyTheme.buttonTextColor,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (BuildContext context) =>
                                      EnrollmentEdit(item)));
                            },
                          ),
                          title: ListBody(
                            children: <Widget>[
                              _row(
                                  Icons.calendar_today,
                                  DateTimeHelpers.ddmmyyyyHHnn(
                                      item.creationDate.toDate()),
                                  FlutterI18n.translate(context,
                                      "enrollment.enrollmentMadeByUser.string2")),
                              _row(
                                  Icons.person,
                                  item.name,
                                  FlutterI18n.translate(context,
                                      "enrollment.enrollmentMadeByUser.string3")),
                              _row(
                                  Icons.location_city,
                                  "${item.street}\n${item.postalCode} ${item.city}",
                                  FlutterI18n.translate(context,
                                      "enrollment.enrollmentMadeByUser.string4")),
                              _row(
                                  Icons.email,
                                  item.email,
                                  FlutterI18n.translate(context,
                                      "enrollment.enrollmentMadeByUser.string5")),
                              _row(
                                  Icons.phone,
                                  item.phone.toString(),
                                  FlutterI18n.translate(context,
                                      "enrollment.enrollmentMadeByUser.string6")),
                              _row(
                                  Icons.cake,
                                  DateTimeHelpers.ddmmyyyy(item.birthdate),
                                  FlutterI18n.translate(context,
                                      "enrollment.enrollmentMadeByUser.string7")),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
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
