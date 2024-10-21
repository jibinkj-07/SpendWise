import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_budget/core/constants/app_constants.dart';
import 'package:my_budget/core/util/helper/asset_mapper.dart';
import 'package:my_budget/core/util/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

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
            onPressed: () => _launchEmail(context),
            child: const Text("Request Access"),
          )
        ],
      ),
    );
  }

  void _launchEmail(BuildContext context) async {
    const String subject = 'SpendWise Access Request';
    final String body = "Dear Developer,"
        "\nI hope this message finds you well. I am interested in gaining access to ${AppConstants.kAppName} and would appreciate your assistance in providing me with the necessary steps or credentials."
        "\nThank you for your time and support. I look forward to hearing from you soon."
        "\n\nBest regards,";
    final Uri params = Uri(
      scheme: 'mailto',
      path: AppConstants.kAppSupportMail,
      query: 'subject=$subject&body=$body', // add subject and body here
    );
    try {
      if (await canLaunchUrl(params)) {
        await launchUrl(params);

        CustomSnackBar.showSuccessSnackBar(context, "Mail sent");
      } else {
        CustomSnackBar.showErrorSnackBar(context, "Unable to send mail");
      }
    } catch (e) {
      CustomSnackBar.showErrorSnackBar(context, "Unable to send mail");
    }
  }
}
