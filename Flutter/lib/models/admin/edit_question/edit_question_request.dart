class EditQuestionRequest {
  final int messageId;
  final String question;
  final String answer;
  final int categoryId;

  EditQuestionRequest({
    required this.messageId,
    required this.question,
    required this.answer,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() => {
    'message_id': messageId,
    'question': question,
    'answer': answer,
    'category_id': categoryId,
  };
}
