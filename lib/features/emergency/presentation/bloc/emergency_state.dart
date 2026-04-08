part of 'emergency_bloc.dart';

abstract class EmergencyState {}

class EmergencyInitial extends EmergencyState {}

class EmergencyLoading extends EmergencyState {}

class EmergencyActive extends EmergencyState {
  final String serviceType;

  EmergencyActive(this.serviceType);
}

class EmergencyError extends EmergencyState {
  final String message;

  EmergencyError(this.message);
}
