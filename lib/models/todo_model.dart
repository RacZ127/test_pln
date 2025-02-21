class TodoModel {
  final int? userId;
  final int? id;
  final String title;
  final String? body;
  final bool? completed;

  TodoModel({
    this.userId,
    this.id,
    required this.title,
    this.body,
    this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
    "body": body,
  };
}
