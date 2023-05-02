import 'package:hive/hive.dart';
import 'enum_task.dart';
part 'task_type.g.dart';

@HiveType(typeId: 2)
class TaskType extends HiveObject {
  TaskType({
    required this.image,
    required this.title,
    required this.taskTypeEnum,
  });
  @HiveField(0)
  String image;
  @HiveField(1)
  String title;
  @HiveField(2)
  TaskTypeEnum taskTypeEnum;
}
