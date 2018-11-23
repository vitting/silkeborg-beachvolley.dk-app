import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/circle_profile_image.dart';
import 'package:silkeborgbeachvolley/helpers/user_info_data.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class AdminUsers extends StatefulWidget {
  static final String routeName = "/adminusers";
  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
   final ScrollController _scrollController = ScrollController();
  final _defaultNumberOfItemsToLoad = 20;
  int _numberOfItemsToLoad;
  int _currentLengthOfLoadedItems = 0;

  @override
  void initState() {
    super.initState();
    _numberOfItemsToLoad = _defaultNumberOfItemsToLoad;
    _scrollController.addListener(_handleScrollLoadMore);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: FlutterI18n.translate(context, "users.adminUsersMain.title"),
        body: _main());
  }

  Widget _main() {
    return StreamBuilder(
      stream: UserInfoData.getAllUsersAsStream(_numberOfItemsToLoad),
      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LoaderSpinner();

        _currentLengthOfLoadedItems = snapshot.data.documents.length;
        return Scrollbar(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot docSnapshot = snapshot.data.documents[index];
              UserInfoData user = UserInfoData.fromMap(docSnapshot.data);
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
                                MainInherited.of(context).isAdmin1 = value;

                                setState(() {
                                  user.setAdmin1State(value);

                                  if (value == true) {
                                    user.setAdmin2State(value);
                                    MainInherited.of(context).isAdmin2 = value;
                                  }
                                });
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
                                if (!user.admin1) {
                                  MainInherited.of(context).isAdmin2 = value;
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
      }
    );
  }

  void _handleScrollLoadMore() {
    if (_scrollController.position.extentAfter == 0) {
      if (_currentLengthOfLoadedItems >= _numberOfItemsToLoad)
        setState(() {
          _numberOfItemsToLoad =
              _numberOfItemsToLoad + _defaultNumberOfItemsToLoad;
        });
    }
  }
}
