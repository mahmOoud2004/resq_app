import 'package:hive_flutter/hive_flutter.dart';
import 'package:resq_app/features/smart_ai_assistant/data/models/hive_collections.dart';

class HiveLocalDataSource {
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveMedicationAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(HiveAiResultAdapter());
    }

    await Hive.openBox<HiveAiResult>('ai_results');

    _isInitialized = true;
  }

  Future<void> saveAiResult(
    HiveAiResult result,
    List<HiveMedication> medications,
  ) async {
    await init();
    
    result.createdAt = DateTime.now();
    result.medications = medications;

    final box = Hive.box<HiveAiResult>('ai_results');
    await box.add(result);
  }

  Future<List<HiveAiResult>> getHistory() async {
    await init();

    final box = Hive.box<HiveAiResult>('ai_results');
    final results = box.values.toList();
    
    // Sort by createdAt descending
    results.sort((a, b) {
      final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return dateB.compareTo(dateA);
    });

    return results;
  }

  Future<HiveAiResult?> getLatestResult() async {
    final history = await getHistory();
    if (history.isNotEmpty) {
      return history.first;
    }
    return null;
  }
}
