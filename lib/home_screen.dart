import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_note_project/add_task_screen.dart';
import 'package:flutter_note_project/edit_task_screen.dart';
import 'package:flutter_note_project/screens_types/generate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_note_project/task_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.isThemeDark = false});
  bool isThemeDark = false;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var taskbox = Hive.box<Task>('taskBox');
  bool isFabVisible = true;
  bool isSearchList = false;
  bool isSearchLoading = false;
  bool deletetask = false;
  List<Task> tasklist = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    List<Task> taskList = taskbox.values.toList();
    setState(() {
      taskList = taskList;
    });

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isThemeDark == false ? Color(0xffe5e5e5) : Color(0xff222222),
      appBar: PreferredSize(
        child: AppBar(
          foregroundColor:
              widget.isThemeDark == false ? Colors.black : Colors.white70,
          titleSpacing: 0.0,
          toolbarHeight: 80,
          title: Row(
            children: [
              dark_lightMode(),
              Expanded(child: boxSearch()),
            ],
          ),
          backgroundColor: widget.isThemeDark == false
              ? Color(0xffe5e5e5)
              : Color(0xff222222),
          elevation: 0,
        ),
        preferredSize: Size(80, 80),
      ),
      body: SafeArea(
        child: getMainWidget(),
      ),
      floatingActionButton: Visibility(
        visible: isFabVisible,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(
                  isTheme: widget.isThemeDark,
                ),
              ),
            );
          },
          backgroundColor: Color(0xff18DDA3),
          child: Image.asset('images/icon_add.png'),
        ),
      ),
    );
  }

  Widget getMainWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: isSearchLoading == true,
            child: Column(
              children: [
                Text(
                  '!تسک مورد نظر یافت نشد',
                  style: TextStyle(
                    color: widget.isThemeDark == false
                        ? Colors.black
                        : Colors.white,
                    fontFamily: 'SM',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widget.isThemeDark == false
                    ? SvgPicture.asset(
                        'images/empty_dark.svg',
                        height: 65,
                      )
                    : SvgPicture.asset(
                        'images/empty_light.svg',
                        height: 65,
                      ),
              ],
            ),
          ),
          _listBuilderTasks(),
        ],
      ),
    );
  }

  Widget dark_lightMode() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isThemeDark = !widget.isThemeDark;
        });
      },
      child: widget.isThemeDark == false
          ? Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.light_mode,
                size: 35,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.dark_mode,
                color: Colors.white70,
                size: 35,
              ),
            ),
    );
  }

  Widget _listBuilderTasks() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ValueListenableBuilder(
        valueListenable: taskbox.listenable(),
        builder: (context, value, child) {
          return NotificationListener<UserScrollNotification>(
            onNotification: (notif) {
              setState(() {
                if (notif.direction == ScrollDirection.forward) {
                  isFabVisible = true;
                }
                if (notif.direction == ScrollDirection.reverse) {
                  isFabVisible = false;
                }
              });
              return true;
            },
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 112),
              itemCount: isSearchList ? tasklist.length : taskbox.values.length,
              itemBuilder: (context, index) {
                var task = isSearchList
                    ? tasklist[index]
                    : taskbox.values.toList()[index];

                return getListDelete(task);
              },
            ),
          );
        },
      ),
    );
  }

  Widget getListDelete(Task task) {
    return Dismissible(
      key: UniqueKey(),
      resizeDuration: Duration(microseconds: 1),
      background: textDismissible(
        Alignment.centerLeft,
        'حذف',
        EdgeInsets.only(left: 35),
      ),
      secondaryBackground: textDismissible(
        Alignment.centerRight,
        'ویرایش',
        EdgeInsets.only(right: 35),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EdittaskScreen(
                task: task,
                isTheme: widget.isThemeDark,
              ),
            ),
          );
        }
        if (direction == DismissDirection.startToEnd) {
          task.delete();
        }
      },
      child: TaskWidget(task: task, isTheme: widget.isThemeDark),
    );
  }

  Widget textDismissible(
      Alignment alignment, String txt, EdgeInsets edgeInsets) {
    return Container(
      margin: edgeInsets,
      alignment: alignment,
      child: Text(
        txt,
        textAlign: TextAlign.end,
        style: TextStyle(
          leadingDistribution: TextLeadingDistribution.even,
          color: widget.isThemeDark == false ? Colors.black45 : Colors.white54,
          fontSize: 22,
          fontFamily: 'SM',
        ),
      ),
    );
  }

  _searchListItems(String ttl) {
    List<Task> searchtask = [];

    if (ttl.isEmpty) {
      setState(() {});
      List<Task> updatedList = taskbox.values.toList();
      isSearchLoading = false;
      setState(() {
        tasklist = updatedList;
        isSearchList = false;
        isSearchLoading = false;
      });
      FocusScope.of(context).unfocus();
      return;
    }
    searchtask = taskbox.values
        .where(
          (element) => element.title!.toLowerCase().contains(
                ttl.toLowerCase(),
              ),
        )
        .toList();
    setState(() {
      tasklist = searchtask;
      isSearchList = true;
      isSearchLoading = false;
      // isSearchLoading = false;
    });

    if (searchtask.isEmpty) {
      setState(() {
        isSearchLoading = true;
      });
    }
  }

  Widget boxSearch() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: 322,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              fillColor: widget.isThemeDark == false
                  ? Colors.green.withOpacity(1)
                  : Colors.green[400],
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'عنوان مورد نظر را وارد کنید',
              hintStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'SM',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: null,
            //expands: true,
            onChanged: ((value) {
              _searchListItems(value);
            }),
          ),
        ),
      ),
    );
  }
}
