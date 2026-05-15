import 'package:hive/hive.dart';

part 'hive_collections.g.dart';

@HiveType(typeId: 0)
class HiveMedication extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? dose;

  @HiveField(2)
  String? frequency;

  @HiveField(3)
  String? duration;
}

@HiveType(typeId: 1)
class HiveAiResult extends HiveObject {
  @HiveField(0)
  String? possibleCondition;

  @HiveField(1)
  List<String>? tips = [];

  @HiveField(2)
  List<String>? warnings = [];

  @HiveField(3)
  DateTime? createdAt;

  @HiveField(4)
  List<HiveMedication>? medications = [];
}
