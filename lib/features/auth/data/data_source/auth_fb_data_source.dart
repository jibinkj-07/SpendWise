import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spend_wise/core/util/error/failure.dart';
import 'package:either_dart/either.dart';
import 'package:spend_wise/core/util/helper/firebase_path.dart';
import 'package:spend_wise/features/auth/domain/model/user_model.dart';

import '../../../../core/util/constant/constants.dart';
import '../../../account/data/data_source/account_fb_data_source.dart';
import '../../domain/model/settings_model.dart';

abstract class AuthFbDataSource {
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

class AuthFbDataSourceImpl implements AuthFbDataSource {
  final FirebaseAuth _firebaseAuth;
  final AccountFbDataSource _accountFbDataSource;
  final FirebaseDatabase _firebaseDatabase;
  final GoogleSignIn _googleSignIn;

  AuthFbDataSourceImpl(
    this._firebaseAuth,
    this._firebaseDatabase,
    this._googleSignIn,
    this._accountFbDataSource,
  );

  @override
  Future<Either<Failure, void>> createUser({
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

      await userCredential.user?.updateDisplayName(name);
      await _createUser(
        uid: userCredential.user?.uid ?? kUnknownUser,
        name: name,
        email: email,
      );

      return Right(null);
    } on FirebaseAuthException catch (e) {
      log("er: [auth_fb_data_source.dart][createUser] $e");
      return Left(
          AuthenticationError(message: e.message ?? "Account creation error."));
    } catch (e) {
      log("er: [auth_fb_data_source.dart][createUser] $e");
      return Left(AuthenticationError(message: "Unable to create account."));
    }
  }

  @override
  Future<Either<Failure, void>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      log("er: [auth_fb_data_source.dart][loginUser] $e");
      return Left(AuthenticationError(message: e.message ?? "Login error."));
    } catch (e) {
      log("er: [auth_fb_data_source.dart][loginUser] $e");
      return Left(AuthenticationError(message: "Something went wrong."));
    }
  }

  @override
  Future<Either<Failure, void>> loginUserWithGoogle() async {
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        userCredential = await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return Left(AuthenticationError(message: "Google sign-in canceled."));
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await _firebaseAuth.signInWithCredential(credential);
      }

      // check if user already created or not
      //if not create new user
      final user = await _accountFbDataSource.getUserInfoByID(
        id: userCredential.user?.uid ?? kUnknownUser,
      );

      if (user.isLeft) {
        await _createUser(
          uid: userCredential.user?.uid ?? kUnknownUser,
          name: userCredential.user?.displayName ?? "User",
          email: userCredential.user?.email ?? "user@gmail.com",
        );
      }
      return const Right(null);
    } catch (e) {
      log("er: [auth_fb_data_source.dart][loginUserWithGoogle] $e");
      return Left(AuthenticationError(message: "Unable to login with Google."));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } catch (e) {
      log("er: [auth_fb_data_source.dart][resetPassword] $e");
      return Left(
          AuthenticationError(message: "Unable to reset password. Try again."));
    }
  }

  @override
  Stream<Either<Failure, MapEntry<UserModel, SettingsModel>>>
      subscribeUserData() async* {
    try {
      // Ensure the user is logged in
      final userId = _firebaseAuth.currentUser?.uid;

      if (userId == null) {
        yield Left(AuthenticationError(message: "User is not logged in."));
        return;
      }

      // References to the user data in Firebase Realtime Database
      final DatabaseReference userDetailsRef =
          _firebaseDatabase.ref(FirebasePath.userDetails(userId));
      final DatabaseReference userSettingsRef =
          _firebaseDatabase.ref(FirebasePath.userSettings(userId));

      // Listen to both userDetails and userSettings nodes
      final userDetailsStream = userDetailsRef.onValue;
      final userSettingsStream = userSettingsRef.onValue;

      // Combine both streams using async* to yield results when either stream emits
      await for (var userEvent in userDetailsStream) {
        await for (var settingsEvent in userSettingsStream) {
          if (userEvent.snapshot.exists && settingsEvent.snapshot.exists) {
            try {
              // Parse the user data and settings data
              final userModel =
                  UserModel.fromFirebase(userEvent.snapshot, userId);
              final settingsModel =
                  SettingsModel.fromFirebase(settingsEvent.snapshot);

              // Emit the parsed models as a MapEntry
              yield Right(MapEntry(userModel, settingsModel));
            } catch (e) {
              yield Left(DatabaseError(
                  message: "Failed to parse user or settings data: $e"));
            }
          } else {
            yield Left(DatabaseError(message: "No data found for this user."));
          }
        }
      }
    } catch (e, stackTrace) {
      log("Error: [auth_fb_data_source.dart][subscribeUserData] $e, $stackTrace");
      yield Left(DatabaseError(message: "Something went wrong."));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      log("er: [auth_fb_data_source.dart][signOut] $e");
      return Left(AuthenticationError(message: "Something went wrong."));
    }
  }

  Future<void> _createUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    final user = UserModel(
      uid: uid,
      name: name,
      email: email,
      profileUrl: kDefaultProfile,
      createdOn: DateTime.now(),
    );
    await _firebaseDatabase
        .ref(FirebasePath.userDetails(user.uid))
        .set(user.toJson()); // Creating settings node
    await _firebaseDatabase.ref(FirebasePath.userSettings(user.uid)).set({
      FirebasePath.newNotification: false,
      FirebasePath.currentBudget: "",
    });
  }
}
