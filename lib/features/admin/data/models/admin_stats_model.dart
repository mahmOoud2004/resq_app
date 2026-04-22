class AdminStatsModel {
  final int totalUsers;
  final int totalDrivers;
  final int pendingUsers;
  final int activeEmergencies;
  final int completedEmergencies;
  final int todayRequests;

  AdminStatsModel({
    required this.totalUsers,
    required this.totalDrivers,
    required this.pendingUsers,
    required this.activeEmergencies,
    required this.completedEmergencies,
    required this.todayRequests,
  });

  factory AdminStatsModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return AdminStatsModel(
      totalUsers: data["total_users"],
      totalDrivers: data["total_drivers"],
      pendingUsers: data["pending_users"],
      activeEmergencies: data["active_emergencies"],
      completedEmergencies: data["completed_emergencies"],
      todayRequests: data["today_requests"],
    );
  }
}
