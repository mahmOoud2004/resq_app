import '../../data/models/admin_stats_model.dart';
import '../../data/models/emergency_model.dart';
import '../../data/models/pending_user_model.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

/// Dashboard State
class AdminDashboardLoaded extends AdminState {
  final AdminStatsModel stats;
  final List<EmergencyModel> emergencies;

  AdminDashboardLoaded({required this.stats, required this.emergencies});
}

/// Pending Users
class AdminUsersLoaded extends AdminState {
  final List<PendingUserModel> users;

  AdminUsersLoaded(this.users);
}

/// Error
class AdminError extends AdminState {
  final String message;

  AdminError(this.message);
}
