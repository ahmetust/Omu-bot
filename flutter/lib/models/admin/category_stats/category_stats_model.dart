class CategoryStatsModel {
  final String categoryName;
  final int questionCount;

  CategoryStatsModel({required this.categoryName, required this.questionCount});

  factory CategoryStatsModel.fromJson(Map<String, dynamic> json) {
    return CategoryStatsModel(
      categoryName: json['category_name'],
      questionCount: json['question_count'],
    );
  }
}
