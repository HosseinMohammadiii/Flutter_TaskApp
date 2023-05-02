import 'package:flutter_note_project/screens_types/enum_task.dart';
import 'package:flutter_note_project/screens_types/task_type.dart';

List<TaskType> getTaskList() {
  var list = [
    TaskType(
        image: 'images/workout.png',
        title: 'ورزش',
        taskTypeEnum: TaskTypeEnum.play),
    TaskType(
        image: 'images/meditate.png',
        title: 'استراحت',
        taskTypeEnum: TaskTypeEnum.focus),
    TaskType(
        image: 'images/social_frends.png',
        title: 'تفریح',
        taskTypeEnum: TaskTypeEnum.fun),
    TaskType(
      image: 'images/Studying.png',
      title: 'درس',
      taskTypeEnum: TaskTypeEnum.study,
    ),
    TaskType(
      image: 'images/work_meeting.png',
      title: 'قرار',
      taskTypeEnum: TaskTypeEnum.rest,
    ),
    TaskType(
      image: 'images/working.png',
      title: 'کار',
      taskTypeEnum: TaskTypeEnum.working,
    ),
  ];
  return list;
}
