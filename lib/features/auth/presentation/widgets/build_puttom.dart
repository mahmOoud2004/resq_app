import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter/material.dart';
import 'package:resq_app/core/constants/app_color.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isLoading ? null : onTap,
        child: Ink(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isLoading
                  ? [context.textMutedColor, context.textMutedColor]
                  : const [AppColors.gradient1, AppColors.gradient2],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (!isLoading)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
