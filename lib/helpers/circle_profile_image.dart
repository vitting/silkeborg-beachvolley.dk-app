import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleProfileImage extends StatelessWidget {
  final String url;
  final double size;
  final Widget errorWidget;
  final Widget placeHolder;
  final Color backgroundColor;
  final Widget child;

  const CircleProfileImage(
      {Key key,
      @required this.url,
      this.size = 40.0,
      this.errorWidget,
      this.placeHolder,
      this.backgroundColor = Colors.blue,
      this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget value;
    if (url == null) {
      value = Stack(
            children: <Widget>[
              Container(
                height: size,
                width: size,
                decoration: BoxDecoration(
                    color: backgroundColor, shape: BoxShape.circle),
              ),
              child == null
                  ? Container()
                  : Positioned(
                      width: size,
                      height: size,
                      child: Center(
                        child: child,
                      ),
                    )
            ],
          );
    } else if (url == "public") {
      value = CircleAvatar(
        backgroundImage: AssetImage("assets/images/no_profile_picture_120x120.png"),
      );
    } else if (url == "locale") {
      value = CircleAvatar(
        backgroundImage: AssetImage("assets/images/silkeborg_beachvolley_100x100.png"),
      );
    } else {
      value = ClipOval(
        child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: url,
                    errorWidget: (BuildContext context, String url, Exception error) {
                      return errorWidget ??
                        Image.asset(
                            "assets/images/no_profile_picture_120x120.png",
                            width: size,
                            height: size);
                    },
                    placeholder: (BuildContext context, String url) {
                      return placeHolder ??
                        Image.asset(
                            "assets/images/no_profile_picture_120x120.png",
                            width: size,
                            height: size);
                    }, 
                    width: size,
                    height: size,
                  )
      );
    }

    return value;
  }
}
