class ChatbotResponseModel {
  final bool isDispatched;
  final String botResponse;
  final Map<String, dynamic>? dispatchData;

  ChatbotResponseModel({
    required this.isDispatched,
    required this.botResponse,
    this.dispatchData,
  });

  factory ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    print("JSON KEYS:");
    print(json.keys);

    return ChatbotResponseModel(
      isDispatched: json["is_dispatched"] ?? false,
      botResponse: json["bot_response"] ?? "",
      dispatchData: json["dispatch_data"], // هنا التعديل
    );
  }
}
