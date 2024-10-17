import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:either_dart/either.dart';
import 'package:my_budget/core/util/helper/firebase_mapper.dart';

import '../../../../../core/util/error/failure.dart';
import '../../../../common/data/model/user_model.dart';

abstract class AuthFbDataSource {
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

class AuthFbDataSourceImpl implements AuthFbDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _firebaseDatabase;

  AuthFbDataSourceImpl(this._firebaseAuth, this._firebaseDatabase);

  @override
  Future<Either<Failure, UserModel>> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Creating new user into firebase auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      final uid = userCredential.user?.uid ?? "unknownUser";
      final user = UserModel(
        uid: uid,
        name: name,
        email: email,
        adminId: "",
      );

      // Storing new user details into firebase db
      await _firebaseDatabase
          .ref(FirebaseMapper.userNode)
          .update(user.toFirebaseJson());

      // returning user data back to function call
      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(message: e.message.toString()));
    } catch (e) {
      log("er:[createAccount][auth_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Creating new user into firebase auth
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid ?? "unknownUser";

      // Retrieving and returning user details from firebase db
      return await getUserDetail(uid: uid);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(message: e.message.toString()));
    } catch (e) {
      log("er:[loginUser][auth_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserDetail(
      {required String uid}) async {
    try {
      // Retrieving  user details from firebase db
      final userSnapshot =
          await _firebaseDatabase.ref(FirebaseMapper.userPath(uid)).get();
      final user = UserModel.fromFirebase(userSnapshot, uid);
      // returning user data back to function call
      return Right(user);
    } catch (e) {
      log("er:[getUserDetail][auth_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(Failure(message: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      log("er:[signOut][auth_fb_data_source.dart] $e");
      return Left(Failure(message: "Something went wrong. Try again"));
    }
  }
}
