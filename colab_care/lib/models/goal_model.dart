class Goal {
  final String id;
  final String title;
  final String desc;
  final String progress;
  final String dueDate;
  final String createdDate;
  final bool completed;

  Goal({
    required this.id,
    required this.title,
    required this.desc,
    required this.progress,
    required this.dueDate,
    required this.createdDate,
    required this.completed,
  });
}
