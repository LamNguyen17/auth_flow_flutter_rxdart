import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FastImage extends StatelessWidget {
  final dynamic url;
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  final double? borderDefaultImg;
  final dynamic fit;

  const FastImage(
      {super.key,
      required this.url,
      required this.width,
      required this.height,
      this.borderDefaultImg,
      this.borderRadius,
      this.fit});

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const Center(child: Icon(Icons.error));
    }
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(0)),
          image:
              DecorationImage(image: imageProvider, fit: fit ?? BoxFit.contain),
        ),
      ),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
