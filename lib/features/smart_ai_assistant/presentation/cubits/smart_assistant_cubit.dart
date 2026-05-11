import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/smart_assistant_repository.dart';
import 'smart_assistant_state.dart';

class SmartAssistantCubit extends Cubit<SmartAssistantState> {
  final SmartAssistantRepository repository;

  SmartAssistantCubit(this.repository) : super(SmartAssistantInitial());

  Future<void> analyzeImage(File imageFile) async {
    emit(const SmartAssistantLoading(
        message: "Processing image & analyzing with AI..."));
    try {
      final result = await repository.analyzePrescriptionImage(imageFile);
      emit(SmartAssistantSuccess(result));
    } catch (e) {
      emit(SmartAssistantError("Failed to analyze image: $e"));
    }
  }

  Future<void> analyzeText(String text) async {
    emit(const SmartAssistantLoading(message: "Analyzing text with AI..."));
    try {
      final result = await repository.analyzeText(text);
      emit(SmartAssistantSuccess(result));
    } catch (e) {
      emit(SmartAssistantError("Failed to analyze text: $e"));
    }
  }

  Future<void> loadHistory() async {
    emit(const SmartAssistantLoading(message: "Loading history..."));
    try {
      final history = await repository.getHistory();
      emit(SmartAssistantHistoryLoaded(history));
    } catch (e) {
      emit(SmartAssistantError("Failed to load history: $e"));
    }
  }
}
