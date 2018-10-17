import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/ranking/createMatch/helpers/create_player_chooser_widget.dart';
import 'package:silkeborgbeachvolley/ui/ranking/helpers/ranking_player_data_class.dart';

class CreatePlayerChooserRow extends StatelessWidget {
  final RankingPlayerData player1Item;
  final RankingPlayerData player2Item;
  final Color chooser1Color;
  final Color chooser2Color;
  final PlayerChooserType chooser1Type;
  final PlayerChooserType chooser2Type;
  final ValueChanged<PlayerChooserType> chooserOnTap;
  final String title;
  final String noChoosenText;

  const CreatePlayerChooserRow(
      {Key key,
      this.player1Item,
      this.player2Item,
      this.chooser1Color,
      this.chooser2Color,
      this.chooser1Type,
      this.chooser2Type,
      this.chooserOnTap,
      this.title,
      this.noChoosenText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CreatePlayerChooser(
                          color: chooser1Color,
                          playerItem: player1Item,
                          type: chooser1Type,
                          onTapPlayer: (PlayerChooserType type) {
                            chooserOnTap(type);
                          },
                        ),
                      ],
                    )),
                Expanded(
                    flex: 1, child: Text(title, textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CreatePlayerChooser(
                          color: chooser2Color,
                          playerItem: player2Item,
                          type: chooser2Type,
                          onTapPlayer: (PlayerChooserType type) {
                            chooserOnTap(type);
                          },
                        ),
                      ],
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      player1Item == null ? noChoosenText : player1Item.name,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      player2Item == null ? noChoosenText : player2Item.name,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
