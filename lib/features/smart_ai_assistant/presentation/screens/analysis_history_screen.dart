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
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
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
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(item.possibleCondition ?? "Unknown Condition", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(date),
                    leading: const Icon(Icons.history, color: AppColors.primary),
                    children: [
                      if (item.medications.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: item.medications.map((m) => Text("• \${m.name} (\${m.dose})")).toList(),
                          ),
                        ),
                    ],
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
