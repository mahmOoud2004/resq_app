import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:resq_app/features/Chatbot/data/datasource/chatbot_remote_datasource.dart';
import 'package:resq_app/features/Chatbot/data/models/chat_message_model.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final ChatbotRemoteDataSource chatbotService = ChatbotRemoteDataSource(Dio());

  final List<Map<String, dynamic>> messages = [];

  void sendMessage() async {
    if (controller.text.isEmpty) return;

    final userMessage = controller.text;

    setState(() {
      messages.add({"text": userMessage, "isUser": true, "time": "Now"});
    });

    controller.clear();

    try {
      ChatbotResponseModel response = await chatbotService.sendMessage(
        userId: "1",
        message: userMessage,
        lat: 30.044420,
        lng: 31.235712,
      );

      setState(() {
        messages.add({
          "text": response.botResponse,
          "isUser": false,
          "time": "Now",
        });
      });

      /// لو الطلب اتبعت
      if (response.isDispatched == true) {
        final dispatchData = response.dispatchData;

        print("Emergency Request Data:");
        print(dispatchData);

        /// هنا تقدر تبعت الطلب ل feature الطوارئ
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      setState(() {
        messages.add({
          "text": "Something went wrong",
          "isUser": false,
          "time": "Now",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B1A2B),
      appBar: AppBar(
        backgroundColor: const Color(0xff0B1A2B),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
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

                return Align(
                  alignment: msg["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: msg["isUser"]
                          ? Colors.blue
                          : const Color(0xff1E2C3F),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg["text"],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          /// Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Color(0xff132338)),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Describe your situation...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xff1E2C3F),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
