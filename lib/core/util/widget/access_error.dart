import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../error/failure.dart';
import '../helper/app_helper.dart';
import '../helper/asset_mapper.dart';

/// @author : Jibin K John
/// @date   : 05/02/2025
/// @time   : 17:33:42

class AccessError extends StatelessWidget {
  final Size size;

  const AccessError({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetMapper.accessRevokedSVG,
            height: size.height * .2,
          ),
          const SizedBox(height: 15.0),
          Text(
            "Access Revoked or Data Missing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(
            "Access Denied, this may be due to revoked user permissions by the admin or the data no longer being available.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
