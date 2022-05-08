import 'dart:io';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:dragcon/mysql/tables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../NavBar.dart';
import '../main.dart';
import 'dart:collection';
import '../global.dart';
import 'package:sizer/sizer.dart';

//
List<DraggableList> allLists = [];
List<Tasks> teamtasks = [];
List<DraggableListItem> _Backlog = [];
List<DraggableListItem> _InProcess = [];
List<DraggableListItem> _Completed = [];

///////////////////////////
class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final String title;
  final Tasks task;
  const DraggableListItem({
    required this.task,
    required this.title,
  });
}

///////////////////////
class homepage extends StatefulWidget {
  @override
  _homepage createState() => _homepage();
}

class _homepage extends State<homepage> {
  static final String title = 'Drag & Drop ListView';

  void LoadTeamTasks() {
    //clean everything
    allLists.clear();
    teamtasks.clear();
    _Backlog.clear();
    _InProcess.clear();
    _Completed.clear();

    //choose only your team tasks
    for (var item in tasks) {
      if (user.ekipa_id == item.ekipa_id) {
        teamtasks.add(item);
      }
    }
    //ordering tasks
    for (var item in teamtasks) {
      DraggableListItem tmp = new DraggableListItem(task: item, title: "task");

      if (item.type == "Backlog")
        _Backlog.add(tmp);
      else if (item.type == "Inprocess")
        _InProcess.add(tmp);
      else if (item.type == "Completed") _Completed.add(tmp);
    }

    DraggableList Backlog =
        new DraggableList(header: "Backlog", items: _Backlog);
    DraggableList InProcess =
        new DraggableList(header: "Inprocess", items: _InProcess);
    DraggableList Completed =
        new DraggableList(header: "Completed", items: _Completed);

    allLists.add(Backlog);
    allLists.add(InProcess);
    allLists.add(Completed);
  }

  @override
  void initState() {
    super.initState();
    LoadTeamTasks();
    lists = allLists.map(buildList).toList();
  }

  late List<DragAndDropList> lists;

  bool DragFlag() {
    if (user.admin <= 1)
      return true; //team master or root
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        body: Container(
          width: 100.w,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/japback.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: DragAndDropLists(
            lastItemTargetHeight: 35,
            //addLastItemTargetHeightToTop: true,
            lastListTargetSize: 1,

            listPadding: EdgeInsets.fromLTRB(2.w, 5.h, 0.w, 5.h),
            listInnerDecoration: BoxDecoration(
              color: Color.fromARGB(211, 104, 58, 183),
              borderRadius: BorderRadius.circular(20),
            ),

            children: lists,
            itemDivider: Divider(thickness: 2, height: 2),
            itemDecorationWhileDragging: BoxDecoration(
              color: Color.fromARGB(255, 225, 159, 236),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(255, 189, 184, 184), blurRadius: 12)
              ],
            ),
            onItemReorder: onReorderListItem,
            onListReorder: onReorderList,
            axis: Axis.horizontal,
            listWidth: 50.h,
            listDraggingWidth: 50.h,
          ),
        ));
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
            child: Center(
                child: Column(children: [
          Text(
            list.header,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ]))),
        children: list.items
            .map((item) => DragAndDropItem(
                  child: ListTile(
                      title: Column(children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "Lokalizacja: \n" + item.task.location,
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        Text(
                          "Data zgłoszenia: \n" + item.task.data_reg,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Text(
                      item.task.about,
                      textAlign: TextAlign.center,
                    ),
                  ])),
                  canDrag: DragFlag(),
                ))
            .toList(),
      );

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      podmiana(oldListIndex, oldItemIndex, newListIndex);
      sleep(Duration(milliseconds: 40));
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;
      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }

  void podmiana(int idx, int idx2, int idx3) async {
    var task_tmp = allLists[idx].items[idx2].task;
    String table = 'tasks';
    String? type = task_tmp.type; //do upgrade'u
    String task_id = task_tmp.task_id.toString();

    Map mapdate = {
      // transferred data map
      'table': table,
      'type': allLists[idx3].header,
      'task_id': task_id,
    };
    Update(table, mapdate);
  }
}
