part of 'emergency_bloc.dart';

abstract class EmergencyState {}

class EmergencyInitial extends EmergencyState {}

class EmergencyLoading extends EmergencyState {}

class EmergencyHasActiveRequest extends EmergencyState {
  final ActiveRequestModel request;

  EmergencyHasActiveRequest(this.request);
}

class EmergencyError extends EmergencyState {
  final String message;

  EmergencyError(this.message);
}

class EmergencyCompleted extends EmergencyState {}
