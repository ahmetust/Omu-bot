class MessageListRequestModel {
  final String question;
  final String answer;
  final String category;
  final int userId;

  MessageListRequestModel({required this.question, required this.answer, required this.category, required this.userId});

  factory MessageListRequestModel.fromJson(Map<String, dynamic> json) {
    return MessageListRequestModel(
      question: json['question'],
      answer: json['answer'],
      category: json['category_name'],
      userId: json['user_id']
    );
  }
}
