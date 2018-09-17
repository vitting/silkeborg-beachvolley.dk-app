import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';
import 'package:silkeborgbeachvolley/ui/testers/test1.dart';
import 'package:silkeborgbeachvolley/ui/testers/test2.dart';
import 'package:silkeborgbeachvolley/ui/testers/test3.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({Key key}) : super(key: key);

  @override
  _TestWidgetState createState() => new _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  CrossFadeState state = CrossFadeState.showFirst;
@override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          AnimatedCrossFade(
      firstChild: Text("TEST1"),
      secondChild: Text("TEST2"),
      crossFadeState: state,
      duration: Duration(milliseconds: 600)
    ),
    RaisedButton(
      onPressed: () {
setState(() {
    if (state == CrossFadeState.showFirst) {
      state = CrossFadeState.showSecond;      
    } else {
      state = CrossFadeState.showFirst;      
    }
    
        });
      },
      child: Text("Knap1"),
    )
        ],
      ),
    );



    // return PageView(
    //     controller: controller,
    //     children: <Widget>[
    //       Test1Widget(_changed),
    //       Test2Widget(changed: _changed),
    //       Test3Widget(_changed)
    //     ],
    //   );
  }

  _changed(int v) {
//     if (v == 2) {
// controller.previousPage(
//       curve: Curves.elasticIn,
//       duration: Duration(milliseconds: 500)
//     );
//     } else {
//       controller.nextPage(
//       curve: Curves.fastOutSlowIn,
//       duration: Duration(milliseconds: 500)
//     );
//     }
    
  }
}

  // @override
  // Widget build(BuildContext context) {
  //   return PageView(
  //       controller: controller,
  //       children: <Widget>[
  //         Test1Widget(_changed),
  //         Test2Widget(changed: _changed),
  //         Test3Widget(_changed)
  //       ],
  //     );
  // }

//   _changed(int v) {
//     if (v == 2) {
// controller.previousPage(
//       curve: Curves.elasticIn,
//       duration: Duration(milliseconds: 500)
//     );
//     } else {
//       controller.nextPage(
//       curve: Curves.fastOutSlowIn,
//       duration: Duration(milliseconds: 500)
//     );
//     }
    
//   }
// }

