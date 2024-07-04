class ReportMessageRequest {
  final int messageId;
  final String reportMessage;

  ReportMessageRequest({
    required this.messageId,
    required this.reportMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'report_message': reportMessage,
    };
  }
}
