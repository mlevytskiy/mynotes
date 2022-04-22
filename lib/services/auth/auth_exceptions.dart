class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exception
class GenericAuthException implements Exception {
  final Exception? exception;
  GenericAuthException(this.exception);
}

class UserNotLoggedInAuthException implements Exception {}
