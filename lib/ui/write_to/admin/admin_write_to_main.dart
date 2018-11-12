import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_create_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_received_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_sent_mails_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/admin/admin_write_to_sent_messages_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/helpers/write_to_create_fab_widget.dart';

class AdminWriteTo extends StatefulWidget {
  static final String routeName = "/adminwriteto";

  @override
  AdminWriteToState createState() {
    return new AdminWriteToState();
  }
}

class AdminWriteToState extends State<AdminWriteTo> {
  int _pagePosition = 0;
  PageController _pageController = PageController();
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _initPages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _initPages() {
    _pages = [AdminWriteToReceived(), AdminWriteToSentMessages(), AdminWriteToSentMails()];
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
      title: _getPageTitle(context, _pagePosition),
       bottomNavigationBar:
            DotBottomBar(numberOfDot: _pages.length, position: _pagePosition),
      floatingActionButton: WriteToCreateFab(
        onPressedValue: (WriteToCreateFabType type) {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) =>
                  AdminWriteToCreate(type: type)));
        },
      ),
      body: PageView.builder(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _pagePosition = page;
            });
          },
          itemCount: _pages.length,
          itemBuilder: (BuildContext context, int page) {
            return _pages[page];
          },
        )
    );
  }

  String _getPageTitle(BuildContext context, int page) {
    String title = "";
    if (page == 0)
      title = FlutterI18n.translate(context, "writeTo.adminWriteToMain.title1");
    if (page == 1)
      title = FlutterI18n.translate(context, "writeTo.adminWriteToMain.title2");
    if (page == 2)
      title = FlutterI18n.translate(context, "writeTo.adminWriteToMain.title3");
    return title;
  }
}
