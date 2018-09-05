import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/enrollment/enrollment_main.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/silkeborgBeachvolleyScaffold.dart';

class EnrollmentStepper extends StatefulWidget {
  static final routeName = "/enrollmentstepper";
  @override
  _EnrollmentStepperState createState() => _EnrollmentStepperState();
}

class _EnrollmentStepperState extends State<EnrollmentStepper> {
  int _currentStep = 0;
  final int _lastStep = 2;
  bool _formComplete = false;
  bool _step0Active = true;
  bool _step1Active = false;
  bool _step2Active = false;
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Indmeldelse",
      body: Container(
        child: Stepper(
          onStepCancel: () {
            _stepperOnCancel();
          },
          onStepContinue: () {
            _stepperOnContinue();
          },
          type: StepperType.horizontal,
          currentStep: _currentStep,
          steps: <Step>[
            Step(
                isActive: _step0Active,
                title: Text("Læs"),
                // subtitle: Text("Subtitle1"),
                content: Text("Text")
            ),
            Step(
                isActive: _step1Active,
                title: Text("Udfyld formular"),
                // subtitle: Text("Subtitle1"),
                content: Enrollment()
            ),
            Step(
                isActive: _step2Active,
                title: Text("Indbetaling"),
                // subtitle: Text("Subtitle1"),
                content: Text("Content"))
          ],
        ),
      ),
    );
  }

  void _stepperOnContinue() {
    if (_currentStep < _lastStep) {
      setState(() {
        _currentStep++;
        switch (_currentStep) {
          case 0:
            _step0Active = true;
            _step1Active = false;
            _step2Active = false;
            break;
          case 1:
            _step0Active = false;
            _step1Active = true;
            _step2Active = false;
            break;
          case 2:
            _step0Active = false;
            _step1Active = false;
            _step2Active = true;
            break;
        }
      });
    }
  }

  void _stepperOnCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        switch (_currentStep) {
          case 0:
            _step0Active = true;
            _step1Active = false;
            _step2Active = false;
            break;
          case 1:
            _step0Active = false;
            _step1Active = true;
            _step2Active = false;
            break;
          case 2:
            _step0Active = false;
            _step1Active = false;
            _step2Active = true;
            break;
        }
      });
    }
  }
}
