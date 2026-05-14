import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'app_interceptor.dart';
import '../storage/token_storage.dart';
import '../error/app_logger.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (status) => status != null && status >= 200 && status < 300,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(AppInterceptor(TokenStorage()));
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
        responseHeader: false,
        logPrint: (message) => AppLogger.debug(message.toString(), name: 'Dio'),
      ),
    );
  }
}
