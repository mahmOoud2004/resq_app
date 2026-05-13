import 'package:resq_app/core/network/dio_client.dart';

class DriverEmergencyRemoteDataSource {
  final dio = DioClient().dio;

  /// GET available requests
  Future<List> getAvailableRequests() async {
    final response = await dio.get("/emergency/available");

    /// الصحيح حسب API
    return response.data["available_requests"] ?? [];
  }

  /// ACCEPT request
  Future<void> acceptRequest(int id) async {
    await dio.post("/emergency/accept/$id");
  }

  /// CANCEL request
  Future<void> cancelRequest(int id) async {
    await dio.get("/emergency/cancel/$id", data: {});
  }

  /// COMPLETE request
  Future<void> completeRequest(int id) async {
    await dio.post("/emergency/complete/$id");
  }

  /// GET ACTIVE REQUEST
  Future<Map<String, dynamic>> getActiveRequest() async {
    final response = await dio.get(
      "/driver/emergency/active",
    );

    return response.data;
  }
}
