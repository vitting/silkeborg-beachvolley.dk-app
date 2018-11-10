import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_theme.dart';
import 'package:silkeborgbeachvolley/ui/main_inheretedwidget.dart';
import 'package:silkeborgbeachvolley/ui/helpers/dot_bottombar_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/create/livescore_create_main.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_overview_matches_widget.dart';
import 'package:silkeborgbeachvolley/ui/livescore/main/livescore_overview_results_widget.dart';
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
    if (page == 0)
      title = FlutterI18n.translate(context, "livescore.livescoreMain.title1");
    if (page == 1)
      title = FlutterI18n.translate(context, "livescore.livescoreMain.title2");
    return title;
  }

  Widget _floatingActionButton(BuildContext context) {
    if (MainInherited.of(context).userId != null) {
      return FloatingActionButton(
        backgroundColor: SilkeborgBeachvolleyTheme.buttonTextColor,
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
