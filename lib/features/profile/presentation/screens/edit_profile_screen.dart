import 'package:resq_app/core/theme/theme_ext.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/features/profile/presentation/edit_profile/edit_profile_bloc.dart';
import 'package:resq_app/features/profile/presentation/edit_profile/edit_profile_event.dart';
import 'package:resq_app/features/profile/presentation/edit_profile/edit_profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  File? image;

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,

      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        title: const Text("Edit Profile"),
      ),

      body: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Profile Updated")));

            Navigator.pop(context);
          }

          if (state is EditProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                /// IMAGE
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primary,
                    backgroundImage: image != null ? FileImage(image!) : null,
                    child: image == null
                        ? const Icon(Icons.camera_alt, color: Colors.white)
                        : null,
                  ),
                ),

                const SizedBox(height: 30),

                _field("Phone", phoneController),

                const SizedBox(height: 20),

                _field("Password", passwordController),

                const SizedBox(height: 20),

                _field("Confirm Password", confirmPasswordController),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () {
                      context.read<EditProfileBloc>().add(
                        UpdateProfileEvent(
                          phone: phoneController.text,
                          password: passwordController.text,
                          confirmPassword: confirmPasswordController.text,
                          image: image,
                        ),
                      );
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    child: state is EditProfileLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Update Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _field(String title, TextEditingController controller) {
    return TextField(
      controller: controller,

      style: const TextStyle(color: Colors.white),

      decoration: InputDecoration(
        labelText: title,

        labelStyle: TextStyle(color: context.textSecondaryColor),

        filled: true,
        fillColor: context.surfaceLightColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
