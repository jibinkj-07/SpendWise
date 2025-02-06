import 'package:flutter/material.dart';

import '../widget/custom_snackbar.dart';

class Failure {
  final String message;

  Failure({required this.message});

  void showSnackBar(BuildContext context) =>
      CustomSnackBar.showErrorSnackBar(context, message);
}

class AuthenticationError extends Failure {
  AuthenticationError({required super.message});
}

class DatabaseError extends Failure {
  DatabaseError({required super.message});
}

class NetworkError extends Failure {
  NetworkError() : super(message: "Check your network connection");
}

class AccessRevokedError extends Failure {
  AccessRevokedError({required super.message});
}
