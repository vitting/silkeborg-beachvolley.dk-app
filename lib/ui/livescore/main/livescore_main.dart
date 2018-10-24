import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/home/home_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/create/livescore_create_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_overview_matches_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_overview_results.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class Livescore extends StatefulWidget {
  static final routeName = "/livescore";
  @override
  _LivescoreState createState() => _LivescoreState();
}

class _LivescoreState extends State<Livescore> {
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
    _pages = [LivescoreOverviewMatches(), LivescoreOverviewResults()];
  }

  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        title: _getPageTitle(context, _pagePosition),
        floatingActionButton: _floatingActionButton(context),
        bottomNavigationBar:
            DotBottomBar(numberOfDot: _pages.length, position: _pagePosition),
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
    if (page == 0) title = "Live score kampe";
    if (page == 1) title = "Live score resultater";
    return title;
  }

  Widget _floatingActionButton(BuildContext context) {
    if (Home.loggedInUser?.uid != null) {
      return FloatingActionButton(
        backgroundColor: Colors.deepOrange[700],
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) => LivescoreCreateEdit()));
        },
        child: Icon(Icons.add),
      );
    } else {
      return null;
    }
  }
}
