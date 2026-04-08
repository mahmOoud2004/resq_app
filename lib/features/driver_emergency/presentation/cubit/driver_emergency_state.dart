import '../../data/models/driver_request_model.dart';

abstract class DriverEmergencyState {}

class DriverEmergencyInitial extends DriverEmergencyState {}

class DriverEmergencyLoading extends DriverEmergencyState {}

class DriverEmergencyLoaded extends DriverEmergencyState {
  final List<DriverRequestModel> requests;

  DriverEmergencyLoaded(this.requests);
}

class DriverEmergencyError extends DriverEmergencyState {}
