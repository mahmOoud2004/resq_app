import 'package:dio/dio.dart';
import 'package:resq_app/core/error/app_logger.dart';
import 'package:resq_app/core/error/error_handler.dart';

import '../models/chatbot_response_model.dart';

class ChatbotRemoteDatasource {
  final Dio dio;

  ChatbotRemoteDatasource(this.dio);

  Future<ChatbotResponseModel> sendMessage({
    required String userId,
    required String message,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await dio.post(
        "https://subpyramidical-nonsynodic-isiah.ngrok-free.dev/api/v1/mobile/chat",
        data: {"user_id": userId, "message": message, "lat": lat, "lng": lng},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "ngrok-skip-browser-warning": "true",
          },
        ),
      );

      if (response.data is! Map<String, dynamic>) {
        throw const FormatException('Chatbot response is invalid.');
      }

      return ChatbotResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Chatbot request failed.',
        name: 'ChatbotRemoteDatasource',
        error: error,
        stackTrace: stackTrace,
      );
      throw ErrorHandler.handle(error, stackTrace: stackTrace);
    }
  }
}
