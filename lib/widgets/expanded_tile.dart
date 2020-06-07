import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_bloc/screens/edit_task.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class ExpandedTile extends StatelessWidget {
  final title;
  final list;


  ExpandedTile({this.title, this.list});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: list.length > 0 ? true : false,
      title: Text("$title (${list.length})",style: TextStyle(fontSize: 15.0,color: Colors.black,)),
      children: <Widget>[
        Wrap(
          children: <Widget>[
            ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) async {
                    BlocProvider.of<TaskBlocBloc>(context).add(TaskDelete(task:list[index]));
                  },
                  direction: DismissDirection.horizontal,
                  child: ListTile(
                    leading: list[index].status ?
                    IconButton(
                        icon: Icon(MdiIcons.checkboxMarkedOutline,color: Colors.blue[600],),
                        onPressed: () async {
                          BlocProvider.of<TaskBlocBloc>(context).add(TaskComplete(task: list[index]));
                        }) :
                        list[index].subtasks.length == 0 ?
                     IconButton(
                        icon: Icon(Icons.check_box_outline_blank),
                        onPressed: () async {
                          BlocProvider.of<TaskBlocBloc>(context).add(TaskComplete(task: list[index]));
                        }) : subtaskIcon(context,list,index),
                    subtitle: title != "today" && title != "tomorrow"
                        ? Text(
                            DateFormat('E, MMM d')
                                .format(list[index].date),
                            style: TextStyle(fontSize: 12.0),
                          )
                        : Container(),
                    title: Text(list[index].name,style: TextStyle(decoration: list[index].status ? TextDecoration.lineThrough:TextDecoration.none),) ?? "null",
                    trailing: IconButton(
                        icon: Icon(
                          Icons.star,
                          color: list[index].priority == false
                              ? Colors.black12
                              : Colors.red[300],
                          size: 30.0,
                        ),
                        onPressed: () async {
                              BlocProvider.of<TaskBlocBloc>(context).add(TaskStarred(task: list[index]));
                        }),
                    onTap: () async {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => TaskEdit(id:list[index].id)));
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}


Widget subtaskIcon(BuildContext context, var list, var index) {
  return Stack(
    children: <Widget>[
      IconButton(
        icon: Icon(
          Icons.check_box_outline_blank,
          size: 30.0,
        ),
        onPressed: () async {
        BlocProvider.of<TaskBlocBloc>(context).add(TaskComplete(task: list[index]));
        },
      ),
      Positioned(
          left: 15.0,
          top: 15.0,
          child: Icon(
            Icons.list,
            size: 19.0,
          ))
    ],
  );
}