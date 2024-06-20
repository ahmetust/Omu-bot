class AddQuestionResponse {
  final int userId;
  final String question;
  final String answer;
  final int categoryId;

  AddQuestionResponse({
    required this.userId,
    required this.question,
    required this.answer,
    required this.categoryId,
  });

  factory AddQuestionResponse.fromJson(Map<String, dynamic> json) => AddQuestionResponse(
    userId: json["user_id"],
    question: json["question"],
    answer: json["answer"],
    categoryId: json["category_id"],
  );
}
