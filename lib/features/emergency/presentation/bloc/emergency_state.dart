part of 'emergency_bloc.dart';

abstract class EmergencyState {}

class EmergencyInitial extends EmergencyState {}

class EmergencyLoading extends EmergencyState {}

class EmergencySuccess extends EmergencyState {}

class EmergencyError extends EmergencyState {
  final String message;

  EmergencyError(this.message);
}
