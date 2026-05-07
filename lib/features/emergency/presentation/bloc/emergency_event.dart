part of 'emergency_bloc.dart';

abstract class EmergencyEvent {}

class SendEmergencyEvent extends EmergencyEvent {
  final String serviceType;
  final double lat;
  final double lng;

  SendEmergencyEvent({
    required this.serviceType,
    required this.lat,
    required this.lng,
  });
}

class GetActiveRequestEvent extends EmergencyEvent {}
