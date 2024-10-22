import 'package:flutter/material.dart';

/// @author : Jibin K John
/// @date   : 22/10/2024
/// @time   : 20:38:13

class CategoryTile extends StatelessWidget {
  final Color color;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final double? height;
  final void Function()? onTap;

  const CategoryTile(
      {super.key,
      required this.color,
      this.title,
      this.subtitle,
      this.trailing,
      this.height,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: const BorderSide(
          color: Colors.black12,
          width: .3,
        ),
      ),
      leading: Container(
        width: 10.0,
        height: height ?? 100.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      tileColor: color.withOpacity(.10),
      title: title,
      subtitle: subtitle,
      trailing: trailing,
    );
  }
}
