// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_collections.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMedicationAdapter extends TypeAdapter<HiveMedication> {
  @override
  final int typeId = 0;

  @override
  HiveMedication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMedication()
      ..name = fields[0] as String?
      ..dose = fields[1] as String?
      ..frequency = fields[2] as String?
      ..duration = fields[3] as String?;
  }

  @override
  void write(BinaryWriter writer, HiveMedication obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dose)
      ..writeByte(2)
      ..write(obj.frequency)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMedicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiveAiResultAdapter extends TypeAdapter<HiveAiResult> {
  @override
  final int typeId = 1;

  @override
  HiveAiResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveAiResult()
      ..possibleCondition = fields[0] as String?
      ..tips = (fields[1] as List?)?.cast<String>()
      ..warnings = (fields[2] as List?)?.cast<String>()
      ..createdAt = fields[3] as DateTime?
      ..medications = (fields[4] as List?)?.cast<HiveMedication>();
  }

  @override
  void write(BinaryWriter writer, HiveAiResult obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.possibleCondition)
      ..writeByte(1)
      ..write(obj.tips)
      ..writeByte(2)
      ..write(obj.warnings)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.medications);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveAiResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
