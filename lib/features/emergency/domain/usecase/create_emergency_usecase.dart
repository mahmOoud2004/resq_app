import '../repositories/emergency_repository.dart';

class CreateEmergencyUseCase {
  final EmergencyRepository repository;

  CreateEmergencyUseCase(this.repository);

  Future<void> call({
    required String serviceType,
    required double lat,
    required double lng,
  }) {
    return repository.createEmergency(
      serviceType: serviceType,
      lat: lat,
      lng: lng,
    );
  }
}
