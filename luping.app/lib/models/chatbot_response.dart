class ChatbotSentence {
  final String sentence;
  final String pinyin;
  final String meaningVN;

  ChatbotSentence({
    required this.sentence,
    required this.pinyin,
    required this.meaningVN,
  });

  factory ChatbotSentence.fromJson(Map<String, dynamic> json) {
    return ChatbotSentence(
      sentence: json['sentence'],
      pinyin: json['pinyin'],
      meaningVN: json['meaning_VN'],
    );
  }
}

class ChatbotResponse {
  final List<ChatbotSentence> responseSentences;
  final String comment;
  final List<ChatbotSentence> suggestedSentences;

  ChatbotResponse({
    required this.responseSentences,
    required this.comment,
    required this.suggestedSentences,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      responseSentences: (json['response_sentences'] as List)
          .map((item) => ChatbotSentence.fromJson(item))
          .toList(),
      comment: json['comment'] ?? "",
      suggestedSentences: (json['suggested_sentences'] as List)
          .map((item) => ChatbotSentence.fromJson(item))
          .toList(),
    );
  }
}
