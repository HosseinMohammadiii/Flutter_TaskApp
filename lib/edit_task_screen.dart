import 'package:flutter/material.dart';
import 'package:flutter_note_project/class/notification.dart';
import 'package:flutter_note_project/home_screen.dart';
import 'package:flutter_note_project/screens_types/generate.dart';
import 'package:flutter_note_project/task_list_item_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_note_project/List/utility.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jalali_table_calendar/jalali_table_calendar.dart';
import 'package:time_pickerr/time_pickerr.dart';

class EdittaskScreen extends StatefulWidget {
  EdittaskScreen({
    super.key,
    required this.task,
    this.isTheme = false,
  });
  Task task;
  bool isTheme;

  @override
  State<EdittaskScreen> createState() => _EdittaskScreenState();
}

class _EdittaskScreenState extends State<EdittaskScreen> {
  FocusNode negahban1 = FocusNode();
  FocusNode negahban2 = FocusNode();
  DateTime? _time;
  bool isTime = true;
  bool isCalendar = false;
  DateTime? _day;

  int selectIndex = 0;
  TextEditingController? controllerTitleTask;
  TextEditingController? controllerSubTitleTask;
  ValueNotifier addtask = ValueNotifier(0);
  final box = Hive.box<Task>('taskBox');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    controllerTitleTask = TextEditingController(text: widget.task.title);
    controllerSubTitleTask = TextEditingController(text: widget.task.subtitle);

    negahban1.addListener(() {
      setState(() {});
    });
    negahban2.addListener(() {
      setState(() {});
    });
    var list = getTaskList().indexWhere((element) {
      return element.taskTypeEnum == widget.task.taskType!.taskTypeEnum;
    });

    selectIndex = list;

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
                cnt: controllerTitleTask!,
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
                cnt: controllerSubTitleTask!,
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
              getEditTask(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget getEditTask(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            String taskTitle = controllerTitleTask!.text;
            String taskSubTitle = controllerSubTitleTask!.text;
            bool isChecked = true;

            if (taskTitle.isEmpty) {
              _showDialog('لطفا عنوان را وارد کنید');
              return;
            }

            if (_time == null) {
              _time = widget.task.time;
            }
            if (_day == null) {
              _day = widget.task.day;
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
              _showDialog(
                  'زمانی که انتخاب کرده اید باید بعد از زمان حال باشد!');
              return;
            } else if (selectcalendar.isBefore(now)) {
              notification.showBigTextNotification(
                dateTime: selectedDateTime,
                time: widget.task.day,
                title: 'زمان تسک مورد نظر رسید',
                body: taskTitle,
                fln: flutterLocalNotificationsPlugin,
              );
              editTask(taskTitle, taskSubTitle, isChecked);
            } else {
              notification.showBigTextNotification(
                dateTime: selectedDateTime,
                time: selectcalendar,
                title: 'زمان تسک مورد نظر رسید',
                body: taskTitle,
                fln: flutterLocalNotificationsPlugin,
              );
              editTask(taskTitle, taskSubTitle, isChecked);
            }

            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          },
          child: Text(
            'ویرایش',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.green,
            minimumSize: Size(150, 40),
          ),
        ),
      ),
    );
  }

  Widget getSelectTime() {
    return CustomHourPicker(
        date: widget.task.time,
        elevation: 2,
        title: 'زمان تسک را انتخاب کنید',
        titleStyle: TextStyle(
          fontSize: 18,
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
            initialTime: TimeOfDay.fromDateTime(widget.task.day!),
            context: context,
            events: {},
            marker: (date, events) {
              return Container();
            },
            onDaySelected: (date) {
              // _day = date;
              widget.task.day = date;
            },
          ),
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

  editTask(String title, String subtitle, bool isChecked) {
    widget.task.title = title;
    widget.task.subtitle = subtitle;
    widget.task.time = _time!;
    widget.task.day = _day!;
    widget.task.taskType = getTaskList()[selectIndex];
    widget.task.save();
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
            // textAlign: TextAlign.right,
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
