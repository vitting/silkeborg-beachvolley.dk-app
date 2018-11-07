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
    return url != null
        ? ClipOval(
            child: url == "public"
                ? Image.asset("assets/images/no_profile_picture_120x120.png")
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: url,
                    errorWidget: errorWidget ??
                        Image.asset(
                            "assets/images/no_profile_picture_120x120.png",
                            width: size,
                            height: size),
                    placeholder: placeHolder ??
                        Image.asset(
                            "assets/images/no_profile_picture_120x120.png",
                            width: size,
                            height: size),
                    width: size,
                    height: size,
                  ),
          )
        : Stack(
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
  }
}
