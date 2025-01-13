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
  Stream<Either<Failure, UserModel>> subscribeUserData();

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
  final FirebaseDatabase _firebaseDatabase;
  final GoogleSignIn _googleSignIn;

  AuthFbDataSourceImpl(
    this._firebaseAuth,
    this._firebaseDatabase,
    this._googleSignIn,
  );

  final String _unknown = "unknown";

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
        profileUrl: "profile_1",
        selectedBudget: "",
        notificationStatus: false,
        createdOn: createdOn,
      );

      await userCredential.user?.updateDisplayName(name);
      await _firebaseDatabase
          .ref(FirebasePath.userPath(user.uid))
          .set(user.toJson());

      return Right(user);
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

      // Cant call userModel.toJson() because if already user exist
      // it will override the selected budget id
      await _firebaseDatabase
          .ref(FirebasePath.userPath(userCredential.user?.uid ?? _unknown))
          .update({
        "name": userCredential.user?.displayName ?? "User",
        "email": userCredential.user?.email ?? "user@gmail.com",
        "profile_url": userCredential.user?.photoURL ?? "profile_1",
        "notification_status": false,
        "created_on":
            userCredential.user?.metadata.creationTime ?? DateTime.now(),
      });
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
  Stream<Either<Failure, UserModel>> subscribeUserData() async* {
    try {
      // Ensure the user is logged in
      final userId = _firebaseAuth.currentUser?.uid;

      if (userId == null) {
        yield Left(AuthenticationError(message: "User is not logged in."));
        return;
      }

      // Reference to the user data in Firebase Realtime Database
      final DatabaseReference userRef =
          _firebaseDatabase.ref(FirebasePath.userPath(userId));

      yield* userRef.onValue.map<Either<Failure, UserModel>>((event) {
        if (event.snapshot.exists) {
          try {
            // Parse the user data snapshot into a UserModel
            final userModel = UserModel.fromFirebase(event.snapshot);
            return Right(userModel); // Emit the parsed UserModel
          } catch (e) {
            return Left(
                DatabaseError(message: "Failed to parse user data: $e"));
          }
        } else {
          return Left(DatabaseError(message: "No data found for this user."));
        }
      }).handleError((error) {
        // Handle stream errors and return a failure
        return Left(
            DatabaseError(message: "An error occurred: ${error.toString()}"));
      }).cast<
          Either<Failure, UserModel>>(); // Ensure the correct type is emitted
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
}
