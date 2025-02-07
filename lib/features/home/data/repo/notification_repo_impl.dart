import 'package:either_dart/either.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/util/error/failure.dart';
import '../../domain/repo/notification_repo.dart';
import '../data_source/notification_fb_data_source.dart';
import '../model/notification_model.dart';

class NotificationRepoImpl implements NotificationRepo {
  final NotificationDataSource _notificationDataSource;

  NotificationRepoImpl(this._notificationDataSource);

  @override
  Future<Either<Failure, bool>> clearAllNotification({
    required String userId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _notificationDataSource.clearAllNotification(userId: userId);
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    if (await InternetConnection().hasInternetAccess) {
      return await _notificationDataSource.deleteNotification(
        userId: userId,
        notificationId: notificationId,
      );
    } else {
      return Left(NetworkError());
    }
  }

  @override
  Stream<Either<Failure, List<NotificationModel>>> subscribeNotification({
    required String userId,
  }) async* {
    if (await InternetConnection().hasInternetAccess) {
      yield* _notificationDataSource.subscribeNotification(userId: userId);
    } else {
      yield Left(NetworkError());
    }
  }
}
