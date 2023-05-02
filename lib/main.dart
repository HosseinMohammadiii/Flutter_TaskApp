import 'package:flutter/material.dart';
import 'package:flutter_note_project/screens_types/enum_task.dart';
import 'package:flutter_note_project/screens_types/generate.dart';
import 'package:flutter_note_project/screens_types/task_type.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'home_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TaskTypeAdapter());
  Hive.registerAdapter(TaskTypeEnumAdapter());
  await Hive.openBox<Task>('taskBox');
  await Future.delayed(Duration(seconds: 1));

  runApp(Application());
}

class Application extends StatelessWidget {
  Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
