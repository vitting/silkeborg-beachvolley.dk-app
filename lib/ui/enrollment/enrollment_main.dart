import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_made_by_user.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/form/enrollment_form.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:silkeborgbeachvolley/helpers/dot_bottombar.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/silkeborgBeachvolleyScaffold.dart';

class Enrollment extends StatefulWidget {
  static final routeName = "/enrollmentstepper";
  @override
  _EnrollmentStepperState createState() => _EnrollmentStepperState();
}

class _EnrollmentStepperState extends State<Enrollment> {
  PageController _controller = PageController();
  int _position = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      actions: <Widget>[_actionMenu(context)],
      bottomNavigationBar: DotBottomBar(
          showNavigationButtons: false, numberOfDot: 3, position: _position),
      title: "Indmeldelse",
      body: Card(
          child: Container(
        padding: EdgeInsets.all(10.0),
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _enrollmentReadme(),
            EnrollmentForm(
              saved: _formSaved,
            ),
            _enrollmentPayment()
          ],
        ),
      )),
    );
  }

  Widget _actionMenu(BuildContext context) {
    Widget menu;

    if (Home.loggedInUser != null) {
      menu = PopupMenuButton<int>(
        onSelected: (int value) {
          if (value == 0)
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => EnrollmentMadeByUser()));
        },
        initialValue: 0,
        icon: Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              value: 0,
              child: Text("Vis mine indmeldelser"),
            )
          ];
        },
      );
    }

    return menu;
  }

  _formSaved(bool value) {
    _controller.nextPage(
        curve: Curves.easeIn, duration: Duration(milliseconds: 400));

    if (mounted) {
      setState(() {
        _position = 2;
      });
    }
  }

  Widget _enrollmentReadme() {
    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                _textEnrollment("Velkommen til indmeldelse i"),
                _textEnrollment("Silkeborg Beachvolley"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset("assets/images/logo_dark_blue_250x250.png",
                      width: 80.0),
                ),
                _textEnrollment(
                    "Det koster kun 25 kr. pr. sæson at være medlem af Silkeborg Beachvolley"),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: _textEnrollment("Beløbet indbetales på MobilePay"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/mobilepay_horisontal_blue.png",
                          height: 50.0),
                      _textEnrollment("18185")
                    ],
                  ),
                ),
                _textEnrollment(
                    "Udfyld formularen på næste side for den du vil melde ind i Silkeborg Beachvolley"),
                IconButton(
                  padding: EdgeInsets.only(top: 40.0),
                  color: Colors.deepOrange[700],
                  icon: Icon(
                    FontAwesomeIcons.arrowAltCircleRight,
                    size: 45.0,
                  ),
                  onPressed: () {
                    _controller.nextPage(
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 400));

                    if (mounted) {
                      setState(() {
                        _position = 1;
                      });
                    }
                  },
                )
              ],
            )
          ],
        ));
  }

  Widget _enrollmentPayment() {
    String url =
        "https://www.mobilepay.dk/erhverv/betalingslink/betalingslink-svar?phone=18185&amount=25&comment=Kontigent%20-%20";

    return Container(
        padding: EdgeInsets.only(top: 20.0),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _textEnrollment(
                      "Tak for din indmeldese i Silkeborg Beachvolley"),
                ),
                Image.asset("assets/images/logo_dark_blue_250x250.png",
                    width: 40.0),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _textEnrollment("Færdiggøre din indmeldelse ved at"),
                ),
                _textEnrollment("overføre 25 kr. i MobilePay"),
                _textEnrollment("til nummer: 18185"),
                GestureDetector(
                  onTap: () async {
                    _launchUrl(url);
                  },
                  child: Image.asset(
                      "assets/images/mobilepay_vertical_blue.png",
                      height: 100.0),
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
                    _controller.animateToPage(0,
                        curve: Curves.easeIn,
                        duration: Duration(milliseconds: 400));
                    if (mounted) {
                      setState(() {
                        _position = 0;
                      });
                    }
                  },
                  color: Colors.deepOrange[700],
                  icon: Icon(FontAwesomeIcons.home),
                )
              ],
            ),
          ],
        ));
  }

  Text _textEnrollment(String text) {
    return Text(text,
        textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0));
  }

  void _launchUrl(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch url: $url");
    }
  }
}
