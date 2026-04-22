import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AdminRemoteDatasource {
  final Dio dio = DioClient().dio;

  Future<Response> getStats() async {
    return await dio.get("/admin/stats");
  }

  Future<Response> getPendingUsers() async {
    return await dio.get("/admin/pending-users");
  }

  Future<Response> approveUser(int id) async {
    return await dio.post("/admin/approve-user/$id");
  }

  Future<Response> blockUser(int id) async {
    return await dio.post("/admin/block-user/$id");
  }

  Future<Response> getEmergencies() async {
    return await dio.get("/admin/active-emergencies");
  }

  Future<Response> cancelEmergency(int id) async {
    return await dio.post("/admin/cancel-emergency/$id");
  }

  Future<Response> getAllUsers() async {
    return await dio.get("/admin/users");
  }
}
