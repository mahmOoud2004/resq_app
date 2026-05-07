import 'package:resq_app/features/emergency/data/model/emergency_request_model.dart';
import '../../domain/repositories/emergency_repository.dart';
import '../datasource/emergency_remote_datasource.dart';

class EmergencyRepositoryImpl implements EmergencyRepository {
  final EmergencyRemoteDatasource remote = EmergencyRemoteDatasource();

  @override
  Future<void> createEmergency({
    required String serviceType,
    required double lat,
    required double lng,
  }) {
    final request = EmergencyRequestModel(
      serviceType: serviceType,
      latitude: lat,
      longitude: lng,
    );

    return remote.createEmergency(request);
  }
}