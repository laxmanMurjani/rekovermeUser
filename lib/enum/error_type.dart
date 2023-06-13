class Error {
  ErrorType? errorType;

  Error({this.errorType = ErrorType.none});
}

enum ErrorType { none,internet }
