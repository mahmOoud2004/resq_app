
// Test refactor script
import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  final replacements = {
    'AppColors.background': 'context.backgroundColor',
    'AppColors.surfaceLight': 'context.surfaceLightColor',
    'AppColors.surface': 'context.surfaceColor',
    'AppColors.border': 'context.borderColor',
    'AppColors.textSecondary': 'context.textSecondaryColor',
    'AppColors.textMuted': 'context.textMutedColor',
    'AppColors.textPrimary': 'context.textColor',
    'AppColors.fieldColor': 'context.fieldColor',
  };

  await for (var entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final fileName = entity.path.split(Platform.pathSeparator).last;
      if (fileName == 'app_color.dart' || 
          fileName == 'app_theme.dart' || 
          fileName == 'theme_ext.dart' || 
          fileName == 'refactor.dart' ||
          fileName == 'main.dart') {
        continue;
      }

      String content = await entity.readAsString();
      bool hasChanges = false;
      
      replacements.forEach((oldStr, newStr) {
        if (content.contains(oldStr)) {
          content = content.replaceAll(oldStr, newStr);
          hasChanges = true;
        }
      });

      if (hasChanges) {
        if (!content.contains('package:resq_app/core/theme/theme_ext.dart')) {
          final importRegex = RegExp(r'import\s+.*?;\n');
          final match = importRegex.firstMatch(content);
          if (match != null) {
            content = content.replaceRange(match.end, match.end, "import 'package:resq_app/core/theme/theme_ext.dart';\n");
          } else {
            content = "import 'package:resq_app/core/theme/theme_ext.dart';\n" + content;
          }
        }
        await entity.writeAsString(content);
        print('Updated \${entity.path}');
      }
    }
  }
  print('Done!');
}
