class CategoryStatsModel {
  final int categoryId;
  final String categoryName;
  final int questionCount;

  CategoryStatsModel({required this.categoryId,required this.categoryName, required this.questionCount});

  factory CategoryStatsModel.fromJson(Map<String, dynamic> json) {
    return CategoryStatsModel(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      questionCount: json['question_count'],
    );
  }
}
