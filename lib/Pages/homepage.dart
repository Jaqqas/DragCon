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

//
List<DraggableList> allLists = [
  DraggableList(
    header: 'Backlog',
    items: [
      DraggableListItem(
        title: 'Task',
        task: tasks[1],
      ),
      DraggableListItem(
        title: 'Task',
        task: tasks[2],
      ),
      DraggableListItem(
        title: 'Task',
        task: tasks[3],
      ),
    ],
  ),
  DraggableList(
    header: 'In Process',
    items: [
      DraggableListItem(
        title: 'Task',
        task: tasks[4],
      ),
      DraggableListItem(
        title: 'Task',
        task: tasks[5],
      ),
      DraggableListItem(
        title: 'Task',
        task: tasks[6],
      ),
    ],
  ),
  DraggableList(
    header: 'Complited',
    items: [
      DraggableListItem(
        title: 'Task',
        task: tasks[7],
      ),
      DraggableListItem(
        title: 'Task',
        task: tasks[8],
      ),
      DraggableListItem(
        title: 'Task',
        task: tasks[9],
      ),
      DraggableListItem(
        title: 'Task',
        task: tasks[0],
      ),
    ],
  ),
];

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
  @override
  void initState() {
    super.initState();
    lists = allLists.map(buildList).toList();
  }

  late List<DragAndDropList> lists;

  bool DragFlag() {
    if (user.admin <= 1)
      return true; //master ekipy lub root
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavBar(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/japback.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: DragAndDropLists(
            // lastItemTargetHeight: 50,
            // addLastItemTargetHeightToTop: true,
            // lastListTargetSize: 30,
            listPadding: EdgeInsets.all(10),
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
            listWidth: 400,
            listDraggingWidth: 400,
          ),
        ));
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          padding: EdgeInsets.all(12),
          child: Text(
            list.header,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color.fromARGB(255, 182, 10, 250)),
          ),
        ),
        children: list.items
            .map((item) => DragAndDropItem(
                  child: ListTile(
                    title: Text(item.task.about),
                  ),
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

  void podmiana(int idx, DragAndDropList tmp2) {
    //String table = 'tasks';
    //String type = "xd"; //do upgrade'u
    //lists.map((e) => null).
    //  int? task_id = tasks[idx].task_id;
    //Map mapdate = {
    // transferred data map
    //   'table': table,
    //  'type': type,
    //  'task_id': task_id
    // };
    //Update(table, mapdate);
  }
}
