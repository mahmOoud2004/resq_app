import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:resq_app/core/theme/theme_cubit.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final darkMode = themeMode == ThemeMode.dark;

        return Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: context.surfaceLightColor,

            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: context.borderColor),
          ),

          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: context.borderColor.withOpacity(0.75),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(
                  darkMode ? Icons.dark_mode : Icons.light_mode,

                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Theme",

                      style: TextStyle(
                        color: context.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      "Switch between dark and light mode",

                      style: TextStyle(
                        color: context.textSecondaryColor,

                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Switch(
                value: darkMode,

                onChanged: (v) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
