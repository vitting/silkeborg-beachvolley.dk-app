import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/dot_bottombar.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/silkeborgBeachvolleyScaffold.dart';

class EnrollmentStepper extends StatefulWidget {
  static final routeName = "/enrollmentstepper";
  @override
  _EnrollmentStepperState createState() => _EnrollmentStepperState();
}

class _EnrollmentStepperState extends State<EnrollmentStepper> {
  PageController _controller = PageController();
  int _position = 0;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      bottomNavigationBar: DotBottomBar(
        showNavigationButtons: true,
        numberOfDot: 3,
        position: _position,
        onPressed: _onNavigationButtonsPressed,
      ),
      title: "Indmeldelse",
      body: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
                  child: PageView(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              _enrollmentReadme(),
              Enrollment(),
              _enrollmentPayment()
            ],
          ),
        )
      ),
    );
  }

  Widget _enrollmentReadme() {
    return Container(
      child: ChoiceChip(
        avatar: Icon(FontAwesomeIcons.solidCircle),
        onSelected: (value) {},
        clipBehavior: Clip.hardEdge,
        selected: true,
        label: Text("En masse tekst om indmeldelse i Silkeborg Beachvolley"),
      )
    );
  }

  Widget _enrollmentPayment() {
    return Text("En masse tekst om betaling i Silkeborg Beachvolley");
  }

  _onNavigationButtonsPressed(DotBottomBarButton buttonPressed) {
    int position = _position;
    Duration pageDuration = Duration(milliseconds: 400);
    Curve pageCurve = Curves.easeIn;
    if (buttonPressed == DotBottomBarButton.right) {
      position++;

      _controller.nextPage(
        curve: pageCurve,
        duration: pageDuration
      );
    } 

    if (buttonPressed == DotBottomBarButton.left) {
      position--;

      _controller.previousPage(
        curve: pageCurve,
        duration: pageDuration
      );
    }

    setState(() {
      _position = position;
    });
  }
}
