import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

enum NewsType { News, Info, Game, None }

NewsType radioGroupValue = NewsType.News;

class CreateNewsValues {
  NewsType type = NewsType.None;
  String body = "";
}

class CreateNews extends StatefulWidget {
  @override
  _CreateNewsState createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CreateNewsValues createNewsValues = new CreateNewsValues();

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: "Silkeborg Beachvolley", body: _main());
  }

  _main() {
    final TextEditingController _newsController = new TextEditingController();
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        Text("Opslags type"),
        RadioListTile<NewsType>(
          dense: true,
          title: Text("Nyhed"),
          secondary: Icon(Icons.receipt),
          groupValue: radioGroupValue,
          value: NewsType.News,
          onChanged: (value) {
            setState(() {
              createNewsValues.type = value;
              radioGroupValue = value;
            });
          },
        ),
        RadioListTile<NewsType>(
          dense: true,
          title: Text("Information"),
          secondary: Icon(Icons.info),
          groupValue: radioGroupValue,
          value: NewsType.Info,
          onChanged: (value) {
            setState(() {
              createNewsValues.type = value;
              radioGroupValue = value;
            });
          },
        ),
        RadioListTile<NewsType>(
          dense: true,
          title: Text("Spil"),
          secondary: Icon(Icons.wb_sunny),
          groupValue: radioGroupValue,
          value: NewsType.Game,
          onChanged: (value) {
            setState(() {
              createNewsValues.type = value;
              radioGroupValue = value;
            });
          },
        ),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _newsController,
            keyboardType: TextInputType.text,
            maxLength: 500,
            maxLines: 6,
            decoration: new InputDecoration(
                labelText: "Opslag",
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator
                          .of(context)
                          .pop<CreateNewsValues>(createNewsValues);
                    }
                  },
                )),
            validator: (String value) {
              if (value.isEmpty) return "Opslag skal udfyldes";
            },
            onSaved: (String value) {
              createNewsValues.body = value;
            },
          ),
        )
      ],
    );
  }

  // Text("Type"),
  //       RadioListTile<NewsType>(
  //         dense: true,
  //         title: Text("Nyhed"),
  //         secondary: Icon(Icons.receipt),
  //         groupValue: radioGroupValue,
  //         value: NewsType.News,
  //         onChanged: (value) {
  //           setState(() {
  //             createNewsValues.type = value;
  //             radioGroupValue = value;
  //           });
  //         },
  //       ),
  //       RadioListTile<NewsType>(
  //         dense: true,
  //         title: Text("Information"),
  //         secondary: Icon(Icons.info),
  //         groupValue: radioGroupValue,
  //         value: NewsType.Info,
  //         onChanged: (value) {
  //           setState(() {
  //             createNewsValues.type = value;
  //             radioGroupValue = value;
  //           });
  //         },
  //       ),
  //       RadioListTile<NewsType>(
  //         dense: true,
  //         title: Text("Spil"),
  //         secondary: Icon(Icons.wb_sunny),
  //         groupValue: radioGroupValue,
  //         value: NewsType.Game,
  //         onChanged: (value) {
  //           setState(() {
  //             createNewsValues.type = value;
  //             radioGroupValue = value;
  //           });
  //         },
  //       ),
  //       TextFormField(
  //         controller: _newsController,
  //         keyboardType: TextInputType.text,
  //         maxLength: 500,
  //         maxLines: 6,
  //         decoration: new InputDecoration(
  //             labelText: "Opslag",
  //             suffixIcon: IconButton(
  //               icon: Icon(Icons.send),
  //               onPressed: () {
  //                 if (_formKey.currentState.validate()) {
  //                   Navigator
  //                       .of(context)
  //                       .pop<CreateNewsValues>(createNewsValues);
  //                 }
  //               },
  //             )),
  //         validator: (String value) {
  //           if (value.isEmpty) return "Opslag skal udfyldes";
  //         },
  //         onSaved: (String value) {
  //           createNewsValues.body = value;
  //         },
  //       )
}
