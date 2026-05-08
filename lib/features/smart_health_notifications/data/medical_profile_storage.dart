import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medical_profile_model.dart';

class MedicalProfileStorage {
  static const String _key = 'medical_profile_data';

  Future<void> saveProfile(MedicalProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(profile.toJson());
    await prefs.setString(_key, jsonString);
  }

  Future<MedicalProfileModel?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString);
        return MedicalProfileModel.fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
