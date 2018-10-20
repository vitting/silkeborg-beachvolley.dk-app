import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/made_by_user/enrollment_made_by_user_main.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/form/enrollment_form.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/main/enrollment_payment.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/main/enrollment_readme.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/silkeborgBeachvolleyScaffold.dart';

class Enrollment extends StatefulWidget {
  static final routeName = "/enrollmentstepper";
  @override
  _EnrollmentState createState() => _EnrollmentState();
}

class _EnrollmentState extends State<Enrollment> {
  final PageController _controller = PageController();
  final String _mobilePayUrl =
      "https://www.mobilepay.dk/erhverv/betalingslink/betalingslink-svar?phone=18185&amount=25&comment=Kontigent%20-%20";
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
            EnrollmentReadMe(
              onTapNextPage: (bool value) {
                _controller.nextPage(
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 400));

                setState(() {
                  _position = 1;
                });
              },
            ),
            EnrollmentForm(
              onFormSaved: (bool value) {
                _controller.nextPage(
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 400));
                setState(() {
                  _position = 2;
                });
              },
            ),
            EnrollmentPayment(
              onTapPreviousPage: (bool value) {
                _controller.animateToPage(0,
                    curve: Curves.easeIn,
                    duration: Duration(milliseconds: 400));

                setState(() {
                  _position = 0;
                });
              },
              onTapMobilePayUrl: (bool value) {
                _launchUrl(_mobilePayUrl);
              },
            )
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

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not launch url: $url");
    }
  }
}
