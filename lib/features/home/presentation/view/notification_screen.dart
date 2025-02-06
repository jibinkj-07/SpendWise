import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/injection/injection_container.dart';
import '../../../../core/util/error/failure.dart';
import '../../../../core/util/widget/custom_loading.dart';
import '../../../../core/util/widget/empty.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/model/notification_model.dart';
import '../helper/notification_helper.dart';
import '../widgets/notification_tile.dart';

/// @author : Jibin K John
/// @date   : 22/01/2025
/// @time   : 21:13:26

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationHelper _notificationHelper = sl<NotificationHelper>();
  final ValueNotifier<bool> _deleteMode = ValueNotifier(false);
  final ValueNotifier<List<NotificationModel>> _selected = ValueNotifier([]);

  @override
  void dispose() {
    _deleteMode.dispose();
    _selected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        if (state is Authenticated) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: ValueListenableBuilder(
                valueListenable: _deleteMode,
                builder: (ctx, deleteMode, _) {
                  return deleteMode
                      ? AppBar(
                          surfaceTintColor: Colors.transparent,
                          backgroundColor: Colors.blue.shade100,
                          leading: IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _deleteMode.value = false;
                              _selected.value = [];
                            },
                          ),
                          title: ValueListenableBuilder(
                              valueListenable: _selected,
                              builder: (ctx, selected, _) {
                                return Text("${selected.length} Selected");
                              }),
                          centerTitle: false,
                          actions: [
                            IconButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return  PopScope(
                                          canPop: false,
                                          child: AlertDialog(
                                            title: Text("Deleting"),
                                            content: SizedBox(
                                                height: 70.0,
                                                width: 70.0,
                                                child: CustomLoading()),
                                          ),
                                        );
                                      });
                                  for (final notif in _selected.value) {
                                    await _notificationHelper
                                        .deleteNotification(
                                      userId: state.user.uid,
                                      notificationId: notif.id,
                                    );
                                  }
                                  _deleteMode.value = false;
                                  _selected.value = [];
                                  Navigator.pop(context);
                                },
                                style: IconButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                icon: Icon(Icons.delete_rounded)),
                            TextButton(
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return PopScope(
                                          canPop: false,
                                          child: AlertDialog(
                                            title: Text("Deleting"),
                                            content: SizedBox(
                                                height: 70.0,
                                                width: 70.0,
                                                child: CustomLoading()),
                                          ),
                                        );
                                      });
                                  await _notificationHelper
                                      .clearAllNotification(
                                          userId: state.user.uid);
                                  _deleteMode.value = false;
                                  _selected.value = [];
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                ),
                                child: Text("Clear all")),
                          ],
                        )
                      : AppBar(
                          surfaceTintColor: Colors.transparent,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                          title: const Text("Notifications"),
                          centerTitle: true,
                        );
                },
              ),
            ),
            body: StreamBuilder<Either<Failure, List<NotificationModel>>>(
              stream: _notificationHelper.subscribeNotification(
                userId: state.user.uid,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoading();
                }

                if (snapshot.hasError) {
                  return Empty(message: 'Error: ${snapshot.error}');
                }

                final data = snapshot.data;
                if (data == null) {
                  return const Empty(message: 'No data available.');
                }

                return data.fold(
                  (failure) => Empty(message: failure.message),
                  (notifications) {
                    if (notifications.isEmpty) {
                      return const Empty(message: 'Notifications is empty');
                    }

                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationTile(
                          deleteMode: _deleteMode,
                          notification: notification,
                          selected: _selected,
                        );
                      },
                    );
                  },
                );
              },
            ),
          );
        }
        return const Empty(message: "Notifications is empty");
      },
    );
  }
}
