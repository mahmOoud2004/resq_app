abstract class AdminRepository {
  Future getStats();

  Future getPendingUsers();

  Future approveUser(int id);

  Future blockUser(int id);

  Future getEmergencies();

  Future cancelEmergency(int id);
}
