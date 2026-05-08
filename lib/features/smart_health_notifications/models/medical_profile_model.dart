class MedicalProfileModel {
  final List<String> diseases;
  final String? bloodType;
  final String? allergies;
  final String? medications;
  final String? emergencyContact;

  MedicalProfileModel({
    required this.diseases,
    this.bloodType,
    this.allergies,
    this.medications,
    this.emergencyContact,
  });

  factory MedicalProfileModel.fromJson(Map<String, dynamic> json) {
    return MedicalProfileModel(
      diseases: List<String>.from(json['diseases'] ?? []),
      bloodType: json['bloodType'],
      allergies: json['allergies'],
      medications: json['medications'],
      emergencyContact: json['emergencyContact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseases': diseases,
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'emergencyContact': emergencyContact,
    };
  }
}
