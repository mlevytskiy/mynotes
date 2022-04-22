import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

import '../auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

// class AuthStateLoading extends AuthState {
//   const AuthStateLoading();
// }

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  final bool isLoading;
  const AuthStateRegistering({
    required this.exception,
    this.isLoading = false,
  });
}
