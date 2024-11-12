import 'package:flutter/material.dart';

import '../helper/asset_mapper.dart';

class ZoomAnimationImage extends StatefulWidget {
  const ZoomAnimationImage({super.key});

  @override
  State<ZoomAnimationImage> createState() => _ZoomAnimationImageState();
}

class _ZoomAnimationImageState extends State<ZoomAnimationImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Define the zoom-in and zoom-out animation range
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Repeat the animation in reverse to create a zoom-in and zoom-out effect
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.sizeOf(context);
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset(
          AssetMapper.appIconImage,
          height: size.height*.08,
          width:  size.height*.08,
        ),
      ),
    );
  }
}
