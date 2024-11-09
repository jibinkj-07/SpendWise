import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spend_wise/core/util/error/failure.dart';
import 'package:either_dart/either.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';
import 'package:spend_wise/features/auth/domain/model/user_model.dart';

abstract class AuthFbDataSource {
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

class AuthFbDataSourceImpl implements AuthFbDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;

  AuthFbDataSourceImpl(
    this._firebaseAuth,
    this._firebaseFirestore,
    this._googleSignIn,
  );

  final String _unknown = "unknown";

  Future<Either<Failure, UserModel>> _getUserModel(String? userId) async {
    final id = userId ?? _unknown;
    final fbSnapshot = await _firebaseFirestore
        .collection(FirebasePath.userNode)
        .doc(id)
        .get();
    if (fbSnapshot.data() == null) {
      return Left(Failure(message: "No data found for this user."));
    }
    return Right(UserModel.fromFirebase(fbSnapshot.data()!, id));
  }

  @override
  Future<Either<Failure, UserModel>> createUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final createdOn = DateTime.now();
      final user = UserModel(
        uid: userCredential.user?.uid ?? _unknown,
        firstName: firstName,
        lastName: lastName,
        email: email,
        createOn: createdOn,
        joinedFamilies: [],
        invitedFamilies: [],
      );

      await userCredential.user?.updateDisplayName("$firstName $lastName");
      await _firebaseFirestore
          .collection(FirebasePath.userNode)
          .doc(user.uid)
          .set(user.toJson());

      return Right(user);
    } on FirebaseAuthException catch (e) {
      log("er: [auth_fb_data_source.dart][createUser] $e");
      return Left(Failure(message: e.message ?? "Account creation error."));
    } catch (e) {
      log("er: [auth_fb_data_source.dart][createUser] $e");
      return Left(Failure(message: "Unable to create account."));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return _getUserModel(userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      log("er: [auth_fb_data_source.dart][loginUser] $e");
      return Left(Failure(message: e.message ?? "Login error."));
    } catch (e) {
      log("er: [auth_fb_data_source.dart][loginUser] $e");
      return Left(Failure(message: "Something went wrong."));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginUserWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return Left(Failure(message: "Google sign-in canceled."));
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }
      return _getUserModel(userCredential.user?.uid);
    } catch (e) {
      log("er: [auth_fb_data_source.dart][loginUserWithGoogle] $e");
      return Left(Failure(message: "Unable to login with Google."));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } catch (e) {
      log("er: [auth_fb_data_source.dart][resetPassword] $e");
      return Left(Failure(message: "Unable to reset password. Try again."));
    }
  }

  @override
  Future<Either<Failure, UserModel>> initUser() async {
    try {
      final userId = _firebaseAuth.currentUser!.uid;
      return await _getUserModel(userId);
    } catch (e) {
      log("er: [auth_fb_data_source.dart][initUser] $e");
      return Left(Failure(message: "Something went wrong."));
    }
  }
}
