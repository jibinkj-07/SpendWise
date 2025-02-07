import 'package:flutter/material.dart';

/// @author : Jibin K John
/// @date   : 12/11/2024
/// @time   : 21:02:07

class LoadingFilledButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool loading;
  final Widget child;
  final bool isDelete;

  const LoadingFilledButton({
    super.key,
    required this.onPressed,
    required this.loading,
    required this.child,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isDelete ? Colors.red : null,
        padding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: loading
            ? Center(
              child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: const CircularProgressIndicator(strokeWidth: 2.0),
                ),
            )
            : SizedBox(
                width: double.infinity,
                child: Center(child: child),
              ),
      ),
    );
  }
}
