import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/ui/bulletin/helpers/bulletin_type_enum.dart';

class BulletinChooseType extends StatelessWidget {
  final Function onChange;
  final String radioGroupValue;

  BulletinChooseType({this.radioGroupValue, this.onChange});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Opslags type",
          style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
              fontSize: 16.0,
              fontWeight: Theme.of(context).textTheme.caption.fontWeight),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20.0, end: 20.0, top: 10.0),
          child: Column(
            children: <Widget>[
              RadioListTile<String>(
                dense: true,
                title: Text("Nyhed"),
                secondary: Icon(FontAwesomeIcons.newspaper),
                groupValue: radioGroupValue,
                value: BulletinTypeHelper.news,
                onChanged: onChange,
              ),
              RadioListTile<String>(
                dense: true,
                title: Text("Begivenhed"),
                secondary: Icon(FontAwesomeIcons.calendarTimes),
                groupValue: radioGroupValue,
                value: BulletinTypeHelper.event,
                onChanged: onChange,
              ),
              RadioListTile<String>(
                dense: true,
                title: Text("Spil"),
                secondary: Icon(FontAwesomeIcons.volleyballBall),
                groupValue: radioGroupValue,
                value: BulletinTypeHelper.play,
                onChanged: onChange,
              )
            ],
          ),
        )
      ],
    );
  }
}