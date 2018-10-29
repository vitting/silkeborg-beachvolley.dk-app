import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';

class EnrollmentPayment extends StatelessWidget {
  final ValueChanged<bool> onTapPreviousPage;
  final ValueChanged<bool> onTapMobilePayUrl;

  const EnrollmentPayment({Key key, this.onTapPreviousPage, this.onTapMobilePayUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string1"), 16.0),
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string2"), 16.0),
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string3"), 16.0),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string4")),
                ),
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string5")),
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string6")),
                InkWell(
                  onTap: () async {
                    onTapMobilePayUrl(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.asset(
                        "assets/images/mobilepay_vertical_blue.png",
                        height: 100.0),
                  ),
                ),
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string7")),
                _textEnrollment(FlutterI18n.translate(context, "enrollment.enrollmentPayment.string8")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: _textEnrollment(
                      FlutterI18n.translate(context, "enrollment.enrollmentPayment.string9")),
                ),
                IconButton(
                  iconSize: 45.0,
                  onPressed: () {
                    onTapPreviousPage(true);
                  },
                  color: SilkeborgBeachvolleyTheme.buttonTextColor,
                  icon: Icon(FontAwesomeIcons.home),
                )
              ],
            ),
          ],
        ));
  }

  Text _textEnrollment(String text, [double fontSize = 14.0]) {
    return Text(text,
        textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize));
  }
}