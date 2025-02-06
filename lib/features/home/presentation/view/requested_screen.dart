import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/util/helper/app_helper.dart';
import '../../../../core/util/helper/asset_mapper.dart';
import '../widgets/secondary_app_bar.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 19:43:13

class RequestedScreen extends StatelessWidget {
  const RequestedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: SecondaryAppBar(
        subtitle: "Requested",
        fromRequestedScreen: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppHelper.horizontalPadding(size),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  AssetMapper.pendingSVG,
                  height: size.height * .2,
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Your request has been sent. The admin needs to approve it before you can join the budget."
                  " Please wait or contact the admin for more information.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
