import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import 'core/config/app_config.dart';
import 'core/util/helper/app_helper.dart';
import 'core/util/helper/asset_mapper.dart';
import 'core/util/widget/custom_snackbar.dart';
import 'core/util/widget/zoom_animation.dart';

/// @author : Jibin K John
/// @date   : 06/02/2025
/// @time   : 20:47:58

class DesktopWarning extends StatelessWidget {
  const DesktopWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppConfig.primaryColor,
      appBar: AppBar(
        backgroundColor: AppConfig.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ZoomAnimationImage(
                  child: Image.asset(
                    AssetMapper.appIconImage,
                    height: size.width * .1,
                    width: size.width * .1,
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  AppConfig.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppHelper.horizontalPadding(size)),
                  child: Text(
                    "Oops! The desktop version is on an extended coffee break ☕️ because the developer ran out of time (and caffeine). But hey, the mobile version is wide awake and ready to roll! Switch to mobile view and enjoy the ride. Thanks for stopping by! 😄",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: .5,
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Contact",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10.0),
              IconButton.filled(
                onPressed: () => sendEmail(context),
                icon: Icon(Iconsax.sms),
              ),
              const SizedBox(width: 50.0),
            ],
          )
        ],
      ),
    );
  }

  Future<void> sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: AppConfig.developer,
      query: 'subject=Regarding ${AppConfig.name}&body=Hi Dev',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);

        CustomSnackBar.showSuccessSnackBar(context, "Mail sent");
      } else {
        CustomSnackBar.showErrorSnackBar(context, "Unable to send mail");
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackBar(context, "Unable to send mail");
    }
  }
}
