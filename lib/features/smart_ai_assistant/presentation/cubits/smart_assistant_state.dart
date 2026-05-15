import 'package:equatable/equatable.dart';
import '../../domain/entities/ai_analysis_result.dart';
import '../../data/models/hive_collections.dart';

abstract class SmartAssistantState extends Equatable {
  const SmartAssistantState();

  @override
  List<Object?> get props => [];
}

class SmartAssistantInitial extends SmartAssistantState {}

class SmartAssistantLoading extends SmartAssistantState {
  final String message;
  const SmartAssistantLoading({this.message = "Analyzing..."});
  @override
  List<Object?> get props => [message];
}

class SmartAssistantSuccess extends SmartAssistantState {
  final AiAnalysisResult result;
  const SmartAssistantSuccess(this.result);
  @override
  List<Object?> get props => [result];
}

class SmartAssistantError extends SmartAssistantState {
  final String message;
  const SmartAssistantError(this.message);
  @override
  List<Object?> get props => [message];
}

class SmartAssistantHistoryLoaded extends SmartAssistantState {
  final List<HiveAiResult> history;
  const SmartAssistantHistoryLoaded(this.history);
  @override
  List<Object?> get props => [history];
}
