import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resq_app/features/smart_ai_assistant/data/models/isar_collections.dart';

class IsarLocalDataSource {
  late Isar _isar;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([
      IsarMedicationSchema,
      IsarAiResultSchema,
    ], directory: dir.path);
    _isInitialized = true;
  }

  Future<void> saveAiResult(
    IsarAiResult result,
    List<IsarMedication> medications,
  ) async {
    await init();
    await _isar.writeTxn(() async {
      await _isar.isarMedications.putAll(medications);
      result.createdAt = DateTime.now();
      await _isar.isarAiResults.put(result);
      result.medications.addAll(medications);
      await result.medications.save();
    });
  }

  Future<List<IsarAiResult>> getHistory() async {
    await init();
    return await _isar.isarAiResults.where().sortByCreatedAtDesc().findAll();
  }

  Future<IsarAiResult?> getLatestResult() async {
    await init();
    final results = await _isar.isarAiResults
        .where()
        .sortByCreatedAtDesc()
        .limit(1)
        .findAll();
    if (results.isNotEmpty) {
      // Need to load links
      final res = results.first;
      await res.medications.load();
      return res;
    }
    return null;
  }
}
