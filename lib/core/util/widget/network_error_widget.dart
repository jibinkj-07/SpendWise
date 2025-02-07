import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../helper/app_helper.dart';
import '../helper/asset_mapper.dart';

/// @author : Jibin K John
/// @date   : 06/02/2025
/// @time   : 23:42:32

class NetworkErrorWidget extends StatelessWidget {
  final Size size;

  const NetworkErrorWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AssetMapper.noInternetLottie,
            height: size.height * .3,
          ),
          const SizedBox(height: 15.0),
          Text(
            "Internet Unavailable",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            "Connect to a stable network and try again",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
