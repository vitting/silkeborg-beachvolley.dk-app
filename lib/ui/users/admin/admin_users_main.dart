import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class AdminUsers extends StatefulWidget {
  static final String routeName = "/adminusers";
  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: FlutterI18n.translate(context, "users.adminUsersMain.title"),
        body: _main());
  }

  Widget _main() {
    return FutureBuilder(
      future: UserInfoData.getAllUsers(),
      builder:
          (BuildContext context, AsyncSnapshot<List<UserInfoData>> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();

        return Container(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              UserInfoData user = snapshot.data[index];
              return Card(
                child: ListTile(
                  leading: CircleProfileImage(
                    url: user.photoUrl,
                    size: 50.0,
                  ),
                  title: InkWell(
                    onLongPress: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext modalContext) {
                            return AlertDialog(
                              title: Text(FlutterI18n.translate(modalContext,
                                  "users.adminUsersMain.string5")),
                              content: Text(user.id),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(FlutterI18n.translate(
                                      modalContext,
                                      "users.adminUsersMain.string6")),
                                  onPressed: () {
                                    Navigator.of(modalContext).pop();
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Text(user.name),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Icon(Icons.email,
                                    size: 22.0, color: Colors.blue[700]),
                              ),
                              Expanded(
                                child: Text(user.email),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.people, color: Colors.blue[700]),
                                Tooltip(
                                  message: FlutterI18n.translate(
                                      context, "users.adminUsersMain.string1"),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(FlutterI18n.translate(context,
                                        "users.adminUsersMain.string2")),
                                  ),
                                )
                              ],
                            ),
                            Switch(
                              value: user.admin1,
                              onChanged: (bool value) {
                                if (MainInherited.of(context).isAdmin1) {
                                  setState(() {
                                    user.setAdmin1State(value);
                                  });
                                }
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.person, color: Colors.blue[700]),
                                Tooltip(
                                  message: FlutterI18n.translate(
                                      context, "users.adminUsersMain.string3"),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(FlutterI18n.translate(context,
                                        "users.adminUsersMain.string4")),
                                  ),
                                )
                              ],
                            ),
                            Switch(
                              value: user.admin2,
                              onChanged: (bool value) {
                                if (MainInherited.of(context).isAdmin1) {
                                  setState(() {
                                    user.setAdmin2State(value);
                                  });
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
