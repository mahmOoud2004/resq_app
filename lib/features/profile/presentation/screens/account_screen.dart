import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:resq_app/config/routers/route_names.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_state.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileBloc bloc = GoRouterState.of(context).extra as ProfileBloc;

    return BlocProvider.value(value: bloc, child: const _AccountBody());
  }
}

class _AccountBody extends StatelessWidget {
  const _AccountBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07142A),

      appBar: AppBar(
        title: const Text("Account", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF07142A),
        elevation: 0,
      ),

      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  /// Avatar + Name + Email
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFF2563EB),

                          child: CircleAvatar(
                            radius: 40,

                            backgroundImage:
                                (user.profileImage != null &&
                                    user.profileImage!.isNotEmpty)
                                ? NetworkImage(user.profileImage!)
                                : const AssetImage("assets/images/avatar.png")
                                      as ImageProvider,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "${user.firstName} ${user.lastName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user.email,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Personal Information Card
                  Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: const Color(0xFF13294B),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      children: [
                        _infoRow("First Name", user.firstName),
                        const Divider(color: Colors.white12),

                        _infoRow("Last Name", user.lastName),
                        const Divider(color: Colors.white12),

                        _infoRow("Phone", user.phone),
                        const Divider(color: Colors.white12),

                        _infoRow("Email", user.email),
                        const Divider(color: Colors.white12),

                        _infoRow("National ID", user.nationalId),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// ID Card Section
                  const Text(
                    "ID Card",
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    height: 170,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      color: const Color(0xFF13294B),
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child:
                        (user.idCardImage == null || user.idCardImage!.isEmpty)
                        ? const Center(
                            child: Icon(
                              Icons.image,
                              color: Colors.white38,
                              size: 40,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),

                            child: Image.network(
                              user.idCardImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),

                  const SizedBox(height: 30),

                  /// Edit Button
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: () {
                        context.push(Routes.editProfile);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),

                        padding: const EdgeInsets.symmetric(vertical: 16),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),

                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          }

          if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title, style: const TextStyle(color: Colors.white54)),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
