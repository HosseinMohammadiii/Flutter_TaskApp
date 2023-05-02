import 'package:flutter/material.dart';
import 'package:flutter_note_project/screens_types/task_type.dart';

class taskTypeListItem extends StatelessWidget {
  taskTypeListItem({
    super.key,
    required this.taskType,
    required this.index,
    required this.selectedItem,
  });
  TaskType taskType;
  int index;
  int selectedItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 36, right: 8),
      child: Container(
        alignment: Alignment.topCenter,
        width: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.5),
          child: Card(
            color: selectedItem == index ? Colors.green[400] : Colors.green[50],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(taskType.image),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    taskType.title,
                    style: TextStyle(
                      color: selectedItem == index
                          ? Colors.white
                          : Colors.blueGrey[400],
                      fontFamily: 'SM',
                      fontSize: 16,
                      fontWeight: selectedItem == index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
