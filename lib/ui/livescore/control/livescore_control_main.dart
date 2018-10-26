import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/control/helpers/livescore_controls_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_board_widget.dart';
import 'package:vibrate/vibrate.dart';

class LivescoreControl extends StatefulWidget {
  final LivescoreData match;

  const LivescoreControl({Key key, this.match}) : super(key: key);
  @override
  _LivescoreControlState createState() => _LivescoreControlState();
}

class _LivescoreControlState extends State<LivescoreControl> {
  double _opacity = 0.0;
  CrossFadeState _fadeState = CrossFadeState.showFirst;
  FontWeight _fontWeightTeam1 = FontWeight.normal;
  FontWeight _fontWeightTeam2 = FontWeight.normal;
  Color _pointsBorderColorTeam1 = Colors.white;
  Color _pointsBorderColorTeam2 = Colors.white;
  int _currentSelectedTeam = 0;
  int _winnerTeam = 0;
  bool _showIsLiveIndicator = false;
  StreamController<String> _messageStreamController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    if (widget.match.active != null && widget.match.active == false) {
      _fadeState = CrossFadeState.showSecond;
    }

    if (widget.match.active != null && widget.match.active == true) {
      _opacity = 1.0;
      _setSelectedTeam(widget.match.activeTeam);
      _showIsLiveIndicator = true;
    }
  }

  @override
  void dispose() {
    _messageStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        showAppBar: true,
        title: "Silkeborg Beachvolley",
        body: Builder(
          builder: (BuildContext context) {
            return _main(context);
          },
        ));
  }

  Widget _main(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              LivescoreBoard(
                match: widget.match,
                showIsLiveIndicator: _showIsLiveIndicator,
                fontWeightTeam1: _fontWeightTeam1,
                fontWeightTeam2: _fontWeightTeam2,
                pointsBorderColorTeam1: _pointsBorderColorTeam1,
                pointsBorderColorTeam2: _pointsBorderColorTeam2,
                winnerTeam1: _winnerTeam == 1 ? true : false,
                winnerTeam2: _winnerTeam == 2 ? true : false,
                messageStream: _messageStreamController.stream,
                onLongPressPoints: (int team) {
                  if (widget.match.active == null) {
                    _onLongPressPointsMatchStart(context, team);
                  }

                  if (widget.match.active != null && widget.match.active) {
                    _onLongPressPointsActive(context, team);
                  }
                },
                onDoubleTapMessage: (bool value) {
                  if (Home.canVibrate) Vibrate.feedback(FeedbackType.success);
                  _setBoardMessage(0, 0);
                },
              ),
              AnimatedCrossFade(
                firstCurve: Curves.easeIn,
                secondCurve: Curves.easeIn,
                crossFadeState: _fadeState,
                duration: Duration(milliseconds: 400),
                firstChild: AnimatedOpacity(
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 400),
                  opacity: _opacity,
                  child: _controls(context),
                ),
                secondChild: _closeButton(context),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FlatButton.icon(
        textColor: Colors.blue,
        icon: Icon(FontAwesomeIcons.volleyballBall),
        label: Text("Luk"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _controls(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: _messageChooserButtons(context),
        ),
        LivescoreControls(
          onTapAddPoints: (int team) {
            _setPoint(LivescoreControlAction.add, team);
          },
          onTapRemovePoints: (int team) {
            _setPoint(LivescoreControlAction.remove, team);
          },
          onTapAddTimeouts: (int team) {
            _setTimeout(LivescoreControlAction.add, team);
          },
          onTapRemoveTimeouts: (int team) {
            _setTimeout(LivescoreControlAction.remove, team);
          },
        ),
      ],
    );
  }

  void _onLongPressPointsMatchStart(BuildContext context, int team) async {
    if (Home.canVibrate) Vibrate.feedback(FeedbackType.success);
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          "Start kampen og sæt Team $team som kamp startere",
          FontAwesomeIcons.volleyballBall,
          0)
    ]);

    if (result != null && result == 0) {
      ConfirmDialogAction action = await Dialogs.confirmMatchStart(context,
          "Vil du starte kampen?\nDet er Team $team som starter med serven.");
      if (action != null && action == ConfirmDialogAction.start) {
        setState(() {
          _opacity = 1.0;
          widget.match.markGameAsStarted(team);
          _setSelectedTeam(team);
          _showIsLiveIndicator = true;
        });
      }
    }
  }

  void _onLongPressPointsActive(BuildContext context, int team) async {
    if (Home.canVibrate) Vibrate.feedback(FeedbackType.success);
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem("Markere Team $team som Set vindere",
          FontAwesomeIcons.volleyballBall, 0),
      DialogsModalBottomSheetItem("Markere Team $team som Kamp vindere",
          FontAwesomeIcons.volleyballBall, 1)
    ]);

    if (result != null && result == 0) {
      _setWinner(context, team);
    }

    if (result != null && result == 1) {
      _matchWinner(team);
    }
  }

  void _setWinner(BuildContext context, int team) async {
    ConfirmDialogAction action = await Dialogs.confirmSetWinner(
        context, "Vil du markere Team $team som Set vindere?");
    if (action != null && action == ConfirmDialogAction.ok) {
      int pointsTeam1 = widget.match.pointsTeam1;
      int pointsTeam2 = widget.match.pointsTeam2;
      int timeoutsTeam1 = widget.match.timeoutsTeam1;
      int timeoutsTeam2 = widget.match.timeoutsTeam2;
      int lastSelectedTeam = _currentSelectedTeam;
      await widget.match.addSet(team);
      await widget.match.setPointsAndTimeouts(0, 0, 0, 0);

      setState(() {
        _setSelectedTeam(0);
      });

      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 3000),
        content: Text("Vil du fortryde set vindere?"),
        action: SnackBarAction(
          label: "Fortryd",
          onPressed: () async {
            await widget.match.subtractSet(team);
            await widget.match.setPointsAndTimeouts(
                pointsTeam1, pointsTeam2, timeoutsTeam1, timeoutsTeam2);

            setState(() {
              _setSelectedTeam(lastSelectedTeam);
            });
          },
        ),
      ));
    }
  }

  void _matchWinner(int team) async {
    ConfirmDialogAction action = await Dialogs.confirmMatchWinner(
        context, "Vil du markere Team $team som Kamp vindere?");
    if (action != null && action == ConfirmDialogAction.ok) {
      await widget.match.addSet(team);
      await widget.match.markGameAsWon(team);

      setState(() {
        _setSelectedTeam(0);
        _fadeState = CrossFadeState.showSecond;
        _winnerTeam = team;
        _showIsLiveIndicator = false;
      });
    }
  }

  void _setPoint(LivescoreControlAction action, int team) {
    if (Home.canVibrate) Vibrate.feedback(FeedbackType.success);
    setState(() {
      if (action == LivescoreControlAction.add) {
        _setSelectedTeam(team);
        widget.match.addPoints(team);
      }

      if (action == LivescoreControlAction.remove)
        widget.match.subtractPoints(team);
    });
  }

  void _setTimeout(LivescoreControlAction action, int team) {
    if (Home.canVibrate) Vibrate.feedback(FeedbackType.success);
    setState(() {
      if (action == LivescoreControlAction.add) widget.match.addTimeouts(team);
      if (action == LivescoreControlAction.remove)
        widget.match.subtractTimeouts(team);
    });
  }

  void _setSelectedTeam(int team) {
    _currentSelectedTeam = team;
    switch (team) {
      case 0:
        _fontWeightTeam1 = FontWeight.normal;
        _fontWeightTeam2 = FontWeight.normal;
        _pointsBorderColorTeam1 = Colors.white;
        _pointsBorderColorTeam2 = Colors.white;
        break;
      case 1:
        _fontWeightTeam1 = FontWeight.bold;
        _fontWeightTeam2 = FontWeight.normal;
        _pointsBorderColorTeam1 = Colors.blue;
        _pointsBorderColorTeam2 = Colors.white;
        break;
      case 2:
        _fontWeightTeam1 = FontWeight.normal;
        _fontWeightTeam2 = FontWeight.bold;
        _pointsBorderColorTeam1 = Colors.white;
        _pointsBorderColorTeam2 = Colors.blue;
        break;
    }
  }

  Widget _messageChooserButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onLongPress: () {
              _messageChooser(context, 1);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.clipboardList, color: Colors.blue[700]),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child:
                      Text("Team 1", style: TextStyle(color: Colors.blue[700])),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onLongPress: () {
              _messageChooser(context, 2);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.clipboardList, color: Colors.blue[700]),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child:
                      Text("Team 2", style: TextStyle(color: Colors.blue[700])),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _messageChooser(BuildContext context, int team) async {
    if (Home.canVibrate) Vibrate.feedback(FeedbackType.success);
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem("Skjul beskeder", Icons.visibility_off, 0),
      DialogsModalBottomSheetItem(
          "Teknisk timeout", FontAwesomeIcons.clipboardList, 1),
      DialogsModalBottomSheetItem(
          "Team $team har taget timeout", FontAwesomeIcons.clipboardList, 2),
      DialogsModalBottomSheetItem(
          "Team $team vandt sættet", FontAwesomeIcons.clipboardList, 3),
      DialogsModalBottomSheetItem(
          "Team $team vandt kampen", FontAwesomeIcons.clipboardList, 4),
      DialogsModalBottomSheetItem(
          "Kampen er afsluttet", FontAwesomeIcons.clipboardList, 5),
      DialogsModalBottomSheetItem(
          "Skades pause til Team $team", FontAwesomeIcons.clipboardList, 6)
    ]);

    if (result != null) {
      _setBoardMessage(result, team);
    }
  }

  void _setBoardMessage(int messageNumber, int team) {
    String message = "";
    if (messageNumber != 0) {
      message = FlutterI18n.translate(context, "boardMessages.$messageNumber");
      message = message.replaceAll("[TEAM]", team.toString());
    }

    widget.match.setMatchMessage(messageNumber);
    _messageStreamController.add(message);
  }
}
