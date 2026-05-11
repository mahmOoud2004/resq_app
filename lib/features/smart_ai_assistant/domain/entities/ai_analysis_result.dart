import 'package:equatable/equatable.dart';

class AiAnalysisResult extends Equatable {
  final List<MedicationEntity> medications;
  final String possibleCondition;
  final List<String> tips;
  final List<String> warnings;

  const AiAnalysisResult({
    required this.medications,
    required this.possibleCondition,
    required this.tips,
    required this.warnings,
  });

  @override
  List<Object?> get props => [medications, possibleCondition, tips, warnings];
}

class MedicationEntity extends Equatable {
  final String name;
  final String dose;
  final String frequency;
  final String duration;

  const MedicationEntity({
    required this.name,
    required this.dose,
    required this.frequency,
    required this.duration,
  });

  @override
  List<Object?> get props => [name, dose, frequency, duration];
}
