import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

class EnrollmentReadMe extends StatelessWidget {
  final ValueChanged<bool> onTapNextPage;

  const EnrollmentReadMe({Key key, this.onTapNextPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentReadMe.string1"), 16.0),
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentReadMe.string2"), 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Image.asset("assets/images/logo_dark_blue_250x250.png",
                      width: 60.0),
                ),
                _textEnrollment(
                    FlutterI18n.translate(context, "enrollment.enrollmentReadMe.string3")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/mobilepay_horisontal_blue.png",
                          height: 50.0),
                      _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentReadMe.string4"))
                    ],
                  ),
                ),
                _textEnrollment(
                    FlutterI18n.translate(context, "enrollment.enrollmentReadMe.string5")),
                IconButton(
                  padding: EdgeInsets.only(top: 40.0),
                  color: SilkeborgBeachvolleyTheme.buttonTextColor,
                  icon: Icon(
                    FontAwesomeIcons.arrowAltCircleRight,
                    size: 45.0,
                  ),
                  onPressed: () {
                    onTapNextPage(true);
                  },
                )
              ],
            )
          ],
        ));
  }

  Text _textEnrollment(String text, [double fontSize = 14.0]) {
    return Text(text,
        textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize));
  }
}