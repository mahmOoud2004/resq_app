import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:resq_app/features/smart_health_notifications/data/medical_profile_storage.dart';
import 'package:resq_app/features/smart_health_notifications/models/medical_profile_model.dart';
import 'package:resq_app/features/smart_health_notifications/services/notification_manager.dart';

class MedicalInformationScreen extends StatefulWidget {
  const MedicalInformationScreen({super.key});

  @override
  State<MedicalInformationScreen> createState() =>
      _MedicalInformationScreenState();
}

class _MedicalInformationScreenState extends State<MedicalInformationScreen> {
  final MedicalProfileStorage _storage = MedicalProfileStorage();

  final List<String> _availableDiseases = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Heart Disease',
    'Epilepsy',
    'Kidney Disease',
    'Obesity',
    'Anemia',
  ];

  List<String> _selectedDiseases = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _storage.getProfile();

    if (profile != null) {
      setState(() {
        _selectedDiseases = profile.diseases;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    final profile = MedicalProfileModel(diseases: _selectedDiseases);

    await _storage.saveProfile(profile);

    await NotificationManager().setupNotifications();

    if (!mounted) return;

    if (Navigator.canPop(context)) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ وتحديث الإشعارات بنجاح ✅')),
      );
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,

        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,

      appBar: AppBar(
        title: Text('الملف الطبي', style: TextStyle(color: context.textColor)),

        backgroundColor: context.backgroundColor,

        elevation: 0,

        iconTheme: IconThemeData(color: context.textColor),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'اختر حالتك الصحية للحصول على إشعارات ونصائح مناسبة لك',

                style: TextStyle(
                  color: context.textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'سيقوم التطبيق بإرسال تنبيهات صحية ذكية ونصائح يومية بناءً على حالتك الطبية.',

                style: TextStyle(
                  color: context.textSecondaryColor,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  itemCount: _availableDiseases.length,

                  itemBuilder: (context, index) {
                    final disease = _availableDiseases[index];

                    final isSelected = _selectedDiseases.contains(disease);

                    IconData icon;
                    String title;
                    String subtitle;

                    switch (disease) {
                      case 'Diabetes':
                        icon = Icons.bloodtype;
                        title = 'السكري';
                        subtitle = 'متابعة السكر والتنبيهات الغذائية';
                        break;

                      case 'Hypertension':
                        icon = Icons.favorite;
                        title = 'ضغط الدم';
                        subtitle = 'تنبيهات ضغط الدم والأدوية';
                        break;

                      case 'Asthma':
                        icon = Icons.air;
                        title = 'الربو';
                        subtitle = 'نصائح التنفس والحساسية';
                        break;

                      case 'Heart Disease':
                        icon = Icons.monitor_heart;
                        title = 'أمراض القلب';
                        subtitle = 'تنبيهات صحية للقلب';
                        break;

                      case 'Epilepsy':
                        icon = Icons.psychology;
                        title = 'الصرع';
                        subtitle = 'متابعة النوبات والأدوية';
                        break;

                      case 'Kidney Disease':
                        icon = Icons.water_drop;
                        title = 'أمراض الكلى';
                        subtitle = 'متابعة المياه والعلاج';
                        break;

                      case 'Obesity':
                        icon = Icons.fitness_center;
                        title = 'السمنة';
                        subtitle = 'نصائح رياضية وغذائية';
                        break;

                      default:
                        icon = Icons.health_and_safety;
                        title = 'الأنيميا';
                        subtitle = 'متابعة الحديد والتغذية';
                    }

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),

                      margin: const EdgeInsets.only(bottom: 14),

                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(.15)
                            : context.surfaceColor,

                        borderRadius: BorderRadius.circular(18),

                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : context.borderColor,

                          width: 1.4,
                        ),
                      ),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),

                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedDiseases.remove(disease);
                            } else {
                              _selectedDiseases.add(disease);
                            }
                          });
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,

                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(.12),

                                  borderRadius: BorderRadius.circular(16),
                                ),

                                child: Icon(
                                  icon,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      title,

                                      style: TextStyle(
                                        color: context.textColor,

                                        fontSize: 16,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      subtitle,

                                      style: TextStyle(
                                        color: context.textSecondaryColor,

                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),

                                width: 26,
                                height: 26,

                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,

                                  shape: BoxShape.circle,

                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : context.borderColor,
                                  ),
                                ),

                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  onPressed: _saveProfile,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'حفظ الإعدادات',

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,

                child: OutlinedButton(
                  onPressed: () async {
                    await NotificationManager().showTestNotification();
                  },

                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'تجربة إشعار سريع',

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
