import 'package:dio/dio.dart';
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
    print("=========== CHATBOT REQUEST ===========");
    print("User ID: $userId");
    print("Message: $message");
    print("Lat: $lat");
    print("Lng: $lng");

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

    print("=========== SERVER RESPONSE ===========");
    print(response.data);
    print("=======================================");

    return ChatbotResponseModel.fromJson(response.data);
  }
}
