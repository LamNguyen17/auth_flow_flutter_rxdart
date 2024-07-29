import 'dart:io' show Platform;
import 'package:auth_flow_flutter_rxdart/common/extensions/color_extensions.dart';
import 'package:auth_flow_flutter_rxdart/presentation/components/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:auth_flow_flutter_rxdart/presentation/assets/images/app_images.dart';

const String icBack = AppImages.icBack;

enum AppbarType {
  profile,
  normal,
}

class CustomAppBar extends StatelessWidget {
  final Widget child;
  final String title;
  final AppbarType? type;
  final bool? disableBack;
  final List<Widget>? actions;
  final Widget? childLeading;
  final bool? hasResize;

  const CustomAppBar(
      {required this.child,
      required this.title,
      this.type,
      this.disableBack,
      this.actions,
      this.childLeading,
      this.hasResize,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Scaffold(
        resizeToAvoidBottomInset: hasResize ?? true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: type == AppbarType.profile ? false : true,
          leading: renderLeading(context),
          leadingWidth: renderLeadingWidth(context),
          title: type == AppbarType.profile
              ? const SizedBox.shrink()
              : Text(title ?? ''),
          actions: actions,
        ),
        body: child,
      );
    } else if (Platform.isIOS) {
      return CupertinoPageScaffold(
        resizeToAvoidBottomInset: hasResize ?? true,
        navigationBar: CupertinoNavigationBar(
          border: const Border(bottom: BorderSide.none),
          leading: renderLeading(context),
          trailing: actions?[0],
          middle: type == AppbarType.profile
              ? const SizedBox.shrink()
              : Text(title ?? ''),
        ),
        child: child,
      );
    }
    return const SizedBox.shrink();
  }

  double renderLeadingWidth(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    switch (type) {
      case AppbarType.profile:
        return width;
      case AppbarType.normal:
      default:
        return 56.0; // By default, the value of [leadingWidth] is 56.0
    }
  }

  Widget renderLeading(BuildContext context) {
    switch (type) {
      case AppbarType.profile:
        return Container(child: childLeading);
      case AppbarType.normal:
      default:
        if (disableBack == true) {
          return const SizedBox.shrink();
        } else {
          return AppTouchable(
            child: SvgPicture.asset(icBack,
                fit: BoxFit.scaleDown,
                width: 20.0,
                height: 20.0,
                colorFilter: ColorFilter.mode(
                    HexColor.fromHex('7F7D83'), BlendMode.srcIn)),
            onPress: () {
              Navigator.of(context).pop();
            },
          );
        }
    }
  }
}
