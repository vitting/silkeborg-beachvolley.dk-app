import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_widget.dart';

class LoaderSpinnerOverlay extends StatelessWidget {
  final Widget child;
  final bool show;
  final bool showModalBarrier;
  final String text;

  const LoaderSpinnerOverlay(
      {Key key,
      @required this.child,
      @required this.show,
      this.showModalBarrier = true,
      this.text = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [child];
    if (show) {
      widgets.addAll(_loader());
    }

    return Stack(
      children: widgets,
    );
  }

  List<Widget> _loader() {
    List<Widget> loaderWidgets = [
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoaderSpinner(),
            text.isEmpty
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.blue),
                    padding: EdgeInsets.all(10.0),
                    child: Text(text, style: TextStyle(color: Colors.white)),
                  )
          ],
        ),
      )
    ];

    if (showModalBarrier) {
      loaderWidgets.add(Opacity(
        opacity: 0.4,
        child: ModalBarrier(
          color: Colors.grey,
          dismissible: false,
        ),
      ));
    }
    
    return loaderWidgets;
  }
}
