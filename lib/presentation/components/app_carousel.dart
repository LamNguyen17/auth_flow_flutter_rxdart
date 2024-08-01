import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class AppCarousel extends StatelessWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final List<dynamic>? itemCount;
  final bool? autoPlay;
  final double? height;
  final double? viewportFraction;

  const AppCarousel({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.autoPlay,
    this.height,
    this.viewportFraction,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: itemCount?.length,
      options: CarouselOptions(
        autoPlay: autoPlay ?? true,
        enlargeCenterPage: true,
        viewportFraction: viewportFraction ?? 0.6,
        height: height ?? 300,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return itemBuilder(context, index);
      },
    );
  }
}
