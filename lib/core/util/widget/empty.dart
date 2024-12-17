import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/asset_mapper.dart';

/// @author : Jibin K John
/// @date   : 16/12/2024
/// @time   : 19:12:19

class Empty extends StatelessWidget {
  final String message;

  const Empty({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AssetMapper.emptySVG,
          height: 100.0,
        ),
        const SizedBox(height: 10.0),
        Text(
          message,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
