import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/util/helper/asset_mapper.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 18:17:37


class Loading extends StatelessWidget {
const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AssetMapper.loadingLottie),
          SizedBox(
            width: 100.0,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ],
      ),
    );
  }
}

