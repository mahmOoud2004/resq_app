class AppException implements Exception {
  final String userMessage;
  final String developerMessage;
  final String code;
  final Object? originalError;

  const AppException({
    required this.userMessage,
    required this.developerMessage,
    required this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException($code): $developerMessage';
}
