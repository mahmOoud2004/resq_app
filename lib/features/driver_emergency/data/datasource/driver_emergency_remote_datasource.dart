import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/network/dio_client.dart';

class DriverEmergencyRemoteDataSource {
  final dio = DioClient().dio;

  Future<List> getAvailableRequests() async {
    try {
      final response = await dio.get("/emergency/available");
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Available requests response is invalid.');
      }
      return data["available_requests"] as List? ?? [];
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch available driver requests.',
        name: 'DriverEmergencyRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  Future<void> acceptRequest(int id) async {
    try {
      await dio.post("/emergency/accept/$id");
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to accept request.',
        name: 'DriverEmergencyRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  Future<void> cancelRequest(int id) async {
    try {
      await dio.get("/emergency/cancel/$id", data: {});
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to cancel request.',
        name: 'DriverEmergencyRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  Future<void> completeRequest(int id) async {
    try {
      await dio.post("/emergency/complete/$id");
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to complete request.',
        name: 'DriverEmergencyRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }

  Future<Map<String, dynamic>> getActiveRequest() async {
    try {
      final response = await dio.get("/driver/emergency/active");
      if (response.data is! Map<String, dynamic>) {
        throw const FormatException('Active request response is invalid.');
      }
      return response.data as Map<String, dynamic>;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to fetch active driver request.',
        name: 'DriverEmergencyRemoteDataSource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }
}
