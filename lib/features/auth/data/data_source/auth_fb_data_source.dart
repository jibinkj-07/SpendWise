import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, void>> signOut();
}

class AuthFbDataSourceImpl implements AuthFbDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseDatabase _firebaseDatabase;
  final GoogleSignIn _googleSignIn;

  AuthFbDataSourceImpl(
    this._firebaseAuth,
    this._firebaseDatabase,
    this._googleSignIn,
  );

  final String _unknown = "unknown";

  Future<Either<Failure, UserModel>> _getUserModel(String? userId) async {
    final id = userId ?? _unknown;
    final fbSnapshot =
        await _firebaseDatabase.ref(FirebasePath.userPath(id)).once();
    if (!fbSnapshot.snapshot.exists) {
      return Left(Failure(message: "No data found for this user."));
    }
    return Right(UserModel.fromFirebase(fbSnapshot.snapshot));
  }

  Future<void> _updateUserImage(String? userId, String? url) async {
    if (url == null) return;
    await _firebaseDatabase
        .ref(FirebasePath.userNode)
        .child(userId ?? _unknown)
        .update({"profile_url": url});
  }

  @override
  Future<Either<Failure, UserModel>> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final createdOn = DateTime.now();
      final user = UserModel(
        uid: userCredential.user?.uid ?? _unknown,
        name: name,
        email: email,
        profileUrl: "",
        selectedBudget: "",
        createdOn: createdOn,
      );

      await userCredential.user?.updateDisplayName(name);
      await _firebaseDatabase
          .ref(FirebasePath.userPath(user.uid))
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
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await _getUserModel(userCredential.user?.uid);
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

      final userId = userCredential.user?.uid;
      final existingUser = await _getUserModel(userId);

      if (existingUser.isRight) {
        await _updateUserImage(userId, userCredential.user?.photoURL);
        return existingUser;
      }
      final user = UserModel(
        uid: userId ?? _unknown,
        name: userCredential.user?.displayName ?? "User",
        email: userCredential.user?.email ?? "user@gmail.com",
        profileUrl: userCredential.user?.photoURL ?? "",
        selectedBudget: "",
        createdOn: userCredential.user?.metadata.creationTime ?? DateTime.now(),
      );

      await _firebaseDatabase
          .ref(FirebasePath.userPath(user.uid))
          .set(user.toJson());
      return Right(user);
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

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      log("er: [auth_fb_data_source.dart][signOut] $e");
      return Left(Failure(message: "Something went wrong."));
    }
  }
}
