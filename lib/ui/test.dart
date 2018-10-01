import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "test",
        body: Container(
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  DateTime date = DateTime(2018, 9, 26);
                  try {
                    final dynamic resp = await CloudFunctions.instance.call(
                      functionName: 'getBulletinsCount',
                      parameters: <String, dynamic>{
                        'date': date.millisecondsSinceEpoch
                      },
                    );
                    print(resp);
                  } on CloudFunctionsException catch (e) {
                    print('caught firebase functions exception');
                    print(e.code);
                    print(e.message);
                    print(e.details);
                  } catch (e) {
                    print('caught generic exception');
                    print(e);
                  }
                },
              )
            ],
          ),
        ));
  }
}
