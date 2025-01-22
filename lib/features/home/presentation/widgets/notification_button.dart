import 'package:flutter/material.dart';

import '../../../../core/config/route/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 20:02:46

class NotificationButton extends StatelessWidget {
  final Authenticated authState;

  const NotificationButton({super.key, required this.authState});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed(RouteName.notification),
      style: IconButton.styleFrom(
        foregroundColor: Colors.black,
      ),
      icon: authState.user.notificationStatus
          ? Icon(
              Icons.notifications_active_outlined,
              color: Colors.red,
            )
          : Icon(Icons.notifications_none_rounded),
    );
  }
}
