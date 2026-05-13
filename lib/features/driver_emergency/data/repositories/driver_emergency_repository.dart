import '../datasource/driver_emergency_remote_datasource.dart';
import '../models/driver_request_model.dart';

class DriverEmergencyRepository {
  final DriverEmergencyRemoteDataSource remote =
      DriverEmergencyRemoteDataSource();

  Future<List<DriverRequestModel>> getRequests() async {
    final data = await remote.getAvailableRequests();

    return data.map((e) => DriverRequestModel.fromJson(e)).toList();
  }

  Future<void> acceptRequest(int id) async {
    await remote.acceptRequest(id);
  }

  Future<void> cancelRequest(int id) async {
    await remote.cancelRequest(id);
  }

  Future<void> completeRequest(int id) async {
    await remote.completeRequest(id);
  }

  Future<DriverRequestModel?> getActiveRequest() async {
    final data = await remote.getActiveRequest();

    final hasActive = data["has_active_request"] ?? false;

    if (!hasActive) {
      return null;
    }

    return DriverRequestModel.fromJson(
      data["request_details"],
    );
  }
}
