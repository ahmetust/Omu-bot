class ReportMessageResponse {
  final String message;
  final String? error;

  ReportMessageResponse({
    required this.message,
    this.error,
  });

  factory ReportMessageResponse.fromJson(Map<String, dynamic> json) {
    return ReportMessageResponse(
      message: json['message'],
      error: json['error'],
    );
  }
}
