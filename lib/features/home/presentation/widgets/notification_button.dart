import 'package:flutter/material.dart';
import '../../../../core/config/route/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 20:02:46

class NotificationButton extends StatelessWidget {
  final Authenticated userState;

  const NotificationButton({super.key, required this.userState});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed(RouteName.notification),
      style: IconButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      icon: Badge.count(
        count: userState.settings.unreadNotifications,
        isLabelVisible: userState.settings.unreadNotifications != 0,
        child: Icon(Icons.notifications_none_rounded),
      ),
    );
  }
}
