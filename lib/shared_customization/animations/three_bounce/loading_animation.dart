import 'package:flutter/material.dart';
import '/shared_customization/extensions/build_context.ext.dart';
import '/shared_customization/animations/three_bounce/three_bounce.dart';
import 'fade_in_out.dart';

class LoadingAnimation extends StatelessWidget {
  final Color? color;

  const LoadingAnimation({Key? key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: FadeInOut(
          visible: true,
          child: Center(
              child: ThreeBounce(
                  color: color ?? context.appTheme.appThemeData.icon_primary,
                  size: 20.0))),
    );
  }
}
