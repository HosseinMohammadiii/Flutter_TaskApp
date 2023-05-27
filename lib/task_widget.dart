import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_note_project/class/notification.dart';
import 'package:flutter_note_project/edit_task_screen.dart';
import 'package:flutter_note_project/screens_types/generate.dart';

class TaskWidget extends StatefulWidget {
  TaskWidget({super.key, required this.task, this.isTheme = true});
  Task task;
  bool isTheme = true;
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool isChecked = false;

  bool isShow = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.task.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return boxCheklist();
  }

  Widget boxCheklist() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: widget.isTheme == true ? Color(0xff3C3C3C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            getBoxtitle(),
            Padding(
              padding: EdgeInsets.only(top: 12, right: 4, bottom: 12, left: 2),
              child: Image.asset(
                '${widget.task.taskType!.image}',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBoxtitle() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isChecked = !isChecked;
                      widget.task.isDone = isChecked;
                      widget.task.save();
                    });
                  },
                  child: isChecked == false
                      ? Icon(
                          Icons.check_box_rounded,
                          color: widget.isTheme == true
                              ? Color(0xff18DDA3)
                              : Colors.green,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                          color: widget.isTheme == true
                              ? Color(0xff18DDA3)
                              : Colors.green,
                        ),
                ),
                SizedBox(
                  width: 6,
                ),
                Spacer(),
                Text(
                  widget.task.title!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SM',
                    color: widget.isTheme == true ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Text(
              widget.task.subtitle!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: widget.isTheme == true ? Colors.white : Colors.black,
              ),
            ),
            getBoxtime(),
          ],
        ),
      ),
    );
  }

  Widget getBoxtime() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isShow = !isShow;
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: 80,
              height: 30, //30
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.isTheme == false
                    ? Colors.green.withOpacity(0.9)
                    : Colors.green[400],
              ),
              child: Padding(
                  padding: EdgeInsets.all(6),
                  child: isShow == false ? getTextTime() : getTextCalendar()),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EdittaskScreen(
                      task: widget.task, isTheme: widget.isTheme),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: widget.isTheme == false
                    ? Color(0xffe5e5e5)
                    : Colors.white12,
              ),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ویرایش',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SM',
                        fontSize: 15,
                        color: widget.isTheme == true
                            ? Color(0xff18DDA3)
                            : Colors.green.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Image.asset(
                      'images/icon_edit.png',
                      width: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row getTextTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${widget.task.time!.hour < 10 ? '0' : ''}${widget.task.time!.hour}:${widget.task.time!.minute < 10 ? '0' : ''}${widget.task.time!.minute}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'SM',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Image.asset(
          'images/icon_time.png',
          width: 16,
        ),
      ],
    );
  }

  Widget getTextCalendar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${widget.task.day!.month < 10 ? '0' : ''}${widget.task.day!.month} / ${widget.task.day!.day < 10 ? '0' : ''}${widget.task.day!.day}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'SM',
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Icon(
          Icons.calendar_month_outlined,
          color: Colors.white,
          size: 18,
        ),
      ],
    );
  }
}
