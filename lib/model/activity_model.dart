class ActivityModel {
  final String id;
  final String title;
  final String desc;
  final String date;
  final String time;
  final String categoryId;
  final String isComplete;

  ActivityModel(
      this.id,
      this.title,
      this.desc,
      this.date,
      this.time,
      this.categoryId,
      this.isComplete);

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      json['id'],
      json['title'],
      json['description'],
      json['date'],
      json['time'],
      json['category_id'],
      json['is_complete'],
    );
  }
}