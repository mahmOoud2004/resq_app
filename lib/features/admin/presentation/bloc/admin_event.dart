abstract class AdminEvent {}

/// Dashboard
class LoadDashboard extends AdminEvent {}

/// Pending Users
class LoadPendingUsers extends AdminEvent {}

/// Approve
class ApproveUserEvent extends AdminEvent {
  final int id;

  ApproveUserEvent(this.id);
}

/// Reject
class RejectUserEvent extends AdminEvent {
  final int id;

  RejectUserEvent(this.id);
}

class LoadAllUsers extends AdminEvent {}

class CancelEmergencyEvent extends AdminEvent {
  final int id;

  CancelEmergencyEvent(this.id);
}
