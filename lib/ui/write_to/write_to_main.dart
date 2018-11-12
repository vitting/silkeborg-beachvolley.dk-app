import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/write_to/create/write_to_create_main.dart';
import 'package:silkeborgbeachvolley/ui/write_to/write_to_received_widget.dart';
import 'package:silkeborgbeachvolley/ui/write_to/write_to_sent_widget.dart';

class WriteTo extends StatefulWidget {
  static final String routeName = "/writeto";

  @override
  WriteToState createState() {
    return new WriteToState();
  }
}

class WriteToState extends State<WriteTo> {
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
    _pages = [WriteToReceived(), WriteToSent()];
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _getPageTitle(context, _pagePosition),
        bottomNavigationBar:
            DotBottomBar(numberOfDot: _pages.length, position: _pagePosition),
        floatingActionButton: FloatingActionButton(
          backgroundColor: SilkeborgBeachvolleyTheme.buttonTextColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => WriteToCreate()));
          },
          child: Icon(Icons.add),
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
        ));
  }

  String _getPageTitle(BuildContext context, int page) {
    String title = "";
    if (page == 0)
      title = FlutterI18n.translate(context, "writeTo.writeToMain.title1");
    if (page == 1)
      title = FlutterI18n.translate(context, "writeTo.writeToMain.title2");
    return title;
  }
}
