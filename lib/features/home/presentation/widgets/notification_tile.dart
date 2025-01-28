import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/util/helper/notification.dart' as noti;
import '../../data/model/notification_model.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 21:59:33

class NotificationTile extends StatelessWidget {
  final ValueNotifier<bool> deleteMode;
  final ValueNotifier<List<NotificationModel>> selected;
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.deleteMode,
    required this.selected,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: deleteMode,
        builder: (ctx, mode, _) {
          return ValueListenableBuilder(
              valueListenable: selected,
              builder: (ctx, selectedItems, _) {
                final isSelected = selectedItems.contains(notification);
                return GestureDetector(
                  onLongPress: mode
                      ? null
                      : () {
                          HapticFeedback.heavyImpact();
                          deleteMode.value = true;
                          selected.value = [notification];
                        },
                  onTap: mode
                      ? () {
                          if (selected.value.contains(notification)) {
                            selected.value = selected.value
                                .where(
                                  (item) => item != notification,
                                )
                                .toList();
                          } else {
                            selected.value = [...selected.value, notification];
                          }
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      tileColor: isSelected ? Colors.blue.shade50 : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      leading: noti.Notification.getIcon(notification.title),
                      title: Text(notification.title),
                      subtitle: Text(notification.body),
                      trailing: Text(
                        noti.Notification.formatDateTime(notification.date),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
