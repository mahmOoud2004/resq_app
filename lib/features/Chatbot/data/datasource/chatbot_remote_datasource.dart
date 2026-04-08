import 'package:dio/dio.dart';
import 'package:resq_app/features/Chatbot/data/models/chat_message_model.dart';

class ChatbotRemoteDataSource {
  final Dio dio;

  ChatbotRemoteDataSource(this.dio);

  Future<ChatbotResponseModel> sendMessage({
    required String userId,
    required String message,
    required double lat,
    required double lng,
  }) async {
    final response = await dio.post(
      "https://subpyramidical-nonsynodic-isiah.ngrok-free.dev/api/v1/mobile/chat",
      data: {"user_id": userId, "message": message, "lat": lat, "lng": lng},
    );

    return ChatbotResponseModel.fromJson(response.data);
  }
}
