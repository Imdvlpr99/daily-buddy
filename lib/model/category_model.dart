class CategoryModel {
  final String categoryId;
  final String categoryName;

  CategoryModel(this.categoryId, this.categoryName);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(json['category_id'], json['category_name']);
  }
}