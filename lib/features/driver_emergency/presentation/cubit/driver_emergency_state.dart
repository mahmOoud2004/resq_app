import '../../data/models/driver_request_model.dart';

abstract class DriverEmergencyState {
  final bool isOnline;

  const DriverEmergencyState({required this.isOnline});
}

class DriverEmergencyInitial extends DriverEmergencyState {
  const DriverEmergencyInitial({required super.isOnline});
}

class DriverEmergencyLoading extends DriverEmergencyState {
  const DriverEmergencyLoading({required super.isOnline});
}

class DriverEmergencyLoaded extends DriverEmergencyState {
  final List<DriverRequestModel> requests;

  const DriverEmergencyLoaded(
    this.requests, {
    required super.isOnline,
  });
}

class DriverEmergencyError extends DriverEmergencyState {
  final String? message;

  const DriverEmergencyError({
    required super.isOnline,
    this.message,
  });
}
