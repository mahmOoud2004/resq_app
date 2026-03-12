abstract class EmergencyRepository {
  Future<void> createEmergency({
    required String serviceType,
    required double lat,
    required double lng,
  });
}
