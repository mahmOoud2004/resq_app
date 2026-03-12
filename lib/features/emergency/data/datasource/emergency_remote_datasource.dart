import 'package:dio/dio.dart';
import 'package:resq_app/core/network/api_constants.dart';
import 'package:resq_app/core/network/dio_client.dart';
import 'package:resq_app/features/emergency/data/model/emergency_request_model.dart';

class EmergencyRemoteDatasource {
  final Dio dio = DioClient().dio;

  Future<void> createEmergency(EmergencyRequestModel request) async {
    print("Sending emergency request...");
    print(request.toJson());

    final response = await dio.post(
      ApiConstants.createEmergency,
      data: request.toJson(),
    );

    print("Server response:");
    print(response.data);
  }
}
