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
    final rawDispatchData = json["dispatch_data"];
    return ChatbotResponseModel(
      isDispatched: json["is_dispatched"] == true,
      botResponse: json["bot_response"]?.toString() ?? "",
      dispatchData:
          rawDispatchData is Map ? Map<String, dynamic>.from(rawDispatchData) : null,
    );
  }
}
