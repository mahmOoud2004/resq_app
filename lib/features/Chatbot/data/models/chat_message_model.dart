class ChatbotResponseModel {
  final String botResponse;
  final String sessionId;
  final bool isDispatched;
  final Map<String, dynamic>? dispatchData;

  ChatbotResponseModel({
    required this.botResponse,
    required this.sessionId,
    required this.isDispatched,
    this.dispatchData,
  });

  factory ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatbotResponseModel(
      botResponse: json['bot_response'],
      sessionId: json['session_id'],
      isDispatched: json['is_dispatched'],
      dispatchData: json['dispatch_data'],
    );
  }
}
