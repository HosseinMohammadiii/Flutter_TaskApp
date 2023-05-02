import 'package:flutter/material.dart';
import 'package:flutter_note_project/class/notification.dart';
import 'package:flutter_note_project/home_screen.dart';
import 'package:flutter_note_project/screens_types/generate.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jalali_table_calendar/jalali_table_calendar.dart';
import 'package:flutter_note_project/task_list_item_screen.dart';
import 'package:flutter_note_project/List/utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:time_pickerr/time_pickerr.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({super.key, this.isTheme = false});
  bool isTheme;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  FocusNode negahban1 = FocusNode();
  FocusNode negahban2 = FocusNode();
  DateTime? _time;
  DateTime? _day;
  bool isTime = true;
  bool isCalendar = false;
  bool showNotif = true;
  int selectIndex = 0;

  final TextEditingController controllerTitleTask = TextEditingController();
  final TextEditingController controllerSubTitleTask = TextEditingController();
  ValueNotifier addtask = ValueNotifier(0);
  final box = Hive.box<Task>('taskBox');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

    negahban1.addListener(() {
      setState(() {});
    });
    negahban2.addListener(() {
      setState(() {});
    });

    notification.inittilize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isTheme == false ? Colors.white : Color(0xff222222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 20,
              ),
              getTextfieldInputText(
                focusNode: negahban1,
                hnt: 'عنوان تسک مورد نظر را وارد کنید',
                lbt: 'عنوان',
                cnt: controllerTitleTask,
                maxLine: 1,
                tia: TextInputAction.next,
                fsize: 18,
              ),
              SizedBox(
                height: 20,
              ),
              getTextfieldInputText(
                focusNode: negahban2,
                hnt: 'توضیحات تسک را وراد کنید',
                lbt: 'توضیحات',
                cnt: controllerSubTitleTask,
                maxLine: 2,
                tia: TextInputAction.done,
                fsize: 15,
              ),
              SizedBox(
                height: 20,
              ),
              getIconTimes(),
              isCalendar == !isTime ? getSelectTime() : getCalendar(context),
              Padding(
                padding: EdgeInsets.only(right: 11),
                child: Text(
                  'وضعیت',
                  style: TextStyle(
                    height: 2.5,
                    color: widget.isTheme == true ? Colors.white : Colors.black,
                    fontFamily: 'SM',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              getListStatusTask(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: getAddTask(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getIconTimes() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTime = isCalendar;
          isCalendar = !isCalendar;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              isTime == isCalendar
                  ? Icon(
                      Icons.access_time,
                      color: Color(0xffC5C5C5),
                      size: 45,
                    )
                  : Icon(
                      Icons.access_time,
                      size: 45,
                      color: Colors.green[400],
                    ),
              isTime == isCalendar
                  ? Text(
                      'زمان',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffC5C5C5),
                        //fontWeight: FontWeight.bold,
                        fontFamily: 'SM',
                      ),
                    )
                  : Text(
                      'زمان',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[400],
                        fontFamily: 'SM',
                      ),
                    ),
            ],
          ),
          getIconCalendar(),
        ],
      ),
    );
  }

  Widget getIconCalendar() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCalendar = isTime;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              isCalendar == isTime
                  ? Icon(
                      Icons.calendar_month_outlined,
                      size: 45,
                      color: Colors.green[400],
                    )
                  : Icon(
                      Icons.calendar_month_outlined,
                      color: Color(0xffC5C5C5),
                      size: 45,
                    ),
              isTime == isCalendar
                  ? Text(
                      'تاریخ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[400],
                        fontFamily: 'SM',
                      ),
                    )
                  : Text(
                      'تاریخ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xffC5C5C5),
                        //fontWeight: FontWeight.bold,
                        fontFamily: 'SM',
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getSelectTime() {
    return CustomHourPicker(
        date: DateTime.now(),
        elevation: 2,
        title: 'زمان تسک را انتخاب کنید',
        titleStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          fontFamily: 'SM',
        ),
        positiveButtonText: 'انتخاب',
        positiveButtonStyle: TextStyle(
          fontSize: 15,
          color: Colors.blue[600],
          fontFamily: 'SM',
        ),
        onPositivePressed: (context, time) {
          _time = time;
        });
  }

  Widget getListStatusTask() {
    return SizedBox(
      height: 155,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: getTaskList().length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectIndex = index;
              });
            },
            child: taskTypeListItem(
              taskType: getTaskList()[index],
              index: index,
              selectedItem: selectIndex,
            ),
          );
        },
      ),
    );
  }

  Widget getCalendar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38, vertical: 25),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 290,
          decoration: BoxDecoration(
            color: widget.isTheme == true ? Colors.white : Color(0xffFAFAFA),
            borderRadius: BorderRadius.circular(5),
          ),
          child: JalaliTableCalendar(
              context: context,
              events: {},
              marker: (date, events) {
                return Container();
              },
              onDaySelected: (date) {
                _day = date;
              }),
        ),
      ),
    );
  }

  Widget getAddTask(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          String taskTitle = controllerTitleTask.text;
          String taskSubTitle = controllerSubTitleTask.text;
          bool isChecked = true;

          if (taskTitle.isEmpty) {
            _showDialog('لطفا عنوان را وارد کنید!');
            return;
          }

          if (_time == null) {
            _showDialog(
                'لطفا زمان مورد نظر را انتخاب کنید و سپس روی گزینه انتخاب کلیک کنید.');
            return;
          }
          if (_day == null) {
            _day = DateTime.now();
          }

          DateTime now = DateTime.now();
          DateTime selectedDateTime = DateTime(
            _day!.year,
            _day!.month,
            _day!.day,
            _time!.hour,
            _time!.minute,
          );

          DateTime selectcalendar = DateTime(
            _day!.year,
            _day!.month,
            _day!.day,
            selectedDateTime.hour,
            selectedDateTime.minute,
          );

          if (selectedDateTime.isBefore(now)) {
            _showDialog('زمانی که انتخاب کرده اید باید بعد از زمان حال باشد!');
            return;
          } else if (selectcalendar.isBefore(now)) {
            notification.showBigTextNotification(
              dateTime: selectedDateTime,
              time: selectcalendar,
              title: 'زمان تسک مورد نظر رسید',
              body: taskTitle,
              fln: flutterLocalNotificationsPlugin,
            );
            addTask(taskTitle, taskSubTitle, isChecked);
          } else {
            notification.showBigTextNotification(
              dateTime: selectedDateTime,
              time: selectcalendar,
              title: 'زمان تسک مورد نظر رسید',
              body: taskTitle,
              fln: flutterLocalNotificationsPlugin,
            );
            addTask(taskTitle, taskSubTitle, isChecked);
          }

          Navigator.pop(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        },
        child: Text(
          'اضافه کردن',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SM',
            fontSize: 15,
          ),
        ),
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.green,
          minimumSize: Size(150, 40),
        ),
      ),
    );
  }

  Widget getTextfieldInputText({
    required FocusNode focusNode,
    required String hnt,
    required String lbt,
    required TextEditingController cnt,
    required int maxLine,
    required TextInputAction tia,
    required double fsize,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 38),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: cnt,
          maxLines: maxLine,
          focusNode: focusNode,
          textInputAction: tia,
          style: TextStyle(
            color: widget.isTheme == true ? Colors.white : Colors.black,
            fontFamily: 'SM',
            fontWeight: FontWeight.bold,
            fontSize: fsize,
          ),
          decoration: InputDecoration(
            hintText: hnt,
            hintStyle: TextStyle(
              color: widget.isTheme == true ? Colors.white60 : Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'SM',
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            labelText: lbt,
            labelStyle: TextStyle(
              fontFamily: 'SM',
              fontSize: 20,
              fontWeight: FontWeight.w100,
              color: focusNode.hasFocus ? Color(0xff18DDA3) : Color(0xffC5C5C5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                  color: widget.isTheme == true
                      ? Colors.white.withOpacity(0.6)
                      : Color(0xffC5C5C5),
                  width: 3.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                width: 3,
                color: Color(0xff18DDA3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  addTask(String title, String subtitle, bool isChecked) {
    var task = Task(
        title: title,
        subtitle: subtitle,
        isDone: isChecked,
        dark: widget.isTheme,
        time: _time!,
        day: _day!,
        taskType: getTaskList()[selectIndex]);
    box.add(task);
  }

  Future<void> _showDialog(String txt) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          title: Text(
            txt,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text(
                'حله',
                style: TextStyle(
                  color: Color(0xff18DDA3),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SM',
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
