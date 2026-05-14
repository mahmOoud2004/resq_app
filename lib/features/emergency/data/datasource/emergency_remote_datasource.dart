import 'package:dio/dio.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'package:resq_app/features/emergency/data/model/emergency_request_model.dart';

class EmergencyRemoteDatasource {
  final Dio dio = DioClient().dio;

  Future<void> createEmergency(EmergencyRequestModel request) async {
    try {
      await dio.post(
        ApiConstants.createEmergency,
        data: request.toJson(),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Emergency creation request failed.',
        name: 'EmergencyRemoteDatasource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }
}
