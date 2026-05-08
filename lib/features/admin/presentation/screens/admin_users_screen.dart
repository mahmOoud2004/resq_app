import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';

import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final TextEditingController searchController = TextEditingController();

  List users = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminBloc()..add(LoadAllUsers()),

      child: Scaffold(
        backgroundColor: context.backgroundColor,

        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          title: const Text("Users"),
        ),

        body: BlocBuilder<AdminBloc, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminUsersLoaded) {
              users = state.users;

              final filteredUsers = users.where((user) {
                final name = user.name.toLowerCase();

                final query = searchController.text.toLowerCase();

                return name.contains(query);
              }).toList();

              return Column(
                children: [
                  /// SEARCH
                  Padding(
                    padding: const EdgeInsets.all(16),

                    child: TextField(
                      controller: searchController,

                      onChanged: (value) {
                        setState(() {});
                      },

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: "Search users",

                        hintStyle: const TextStyle(color: Colors.white54),

                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),

                        filled: true,

                        fillColor: context.surfaceColor,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  /// USERS LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,

                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];

                        final approved = user.role == "admin"
                            ? "Admin"
                            : user.role;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),

                          padding: const EdgeInsets.all(14),

                          decoration: BoxDecoration(
                            color: context.surfaceColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: context.borderColor),
                          ),

                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,

                                backgroundImage: user.image != null
                                    ? NetworkImage(
                                        "https://feelinglessly-preocular-xochitl.ngrok-free.dev/storage/${user.image}",
                                      )
                                    : null,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
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
                                      style: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),

                                decoration: BoxDecoration(
                                  color: user.role == "driver"
                                      ? AppColors.accent.withValues(alpha: .18)
                                      : AppColors.success.withValues(
                                          alpha: .18,
                                        ),

                                  borderRadius: BorderRadius.circular(20),
                                ),

                                child: Text(
                                  approved.toUpperCase(),
                                  style: TextStyle(
                                    color: user.role == "driver"
                                        ? AppColors.accent
                                        : AppColors.success,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
      ),
    );
  }
}
