import 'package:flutter/material.dart';

enum SystemMode {
  release,
  debug
}

class MainInherited extends StatefulWidget {
  final Widget child;
  final SystemMode mode;

  MainInherited({this.child, this.mode});

  @override
  MainInheritedState createState() => new MainInheritedState();

  static MainInheritedState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MainInherited) as _MainInherited).data;
  }
}

class MainInheritedState extends State<MainInherited> {
  SystemMode get modeProfile => widget.mode;

  @override
  Widget build(BuildContext context) {
    return new _MainInherited(
      data: this,
      child: widget.child,
    );
  }
}

class _MainInherited extends InheritedWidget {
  final MainInheritedState data;

  _MainInherited({Key key, this.data, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MainInherited old) {
    return true;
  }
}