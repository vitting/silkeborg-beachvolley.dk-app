import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class NewsItemImageViewer extends StatelessWidget {
  final String imageUrl;
  
  NewsItemImageViewer(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new PhotoView( 
      imageProvider: CachedNetworkImageProvider(imageUrl),
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: 4.0,
    ));
  }
}
