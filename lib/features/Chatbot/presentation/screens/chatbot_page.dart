import 'package:flutter/material.dart';
import 'package:resq_app/core/theme/theme_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:resq_app/core/constants/app_color.dart';

import '../../data/datasource/chatbot_remote_datasource.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/chatbot_response_model.dart';

import '../widgets/chat_bubble.dart';
import '../widgets/dispatch_button.dart';

import '../../../emergency/presentation/bloc/emergency_bloc.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

  final chatbotService = ChatbotRemoteDatasource(Dio());

  List<ChatMessageModel> messages = [];

  Map<String, dynamic>? emergencyData;

  void sendMessage() async {
    if (controller.text.isEmpty) return;

    final text = controller.text;

    setState(() {
      messages.add(ChatMessageModel(text: text, isUser: true));
    });

    controller.clear();

    ChatbotResponseModel response = await chatbotService.sendMessage(
      userId: "1",
      message: text,
      lat: 30.0444,
      lng: 31.2357,
    );

    print("=========== PARSED RESPONSE ===========");
    print("Bot Response: ${response.botResponse}");
    print("Is Dispatched: ${response.isDispatched}");
    print("Emergency Data: ${response.dispatchData}");
    print("=======================================");

    setState(() {
      messages.add(ChatMessageModel(text: response.botResponse, isUser: false));

      if (response.isDispatched) {
        emergencyData = response.dispatchData;
      }
    });
  }

  void sendEmergency() {
    if (emergencyData == null) return;

    context.read<EmergencyBloc>().add(
      SendEmergencyEvent(serviceType: "ambulance", lat: 30.0444, lng: 31.2357),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Emergency request sent")));

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

          /// زر الطوارئ يظهر هنا
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
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
