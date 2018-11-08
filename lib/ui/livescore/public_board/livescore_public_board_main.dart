import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/system_helpers.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/board/livescore_board_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/helpers/livescore_data.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class LivescorePublicBoard extends StatefulWidget {
  final String livescoreId;
  final bool checkForScreenOn;

  const LivescorePublicBoard(
      {Key key, this.livescoreId, this.checkForScreenOn = false})
      : super(key: key);

  @override
  LivescorePublicBoardState createState() {
    return new LivescorePublicBoardState();
  }
}

class LivescorePublicBoardState extends State<LivescorePublicBoard> {
  FontWeight _fontWeightTeam1 = FontWeight.normal;
  FontWeight _fontWeightTeam2 = FontWeight.normal;
  Color _pointsBorderColorTeam1 = Colors.white;
  Color _pointsBorderColorTeam2 = Colors.white;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MainInherited.of(context).settings != null) {
      if (widget.checkForScreenOn) {
        MainInherited.of(context).settings.livescorePublicBoardKeepScreenOn
            ? SystemHelpers.setScreenOn()
            : SystemHelpers.setScreenOff();
      }
    } else {
      if (widget.checkForScreenOn) {
        SystemHelpers.setScreenOn();
      }
    }
  }

  @override
  void dispose() {
    SystemHelpers.setScreenOff();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        showAppBar: false,
        body: Container(
          child: StreamBuilder(
              stream: LivescoreData.getMatch(widget.livescoreId),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) return LoaderSpinner();

                SystemSound.play(SystemSoundType.click);
                LivescoreData match = LivescoreData.fromMap(snapshot.data.data);
                _setSelectedTeam(match.activeTeam);

                return Stack(
                  children: <Widget>[
                    Container(
                      child: LivescoreBoard(
                        match: match,
                        paddingTop: 50.0,
                        fontWeightTeam1: _fontWeightTeam1,
                        fontWeightTeam2: _fontWeightTeam2,
                        pointsBorderColorTeam1: _pointsBorderColorTeam1,
                        pointsBorderColorTeam2: _pointsBorderColorTeam2,
                        winnerTeam1:
                            match.winnerTeam != null && match.winnerTeam == 1,
                        winnerTeam2:
                            match.winnerTeam != null && match.winnerTeam == 2,
                        showIsLiveIndicator:
                            match.active != null && match.active == true,
                        message: _setBoardMessage(context, match.matchMessage,
                            match.matchMessageTeam),
                      ),
                    ),
                    Positioned(
                      top: 30.0,
                      left: 10.0,
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                );
              }),
        ));
  }

  String _setBoardMessage(BuildContext context, int messageNumber, int team) {
    String message = "";
    if (messageNumber != 0) {
      message = FlutterI18n.translate(
          context, "livescore.boardMessages.$messageNumber");
      message = message.replaceAll("[TEAM]", team.toString());
    }

    return message;
  }

  void _setSelectedTeam(int team) {
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
}
