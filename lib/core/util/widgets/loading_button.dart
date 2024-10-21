import 'package:flutter/material.dart';
import 'package:my_budget/core/constants/app_constants.dart';

/// @author : Jibin K John
/// @date   : 21/10/2024
/// @time   : 11:26:50

class LoadingButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool loading;
  final Widget child;
  final String loadingLabel;
  final bool isDelete;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.loading,
    required this.child,
    required this.loadingLabel,
    this.isDelete=false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isDelete?Colors.red:null,
        disabledBackgroundColor:isDelete?Colors.red: AppConstants.kAppColor,
        disabledForegroundColor: Colors.white70,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loadingLabel),
                  Container(
                    margin: const EdgeInsets.only(left: 8.0),
                    height: 20.0,
                    width: 20.0,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: double.infinity,
                child: Center(child: child),
              ),
      ),
    );
  }
}
