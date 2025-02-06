import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/asset_mapper.dart';

/// @author : Jibin K John
/// @date   : 06/02/2025
/// @time   : 12:57:18

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Widget actionWidget;
  final bool isLoading;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.isLoading = false,
    required this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          margin: const EdgeInsets.all(15.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetMapper.warningSVG,
                  height: size.height * .2,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                actionWidget,
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
