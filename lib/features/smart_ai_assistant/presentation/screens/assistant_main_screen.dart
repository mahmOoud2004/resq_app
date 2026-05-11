import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/config/routers/route_names.dart';
import '../cubits/smart_assistant_cubit.dart';
import '../cubits/smart_assistant_state.dart';

class SmartAssistantMainScreen extends StatefulWidget {
  const SmartAssistantMainScreen({super.key});

  @override
  State<SmartAssistantMainScreen> createState() => _SmartAssistantMainScreenState();
}

class _SmartAssistantMainScreenState extends State<SmartAssistantMainScreen> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      if (mounted) {
        context.read<SmartAssistantCubit>().analyzeImage(File(image.path));
      }
    }
  }

  void _analyzeText() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<SmartAssistantCubit>().analyzeText(text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter some text or symptoms")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Medical Assistant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push(Routes.analysisHistory),
          )
        ],
      ),
      body: BlocConsumer<SmartAssistantCubit, SmartAssistantState>(
        listener: (context, state) {
          if (state is SmartAssistantSuccess) {
            context.push(Routes.smartAssistantResult, extra: state.result);
          } else if (state is SmartAssistantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is SmartAssistantLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(state.message, style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Upload a Prescription",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Camera"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Gallery"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Center(child: Text("OR", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                const SizedBox(height: 32),
                const Text(
                  "Describe your symptoms / medicines",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _textController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: "E.g., I have a headache and fever. I take Panadol 500mg every 8 hours.",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _analyzeText,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Analyze with AI", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
