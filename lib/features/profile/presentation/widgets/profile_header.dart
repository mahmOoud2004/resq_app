import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        String name = "";
        String email = "";
        String? image;

        if (state is ProfileLoaded) {
          name = "${state.user.firstName} ${state.user.lastName}";
          email = state.user.email;
          image = state.user.profileImage;
        }

        return Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.primary,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: (image != null && image.isNotEmpty)
                        ? NetworkImage(image)
                        : const AssetImage("assets/images/avatar.png")
                              as ImageProvider,
                  ),
                ),

                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.backgroundColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              name,
              style: TextStyle(
                color: context.textColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              email,
              style: TextStyle(
                color: context.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        );
      },
    );
  }
}
