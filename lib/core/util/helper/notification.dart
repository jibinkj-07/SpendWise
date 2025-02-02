import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/app_config.dart';

sealed class Notification {
  static const String budgetInvitation = "Budget Invitation";
  static const String budgetDeleted = "Budget Deleted";
  static const String accessRevoked = "Access Revoked";
  static const String accessGranted = "Access Granted";
  static const String requestAccepted = "Request Accepted";
  static const String requestDeclined = "Request Declined";
  static const String joinRequest = "Join Request";
  static const String memberJoined = "Member Joined";
  static const String memberRemoved = "Member Removed";

  static Widget getIcon(String title) {
    Color color = Colors.blue.shade100;
    IconData icon = Icons.notification_add_outlined;
    //
    // switch (title) {
    //   case budgetInvitation:
    //     color = Colors.purple.shade100;
    //     icon = Icons.mail_outline;
    //     break;
    //   case budgetDeleted:
    //     color = Colors.red.shade100;
    //     icon = Icons.delete_outline;
    //     break;
    //   case accessRevoked:
    //     color = Colors.orange.shade100;
    //     icon = Icons.block;
    //     break;
    //   case accessGranted:
    //     color = Colors.green.shade100;
    //     icon = Icons.check_circle_outline;
    //     break;
    //   case requestAccepted:
    //     color = Colors.green.shade100;
    //     icon = Icons.thumb_up_alt_outlined;
    //     break;
    //   case requestDeclined:
    //     color = Colors.red.shade100;
    //     icon = Icons.thumb_down_alt_outlined;
    //     break;
    //   case joinRequest:
    //     color = Colors.blue.shade100;
    //     icon = Icons.group_add_outlined;
    //     break;
    //   case memberJoined:
    //     color = Colors.green.shade100;
    //     icon = Icons.person_add_alt_outlined;
    //     break;
    //   case memberRemoved:
    //     color = Colors.red.shade100;
    //     icon = Icons.person_remove_alt_1_outlined;
    //     break;
    //   default:
    //     color = Colors.grey.shade300;
    //     icon = Icons.notifications_none;
    // }

    return CircleAvatar(
      backgroundColor: color,
      child: Icon(icon, color: Colors.black87),
    );
  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return "Today\n${DateFormat.jm().format(dateTime)}";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE()
          .format(dateTime); // Returns day name like "Monday"
    } else if (difference.inDays < 30) {
      return DateFormat("d MMM").format(dateTime); // Returns like "1 Jan"
    } else if (difference.inDays < 365) {
      final monthsAgo = (difference.inDays / 30).floor();
      return "$monthsAgo month${monthsAgo > 1 ? 's' : ''} ago";
    } else {
      final yearsAgo = (difference.inDays / 365).floor();
      return "$yearsAgo year${yearsAgo > 1 ? 's' : ''} ago";
    }
  }
}
