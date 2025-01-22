import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../../data/model/notification_model.dart';

abstract class NotificationRepo {
  Stream<Either<Failure, List<NotificationModel>>> subscribeNotification({
    required String userId,
  });

  Future<Either<Failure, bool>> deleteNotification({
    required String userId,
    required String notificationId,
  });

  Future<Either<Failure, bool>> clearAllNotification({required String userId});
}
