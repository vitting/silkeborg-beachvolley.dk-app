import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/confirm_dialog_action_enum.dart';
import 'package:silkeborgbeachvolley/helpers/dialogs_class.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/control/helpers/livescore_controls_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/livescore/board/livescore_board_widget.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init(context);
  }

  @override
  void dispose() {
    SystemHelpers.setScreenOff();
    _messageStreamController.close();
    super.dispose();
  }

  void _init(BuildContext context) {
    MainInherited.of(context).settings.livescoreControlBoardKeepScreenOn
        ? SystemHelpers.setScreenOn()
        : SystemHelpers.setScreenOff();

    if (widget.match.active != null && widget.match.active == false) {
      _fadeState = CrossFadeState.showSecond;
    }

    if (widget.match.active != null && widget.match.active == true) {
      _opacity = 1.0;
      _setSelectedTeam(widget.match.activeTeam);
      _setBoardMessage(
          widget.match.matchMessage, widget.match.matchMessageTeam, true);
      _showIsLiveIndicator = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        showAppBar: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showInfoDialog(context);
            },
            icon: Icon(Icons.info_outline),
          )
        ],
        title: FlutterI18n.translate(
            context, "livescore.livescoreControlMain.title"),
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
                  if (MainInherited.of(context).canVibrate)
                    Vibrate.feedback(FeedbackType.success);
                  _setBoardMessage(0, 0, false);
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
        label: Text(FlutterI18n.translate(
            context, "livescore.livescoreControlMain.string1")),
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
    if (MainInherited.of(context).canVibrate)
      Vibrate.feedback(FeedbackType.success);
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(
                  context, "livescore.livescoreControlMain.string2")
              .replaceAll("[TEAM]", team.toString()),
          FontAwesomeIcons.volleyballBall,
          0)
    ]);

    if (result != null && result == 0) {
      ConfirmDialogAction action = await Dialogs.confirmMatchStart(
          context,
          FlutterI18n.translate(
                  context, "livescore.livescoreControlMain.string3")
              .replaceAll("[TEAM]", team.toString()));
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
    if (MainInherited.of(context).canVibrate)
      Vibrate.feedback(FeedbackType.success);
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(
                  context, "livescore.livescoreControlMain.string4")
              .replaceAll("[TEAM]", team.toString()),
          FontAwesomeIcons.volleyballBall,
          0),
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(
                  context, "livescore.livescoreControlMain.string5")
              .replaceAll("[TEAM]", team.toString()),
          FontAwesomeIcons.volleyballBall,
          1)
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
        context,
        FlutterI18n.translate(context, "livescore.livescoreControlMain.string6")
            .replaceAll("[TEAM]", team.toString()));
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
        content: Text(FlutterI18n.translate(
            context, "livescore.livescoreControlMain.string7")),
        action: SnackBarAction(
          label: FlutterI18n.translate(
              context, "livescore.livescoreControlMain.string8"),
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
        context,
        FlutterI18n.translate(context, "livescore.livescoreControlMain.string9")
            .replaceAll("[TEAM]", team.toString()));
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
    if (MainInherited.of(context).canVibrate)
      Vibrate.feedback(FeedbackType.success);
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
    if (MainInherited.of(context).canVibrate)
      Vibrate.feedback(FeedbackType.success);
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
        _pointsBorderColorTeam1 = Colors.white54;
        _pointsBorderColorTeam2 = Colors.white54;
        break;
      case 1:
        _fontWeightTeam1 = FontWeight.bold;
        _fontWeightTeam2 = FontWeight.normal;
        _pointsBorderColorTeam1 = Colors.white;
        _pointsBorderColorTeam2 = Colors.white54;
        break;
      case 2:
        _fontWeightTeam1 = FontWeight.normal;
        _fontWeightTeam2 = FontWeight.bold;
        _pointsBorderColorTeam1 = Colors.white54;
        _pointsBorderColorTeam2 = Colors.white;
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
                  child: Text(
                      FlutterI18n.translate(
                          context, "livescore.livescoreControlMain.string10"),
                      style: TextStyle(color: Colors.blue[700])),
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
                  child: Text(
                      FlutterI18n.translate(
                          context, "livescore.livescoreControlMain.string11"),
                      style: TextStyle(color: Colors.blue[700])),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _messageChooser(BuildContext context, int team) async {
    if (MainInherited.of(context).canVibrate)
      Vibrate.feedback(FeedbackType.success);
    int result = await Dialogs.modalBottomSheet(context, [
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "livescore.boardMessages.0"),
          Icons.visibility_off,
          0),
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "livescore.boardMessages.1"),
          FontAwesomeIcons.clipboardList,
          1),
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "livescore.boardMessages.2")
              .replaceAll("[TEAM]", team.toString()),
          FontAwesomeIcons.clipboardList,
          2),
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "livescore.boardMessages.3")
              .replaceAll("[TEAM]", team.toString()),
          FontAwesomeIcons.clipboardList,
          3),
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "livescore.boardMessages.4")
              .replaceAll("[TEAM]", team.toString()),
          FontAwesomeIcons.clipboardList,
          4),
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "livescore.boardMessages.5"),
          FontAwesomeIcons.clipboardList,
          5),
      DialogsModalBottomSheetItem(
          FlutterI18n.translate(context, "livescore.boardMessages.6")
              .replaceAll("[TEAM]", team.toString()),
          FontAwesomeIcons.clipboardList,
          6)
    ]);

    if (result != null) {
      _setBoardMessage(result, team, false);
    }
  }

  void _setBoardMessage(int messageNumber, int team, bool readOnly) {
    String message = "";
    if (messageNumber != 0) {
      message = FlutterI18n.translate(
          context, "livescore.boardMessages.$messageNumber");
      message = message.replaceAll("[TEAM]", team.toString());
    }

    if (readOnly == false) {
      widget.match.setMatchMessage(messageNumber, team);
    }

    _messageStreamController.add(message);
  }

  void _showInfoDialog(BuildContext context) async {
    await showDialog<int>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext contextModal) => SimpleDialog(
              titlePadding:
                  EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0),
              contentPadding: EdgeInsets.all(10.0),
              title: Text(FlutterI18n.translate(
                  context, "livescore.livescoreControlMain.string12")),
              children: <Widget>[
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string13")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset("assets/images/livescore_01_800x266.png"),
                ),
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string14")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset("assets/images/livescore_02_800x137.png",
                      height: 25.0),
                ),
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string15")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset("assets/images/livescore_03_800x374.png"),
                ),
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string16")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset("assets/images/livescore_05_800x447.png",
                      height: 100.0),
                ),
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string17")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset("assets/images/livescore_06_800x87.png"),
                ),
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string18")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(FlutterI18n.translate(
                      context, "livescore.livescoreControlMain.string19")),
                ),
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string20")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(FlutterI18n.translate(
                      context, "livescore.livescoreControlMain.string21")),
                ),
                Text(FlutterI18n.translate(
                    context, "livescore.livescoreControlMain.string22")),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Image.asset("assets/images/livescore_04_800x237.png",
                      height: 60.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      textColor: SilkeborgBeachvolleyTheme.buttonTextColor,
                      child: Text(FlutterI18n.translate(
                          context, "livescore.livescoreControlMain.string23")),
                      onPressed: () {
                        Navigator.of(contextModal).pop();
                      },
                    )
                  ],
                )
              ],
            ));
  }
}
