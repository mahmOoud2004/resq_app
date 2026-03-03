import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_app/core/constants/app_color.dart';

class IdUploadField extends StatefulWidget {
  final Function(File image) onImageSelected;

  const IdUploadField({super.key, required this.onImageSelected});

  @override
  State<IdUploadField> createState() => _IdUploadFieldState();
}

class _IdUploadFieldState extends State<IdUploadField> {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(
      imageQuality: 70,
      maxWidth: 1024,
      source: ImageSource.gallery,
    );

    if (image != null) {
      final file = File(image.path);

      setState(() {
        selectedImage = file;
      });

      /// 🔥 نرجع الصورة للـ signup
      widget.onImageSelected(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.fieldColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: selectedImage == null
            ? const Center(child: Text("Upload your personal ID"))
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
      ),
    );
  }
}
