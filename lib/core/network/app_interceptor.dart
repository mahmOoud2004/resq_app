import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import '../error/app_logger.dart';
import '../error/error_handler.dart';

class AppInterceptor extends Interceptor {
  final TokenStorage storage;

  AppInterceptor(this.storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getToken();

    options.headers.addAll({
      "Accept": "application/json",
      "ngrok-skip-browser-warning": "true",
    });

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    AppLogger.debug(
      'Request ${options.method} ${options.uri}',
      name: 'Network',
    );

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = ErrorHandler.handle(err);

    AppLogger.error(
      appException.developerMessage,
      name: 'Network',
      error: err,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }
}
