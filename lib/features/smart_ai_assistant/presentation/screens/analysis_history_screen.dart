import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';
import '../cubits/smart_assistant_cubit.dart';
import '../cubits/smart_assistant_state.dart';
import 'package:intl/intl.dart';

class AnalysisHistoryScreen extends StatefulWidget {
  const AnalysisHistoryScreen({super.key});

  @override
  State<AnalysisHistoryScreen> createState() => _AnalysisHistoryScreenState();
}

class _AnalysisHistoryScreenState extends State<AnalysisHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SmartAssistantCubit>().loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Analysis History"),
      ),
      body: BlocBuilder<SmartAssistantCubit, SmartAssistantState>(
        builder: (context, state) {
          if (state is SmartAssistantLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SmartAssistantError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }
          if (state is SmartAssistantHistoryLoaded) {
            final history = state.history;
            if (history.isEmpty) {
              return const Center(child: Text("No history available."));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                final date = item.createdAt != null
                    ? DateFormat.yMMMd().add_jm().format(item.createdAt!)
                    : "Unknown Date";

                return Card(
                  elevation: 3,
                  color: Theme.of(context).cardColor,
                  shadowColor: Colors.black26,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      collapsedIconColor: AppColors.primary,
                      iconColor: AppColors.primary,
                      textColor: Theme.of(context).textTheme.bodyLarge?.color,
                      collapsedTextColor:
                          Theme.of(context).textTheme.bodyLarge?.color,
                      title: Text(
                        item.possibleCondition ?? "Unknown Condition",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      subtitle: Text(
                        date,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.7),
                        ),
                      ),
                      leading: const Icon(
                        Icons.history,
                        color: AppColors.primary,
                      ),
                      childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      children: [
                        if (item.medications != null && item.medications!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: item.medications!
                                .map(
                                  (m) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            AppColors.primary.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "• ${m.name} (${m.dose})",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
