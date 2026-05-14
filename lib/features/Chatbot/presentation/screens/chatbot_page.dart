import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_app/core/constants/app_color.dart';
import 'package:resq_app/core/error/error_handler.dart';
import 'package:resq_app/core/theme/theme_ext.dart';

import '../../../emergency/presentation/bloc/emergency_bloc.dart';
import '../../data/datasource/chatbot_remote_datasource.dart';
import '../../data/models/chat_message_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/dispatch_button.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  final chatbotService = ChatbotRemoteDatasource(Dio());

  final List<ChatMessageModel> messages = [];
  Map<String, dynamic>? emergencyData;
  bool isSending = false;

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty || isSending) return;

    setState(() {
      isSending = true;
      messages.add(ChatMessageModel(text: text, isUser: true));
    });

    controller.clear();

    try {
      final response = await chatbotService.sendMessage(
        userId: "1",
        message: text,
        lat: 30.0444,
        lng: 31.2357,
      );

      if (!mounted) return;
      setState(() {
        messages
            .add(ChatMessageModel(text: response.botResponse, isUser: false));
        emergencyData = response.isDispatched ? response.dispatchData : null;
      });
    } catch (error, stackTrace) {
      final appException = ErrorHandler.handle(error, stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        messages.add(
          ChatMessageModel(
            text: appException.userMessage,
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  void sendEmergency() {
    if (emergencyData == null) return;

    context.read<EmergencyBloc>().add(
          SendEmergencyEvent(
              serviceType: "ambulance", lat: 30.0444, lng: 31.2357),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Emergency request sent")),
    );

    setState(() {
      emergencyData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        title: const Text("ResQ Assistant"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ChatBubble(message: msg.text, isUser: msg.isUser);
              },
            ),
          ),
          if (emergencyData != null) DispatchButton(onTap: sendEmergency),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              border: Border(top: BorderSide(color: context.borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Describe your emergency...",
                      hintStyle: TextStyle(color: context.textSecondaryColor),
                      filled: true,
                      fillColor: context.surfaceLightColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                  onPressed: isSending ? null : sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
