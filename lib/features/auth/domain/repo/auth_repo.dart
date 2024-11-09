import 'package:either_dart/either.dart';

import '../../../../core/util/error/failure.dart';
import '../model/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> initUser();
  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> loginUserWithGoogle();

  Future<Either<Failure, UserModel>> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPassword({required String email});
}
