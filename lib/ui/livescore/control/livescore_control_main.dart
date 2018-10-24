import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
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
  bool _canVibrate = false;
  double _opacity = 0.0;
  CrossFadeState _fadeState = CrossFadeState.showFirst;
  FontWeight _fontWeightTeam1 = FontWeight.normal;
  FontWeight _fontWeightTeam2 = FontWeight.normal;
  Color _pointsBorderColorTeam1 = Colors.white;
  Color _pointsBorderColorTeam2 = Colors.white;

  @override
  void initState() {
    super.initState();
    _init();

    if (widget.match.active != null && widget.match.active == false) {
      _fadeState = CrossFadeState.showSecond;
    }
  }

  void _init() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
    });
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
                fontWeightTeam1: _fontWeightTeam1,
                fontWeightTeam2: _fontWeightTeam2,
                pointsBorderColorTeam1: _pointsBorderColorTeam1,
                pointsBorderColorTeam2: _pointsBorderColorTeam2,
                onLongPressPoints: (int team) {
                  if (widget.match.active == null) {
                    _onLongPressPointsMatchStart(context, team);
                  }

                  if (widget.match.active != null && widget.match.active) {
                    _onLongPressPointsActive(context, team);
                  }
                },
              ),
              AnimatedCrossFade(
                crossFadeState: _fadeState,
                duration: Duration(milliseconds: 400),
                firstChild: AnimatedOpacity(
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
    return LivescoreControls(
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
    );
  }

  void _onLongPressPointsMatchStart(BuildContext context, int team) async {
    if (_canVibrate) Vibrate.feedback(FeedbackType.success);
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
          widget.match.markGameAsStarted();
          _setSelectedTeam(team);
        });
      }
    }
  }

  void _onLongPressPointsActive(BuildContext context, int team) async {
    if (_canVibrate) Vibrate.feedback(FeedbackType.success);
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem("Markere Team $team som Set vindere",
          FontAwesomeIcons.volleyballBall, 0),
      DialogsModalBottomSheetItem("Markere Team $team som Kamp vindere",
          FontAwesomeIcons.volleyballBall, 1)
    ]);

    if (result != null && result == 0) {
      ConfirmDialogAction action = await Dialogs.confirmSetWinner(
          context, "Vil du markere Team $team som Set vindere?");
      if (action != null && action == ConfirmDialogAction.ok) {
        int pointsTeam1 = widget.match.pointsTeam1;
        int pointsTeam2 = widget.match.pointsTeam2;
        int timeoutsTeam1 = widget.match.timeoutsTeam1;
        int timeoutsTeam2 = widget.match.timeoutsTeam2;
        await widget.match.addSet(team);
        await widget.match.setPointsAndTimeouts(0, 0, 0, 0);

        setState(() {});

        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 3000),
          content: Text("Vil du fortryde set vindere?"),
          action: SnackBarAction(
            label: "Fortryd",
            onPressed: () async {
              await widget.match.subtractSet(team);
              await widget.match.setPointsAndTimeouts(
                  pointsTeam1, pointsTeam2, timeoutsTeam1, timeoutsTeam2);

              setState(() {});
            },
          ),
        ));
      }
    }

    if (result != null && result == 1) {
      ConfirmDialogAction action = await Dialogs.confirmMatchWinner(
          context, "Vil du markere Team $team som Kamp vindere?");
      if (action != null && action == ConfirmDialogAction.ok) {
        await widget.match.addSet(team);
        await widget.match.markGameAsWon(team);

        setState(() {
          _fadeState = CrossFadeState.showSecond;
        });
      }
    }
  }

  void _setPoint(LivescoreControlAction action, int team) {
    if (_canVibrate) Vibrate.feedback(FeedbackType.success);
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
    if (_canVibrate) Vibrate.feedback(FeedbackType.success);
    setState(() {
      if (action == LivescoreControlAction.add) widget.match.addTimeouts(team);
      if (action == LivescoreControlAction.remove)
        widget.match.subtractTimeouts(team);
    });
  }

  void _setSelectedTeam(int team) {
    if (team == 1) {
      _fontWeightTeam1 = FontWeight.bold;
      _fontWeightTeam2 = FontWeight.normal;
      _pointsBorderColorTeam1 = Colors.blue;
      _pointsBorderColorTeam2 = Colors.white;
    } else {
      _fontWeightTeam1 = FontWeight.normal;
      _fontWeightTeam2 = FontWeight.bold;
      _pointsBorderColorTeam1 = Colors.white;
      _pointsBorderColorTeam2 = Colors.blue;
    }
  }
}
