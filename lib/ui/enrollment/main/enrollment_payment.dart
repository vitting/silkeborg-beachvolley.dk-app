import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                _textEnrollment("Tak for din indmeldelse", 16.0),
                _textEnrollment("og velkommen til", 16.0),
                _textEnrollment("Silkeborg Beachvolley", 16.0),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _textEnrollment("Færdiggøre din indmeldelse ved at"),
                ),
                _textEnrollment("overføre 25 kr. i MobilePay"),
                _textEnrollment("til nummer: 18185"),
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
                _textEnrollment("Du kan trykke på MobilePay logoet"),
                _textEnrollment("for at åbne din MobilePay app"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: _textEnrollment(
                      "Gå til forsiden hvis der er flere du vil melde ind i Silkeborg Beachvolley"),
                ),
                IconButton(
                  iconSize: 45.0,
                  onPressed: () {
                    onTapPreviousPage(true);
                  },
                  color: Colors.deepOrange[700],
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