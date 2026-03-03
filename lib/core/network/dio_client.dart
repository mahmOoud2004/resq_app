import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'app_interceptor.dart';
import '../storage/token_storage.dart';

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
      ),
    );

    dio.interceptors.add(AppInterceptor(TokenStorage()));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
