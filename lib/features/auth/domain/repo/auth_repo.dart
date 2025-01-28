import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../model/settings_model.dart';
import '../model/user_model.dart';

abstract class AuthRepo {
  Stream<Either<Failure, MapEntry<UserModel, SettingsModel>>>
      subscribeUserData();

  Future<Either<Failure, void>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> loginUserWithGoogle();

  Future<Either<Failure, void>> createUser({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, void>> signOut();
}
