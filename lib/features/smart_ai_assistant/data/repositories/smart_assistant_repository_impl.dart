import 'dart:io';
import 'dart:convert';
import '../../domain/entities/ai_analysis_result.dart';
import '../../domain/repositories/smart_assistant_repository.dart';
import '../datasources/gemini_remote_datasource.dart';
import '../datasources/ocr_local_datasource.dart';
import '../datasources/hive_local_datasource.dart';
import '../../services/json_cleaner_service.dart';
import '../../services/image_compress_service.dart';
import '../models/hive_collections.dart';

class SmartAssistantRepositoryImpl implements SmartAssistantRepository {
  final GeminiRemoteDataSource geminiRemoteDataSource;
  final OcrLocalDataSource ocrLocalDataSource;
  final HiveLocalDataSource hiveLocalDataSource;

  SmartAssistantRepositoryImpl({
    required this.geminiRemoteDataSource,
    required this.ocrLocalDataSource,
    required this.hiveLocalDataSource,
  });

  @override
  Future<AiAnalysisResult> analyzePrescriptionImage(File imageFile) async {
    // 1. Compress Image
    final compressedImage = await ImageCompressService.compressImage(imageFile);
    final fileToProcess = compressedImage ?? imageFile;

    // 2. OCR Extraction
    final extractedText = await ocrLocalDataSource.recognizeText(fileToProcess);
    
    // 3. Gemini Analysis
    return await analyzeText(extractedText);
  }

  @override
  Future<AiAnalysisResult> analyzeText(String text) async {
    // 1. Gemini Analysis
    final rawJson = await geminiRemoteDataSource.analyzeText(text);

    // 2. Clean JSON
    final cleanJson = JsonCleanerService.clean(rawJson);

    // 3. Parse JSON
    final Map<String, dynamic> data = json.decode(cleanJson);
    
    final List<dynamic> rawMeds = data['medications'] ?? [];
    final List<MedicationEntity> meds = rawMeds.map((m) => MedicationEntity(
      name: m['name'] ?? '',
      dose: m['dose'] ?? '',
      frequency: m['frequency'] ?? '',
      duration: m['duration'] ?? '',
    )).toList();

    final result = AiAnalysisResult(
      medications: meds,
      possibleCondition: data['possible_condition'] ?? 'Unknown',
      tips: List<String>.from(data['tips'] ?? []),
      warnings: List<String>.from(data['warnings'] ?? []),
    );

    // 4. Save to Local Cache (Hive)
    final hiveResult = HiveAiResult()
      ..possibleCondition = result.possibleCondition
      ..tips = result.tips
      ..warnings = result.warnings;
    
    final hiveMeds = meds.map((m) => HiveMedication()
      ..name = m.name
      ..dose = m.dose
      ..frequency = m.frequency
      ..duration = m.duration
    ).toList();

    await hiveLocalDataSource.saveAiResult(hiveResult, hiveMeds);

    return result;
  }

  @override
  Future<List<HiveAiResult>> getHistory() async {
    return await hiveLocalDataSource.getHistory();
  }

  @override
  Future<HiveAiResult?> getLatestResult() async {
    return await hiveLocalDataSource.getLatestResult();
  }
}
