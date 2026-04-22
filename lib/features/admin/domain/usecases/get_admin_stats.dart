import '../repositories/admin_repository.dart';

class GetAdminStats {
  final AdminRepository repository;

  GetAdminStats(this.repository);

  Future call() {
    return repository.getStats();
  }
}
