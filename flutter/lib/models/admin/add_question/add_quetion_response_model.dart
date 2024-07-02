class AddQuestionResponse {
  final String message;

  AddQuestionResponse({required this.message});

  factory AddQuestionResponse.fromJson(Map<String, dynamic> json) {
    return AddQuestionResponse(
      message: json['message'],
    );
  }
}
