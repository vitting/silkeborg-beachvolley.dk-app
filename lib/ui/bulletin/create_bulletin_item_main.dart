import 'dart:async';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_firestore.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_item_class.dart';
import 'package:silkeborgbeachvolley/helpers/bulletin_type_enum.dart';
import 'package:silkeborgbeachvolley/helpers/local_user_info_class.dart';
import 'package:silkeborgbeachvolley/helpers/userauth.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:uuid/uuid.dart';

String radioGroupValue = BulletinType.news;

class CreateBulletinItem extends StatefulWidget {
  @override
  _CreateBulletinItemState createState() => _CreateBulletinItemState();
}

class _CreateBulletinItemState extends State<CreateBulletinItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final BulletinItem _bulletinItem = new BulletinItem(type: BulletinType.news);
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: "Silkeborg Beachvolley", 
      body: ModalProgressHUD(
        opacity: 0.5,
        child: _main(),
        inAsyncCall: _saving
      ));
  }

  Widget _main() {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        _chooseBulletinType(),
        _createBulletinItemForm(context)
      ],
    );
  }

  Widget _chooseBulletinType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Opslags type"),
        Container(
          margin: EdgeInsetsDirectional.only(start: 20.0, end: 20.0, top: 10.0),
          child: Column(
            children: <Widget>[
              RadioListTile<String>(
                dense: true,
                title: Text("Nyhed"),
                secondary: Icon(FontAwesomeIcons.newspaper),
                groupValue: radioGroupValue,
                value: BulletinType.news,
                onChanged: (value) {
                  setState(() {
                    _bulletinItem.type = value;
                    radioGroupValue = value;
                  });
                },
              ),
              RadioListTile<String>(
                dense: true,
                title: Text("Begivenhed"),
                secondary: Icon(FontAwesomeIcons.calendarTimes),
                groupValue: radioGroupValue,
                value: BulletinType.event,
                onChanged: (value) {
                  setState(() {
                    _bulletinItem.type = value;
                    radioGroupValue = value;
                  });
                },
              ),
              RadioListTile<String>(
                dense: true,
                title: Text("Spil"),
                secondary: Icon(FontAwesomeIcons.volleyballBall),
                groupValue: radioGroupValue,
                value: BulletinType.play,
                onChanged: (value) {
                  setState(() {
                    _bulletinItem.type = value;
                    radioGroupValue = value;
                  });
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _createBulletinItemForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        keyboardType: TextInputType.text,
        maxLength: 500,
        maxLines: 6,
        decoration: new InputDecoration(
            labelText: "Opslag",
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    _saving = true;      
                  });
                  await _saveBulletinItem(_bulletinItem);
                  setState(() {
                    _saving = false;      
                  });
                  Navigator.of(context)
                    .pop<BulletinItem>(_bulletinItem);
                }
              },
            )),
        validator: (String value) {
          if (value.isEmpty) return "Opslaget skal udfyldes";
        },
        onSaved: (String value) {
          _bulletinItem.body = value;
        },
      ),
    );
  }

  Future<void> _saveBulletinItem(BulletinItem item) async {
    final Uuid _uuid = new Uuid();
    LocalUserInfo _localuserInfo = await UserAuth.getLoclUserInfo();
    item.authorId = _localuserInfo.id;
    item.authorName = _localuserInfo.name;
    item.authorPhotoUrl = _localuserInfo.photoUrl;
    item.id = _uuid.v4();
    await BulletinFirestore.saveBulletinItem(item);
  }
}
