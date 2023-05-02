import 'package:flutter_note_project/screens_types/task_type.dart';
import 'package:hive/hive.dart';
part 'generate.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  Task({
    this.title,
    this.subtitle,
    this.isDone = false,
    this.time,
    this.taskType,
    this.dark = false,
    this.day,
  });
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? subtitle;
  @HiveField(2)
  bool isDone;
  @HiveField(3)
  DateTime? time;
  @HiveField(4)
  TaskType? taskType;
  @HiveField(5)
  bool dark;
  @HiveField(6)
  DateTime? day;
}
