import 'dart:io';
import '../../domain/entities/ai_analysis_result.dart';
import '../../data/models/hive_collections.dart';

abstract class SmartAssistantRepository {
  Future<AiAnalysisResult> analyzePrescriptionImage(File imageFile);
  Future<AiAnalysisResult> analyzeText(String text);
  Future<List<HiveAiResult>> getHistory();
  Future<HiveAiResult?> getLatestResult();
}
