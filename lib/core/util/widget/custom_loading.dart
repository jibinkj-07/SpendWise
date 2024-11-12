import 'package:flutter/material.dart';
import 'package:spend_wise/core/util/widget/zoom_animation.dart';

import '../../config/app_config.dart';

/// @author : Jibin K John
/// @date   : 11/11/2024
/// @time   : 22:19:52

class CustomLoading extends StatelessWidget {
  final bool useScaffold;
  final bool appLaunch;

  const CustomLoading({
    super.key,
    this.useScaffold = false,
    this.appLaunch = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useScaffold) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            backgroundColor: Colors.black12,
          ),
        ),
      );
    }
    if (appLaunch) {
      return Scaffold(
        backgroundColor: AppConfig.primaryColor,
        body: Center(
          child: ZoomAnimationImage(),
        ),
      );
    }
    return CircularProgressIndicator(
      strokeWidth: 2.5,
      backgroundColor: Colors.black12,
    );
  }
}
