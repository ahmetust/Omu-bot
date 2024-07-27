class AddQuestionRequest {
  final int userId;
  final String question;
  final String answer;
  final int categoryId;

  AddQuestionRequest({
    required this.userId,
    required this.question,
    required this.answer,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'question': question,
    'answer': answer,
    'category_id': categoryId,
  };
}
