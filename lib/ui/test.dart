import 'dart:async';

import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();

  //   Future<Null> _askedToLead(BuildContext context) async {
  //     final _formKey = GlobalKey<FormState>();

  //     var result = await showDialog<int>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return new SimpleDialog(
  //             title: const Text('Opret nyhed'),
  //             children: <Widget>[
  //               Form(
  //                 key: _formKey,
  //                 child: Column(
  //                   children: <Widget>[
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: "Titel"),
  //                       onSaved: (String value) {},
  //                     ),
  //                     TextFormField(
  //                       decoration: InputDecoration(labelText: "Titel"),
  //                       onSaved: (String value) {},
  //                     )
  //                   ],
  //                 ),
  //               )
  //             ],
  //           );
  //         });

  //     print(result);
  //   }
  // }

  // Future _openAddEntryDialog() async {
  //   WeightSave save =
  //       await Navigator.of(context).push(new MaterialPageRoute<WeightSave>(
  //           builder: (BuildContext context) {
  //             return new AddEntryDialog();
  //           },
  //           fullscreenDialog: true));
  //   if (save != null) {
  //     _addWeightSave(save);
  //   }
  }
}
