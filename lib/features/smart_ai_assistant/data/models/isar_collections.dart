import 'package:isar/isar.dart';

part 'isar_collections.g.dart';

@collection
class IsarMedication {
  Id id = Isar.autoIncrement;

  String? name;
  String? dose;
  String? frequency;
  String? duration;
}

@collection
class IsarAiResult {
  Id id = Isar.autoIncrement;

  String? possibleCondition;

  List<String>? tips = [];

  List<String>? warnings = [];

  DateTime? createdAt = DateTime.now();

  final medications = IsarLinks<IsarMedication>();
}
