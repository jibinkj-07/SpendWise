import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/util/helper/asset_mapper.dart';

sealed class AuthHelper {
  static Widget formHeader(Size size) => Column(
        children: [
          SvgPicture.asset(
            AssetMapper.appIconSvg,
            width: size.width * .2,
            height: size.width * .2,
            colorFilter: ColorFilter.mode(
              AppConstants.kAppColor,
              BlendMode.srcIn,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 25.0),
            alignment: AlignmentDirectional.center,
            child: Text(
              AppConstants.kAppName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.kAppColor,
                fontSize: 25.0,
              ),
            ),
          ),
        ],
      );

  static Widget formTitle({required String title}) => Container(
        margin: const EdgeInsets.only(top: 15.0, bottom: 5.0),
        child: Text(title),
      );
}
