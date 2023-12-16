class ActivityModel {
  late final String id;
  late final String title;
  late final String desc;
  late final String date;
  late final String time;
  late final String categoryId;
  late final String isComplete;

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