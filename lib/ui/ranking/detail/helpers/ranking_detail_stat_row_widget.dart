import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/helpers/chip_header_widget.dart';

class RankingDetailStatRow extends StatelessWidget {
  final int total;
  final int won;
  final int lost;
  final String title;

  const RankingDetailStatRow(
      {Key key, this.total, this.won, this.lost, this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: ChipHeader(
              title,
              expanded: true,
              backgroundColor: Color(0xffaaacb5),
              fontSize: 16.0,
              textAlign: TextAlign.center,
              roundedCorners: false,
            ),
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context,
                            "ranking.rankingDetailStatRowWidget.string1")),
                        Text(total.toString())
                      ],
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context,
                            "ranking.rankingDetailStatRowWidget.string2")),
                        Text(won.toString())
                      ],
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(FlutterI18n.translate(context,
                            "ranking.rankingDetailStatRowWidget.string3")),
                        Text(lost.toString())
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
