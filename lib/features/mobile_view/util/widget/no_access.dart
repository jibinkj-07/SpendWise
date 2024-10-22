import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_budget/core/constants/app_constants.dart';
import 'package:my_budget/core/util/helper/asset_mapper.dart';
import 'package:my_budget/core/util/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/util/helper/app_helper.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 12:56:41

class NoAccess extends StatelessWidget {
  const NoAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AssetMapper.noDataSvg,
            width: size.width * .5,
          ),
          const SizedBox(height: 20.0),
          const Text("Contact admin to get access"),
          const SizedBox(height: 10.0),
          FilledButton(
            onPressed: () => AppHelper.sendAccessRequestEmail(context),
            child: const Text("Request Access"),
          )
        ],
      ),
    );
  }

}
