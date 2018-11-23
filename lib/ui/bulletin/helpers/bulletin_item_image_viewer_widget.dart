import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class BulletinItemImageViewer extends StatelessWidget {
  final String imageUrl;

  const BulletinItemImageViewer(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new PhotoView(
      imageProvider: CachedNetworkImageProvider(imageUrl),
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: 4.0
    ));
  }
}
