import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../data/model/notification_model.dart';
import '../../domain/repo/notification_repo.dart';

 class NotificationHelper {
  final NotificationRepo _notificationRepo;

  NotificationHelper(this._notificationRepo);

  Stream<Either<Failure, List<NotificationModel>>> subscribeNotification({
    required String userId,
  }) async* {
    yield* _notificationRepo.subscribeNotification(userId: userId);
  }

  Future<Either<Failure, bool>> deleteNotification({
    required String userId,
    required String notificationId,
  }) async =>
      await _notificationRepo.deleteNotification(
        userId: userId,
        notificationId: notificationId,
      );

  Future<Either<Failure, bool>> clearAllNotification({
    required String userId,
  }) async =>
      await _notificationRepo.clearAllNotification(userId: userId);
}
