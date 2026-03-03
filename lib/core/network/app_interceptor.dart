import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

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

    super.onRequest(options, handler);
  }
}
