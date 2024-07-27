class EditQuestionResponse {
  final String message;

  EditQuestionResponse({required this.message});

  factory EditQuestionResponse.fromJson(Map<String, dynamic> json) {
    return EditQuestionResponse(
      message: json['message'],
    );
  }
}
