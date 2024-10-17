import 'package:either_dart/either.dart';

import '../../../../../core/util/error/failure.dart';
import '../../../../common/data/model/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> getUserDetail({required String uid});

  Future<Either<Failure, UserModel>> createAccount({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, void>> signOut();
}
