import 'package:hive/hive.dart';
part 'enum_task.g.dart';

@HiveType(typeId: 3)
enum TaskTypeEnum {
  @HiveField(0)
  working,
  @HiveField(1)
  fun,
  @HiveField(2)
  focus,
  @HiveField(3)
  play,
  @HiveField(4)
  rest,
  @HiveField(5)
  study,
}
