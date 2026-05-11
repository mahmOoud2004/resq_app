import 'dart:io';
import '../../domain/entities/ai_analysis_result.dart';
import '../../data/models/isar_collections.dart';

abstract class SmartAssistantRepository {
  Future<AiAnalysisResult> analyzePrescriptionImage(File imageFile);
  Future<AiAnalysisResult> analyzeText(String text);
  Future<List<IsarAiResult>> getHistory();
  Future<IsarAiResult?> getLatestResult();
}
