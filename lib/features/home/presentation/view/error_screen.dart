import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/util/error/failure.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../widgets/secondary_app_bar.dart';

/// @author : Jibin K John
/// @date   : 15/01/2025
/// @time   : 12:33:34

class ErrorScreen extends StatelessWidget {
  final Failure error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: SecondaryAppBar(
        subtitle: "Budget Unavailable",
      ),
      body: Padding(
        padding: EdgeInsets.all(
          AppHelper.horizontalPadding(size),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetMapper.errorSVG,
              height: size.height * .2,
            ),
            const SizedBox(height: 15.0),
            Text(
              "Budget Data Missing",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              error.message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
