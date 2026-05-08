import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';

import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';

class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc()..add(LoadPendingUsers()),
      child: const _AdminRequestsView(),
    );
  }
}

class _AdminRequestsView extends StatelessWidget {
  const _AdminRequestsView();

  void _showUserDetails(BuildContext context, dynamic user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: user.image != null
                        ? NetworkImage(user.image!)
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                _infoTile("Full Name", user.name, context),
                _infoTile("Email", user.email, context),
                _infoTile("Phone", user.phone, context),
                _infoTile("Role", user.role, context),
                _infoTile("ID Number", user.idNumber, context),

                const SizedBox(height: 20),

                if (user.personalIdImage != null) ...[
                  const Text(
                    "Personal ID Image",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://feelinglessly-preocular-xochitl.ngrok-free.dev/storage/${user.personalIdImage}",
                    ),
                  ),
                ],

                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoTile(String title, String? value, dynamic context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Flexible(
            child: Text(
              value ?? "",
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,

      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        title: const Text("Pending Requests"),
      ),

      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminUsersLoaded) {
            if (state.users.isEmpty) {
              return const Center(
                child: Text(
                  "No Pending Users",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];

                return GestureDetector(
                  onTap: () => _showUserDetails(context, user),

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: context.borderColor),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: user.image != null
                                  ? NetworkImage(
                                      "https://feelinglessly-preocular-xochitl.ngrok-free.dev/storage/${user.image}",
                                    )
                                  : null,
                              radius: 22,
                            ),

                            const SizedBox(width: 12),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  user.phone,
                                  style: const TextStyle(color: Colors.white60),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  context.read<AdminBloc>().add(
                                    ApproveUserEvent(user.id),
                                  );

                                  context.read<AdminBloc>().add(
                                    LoadPendingUsers(),
                                  );
                                },
                                child: const Text("Approve"),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                ),
                                onPressed: () async {
                                  context.read<AdminBloc>().add(
                                    RejectUserEvent(user.id),
                                  );

                                  context.read<AdminBloc>().add(
                                    LoadPendingUsers(),
                                  );
                                },
                                child: const Text("Reject"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is AdminError) {
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
}
