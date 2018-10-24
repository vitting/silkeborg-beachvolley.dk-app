import 'package:flutter/material.dart';
import 'package:silkeborgbeachvolley/helpers/silkeborg_beachvolley_colors.dart';
import 'package:silkeborgbeachvolley/ui/helpers/loader_spinner_overlay_widget.dart';
import 'package:silkeborgbeachvolley/ui/scaffold/SilkeborgBeachvolleyScaffold.dart';

class HomeLauncherSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SilkeborgBeachvolleyScaffold(
        showAppBar: false,
        body: LoaderSpinnerOverlay(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: SilkeborgBeachvolleyColors.gradientColorBoxDecoration,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints contraints) {
                  double imageHalfWidth = 105.0;
                  double imageHeight = 200.0;
                  double screenCenterWidth =
                      (contraints.maxWidth / 2) - imageHalfWidth;
                  double screenCenterHeight =
                      (contraints.maxHeight / 2) - imageHeight + 40;
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        left: screenCenterWidth,
                        top: screenCenterHeight,
                        child: Image.asset(
                          "assets/images/logo_white_with_text_210x200.png",
                        ),
                      )
                    ],
                  );
                },
              )),
          show: true,
          showModalBarrier: false,
          text: "",
        ));
  }
}
