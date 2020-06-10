import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_bloc/screens/edit_task.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpandedTile extends StatefulWidget {
  final title;
  final list;
  List<bool> _isPause;

  ExpandedTile({this.title, this.list})
      : _isPause = List.filled(list.length, true, growable: true);

  @override
  _ExpandedTileState createState() => _ExpandedTileState();
}

class _ExpandedTileState extends State<ExpandedTile> {
  @override
  void initState() {
    super.initState();
    print(widget.list.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded);
    
    return widget.list.length > 0 ? ExpansionTile(
      
      initiallyExpanded: widget.list.length > 0 ? true : false,
      title: Text("${widget.title} (${widget.list.length})",
          style: TextStyle(
            fontSize: 15.0,
            color: theme.font_color,
          )),
      children: <Widget>[
        Wrap(
          children: <Widget>[
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey,
              ),
              shrinkWrap: true,
              itemCount: widget.list.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    color: Colors.red,
                  ),
                  onDismissed: (direction) async {
                    BlocProvider.of<TaskBlocBloc>(context)
                        .add(TaskDelete(task: widget.list[index]));
                  },
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    leading: widget.list[index].status
                        ? IconButton(
                            icon: Icon(
                              MdiIcons.checkboxMarkedCircleOutline,
                              color: Colors.blue[600],
                            ),
                            onPressed: () async {
                              BlocProvider.of<TaskBlocBloc>(context)
                                  .add(TaskComplete(task: widget.list[index]));
                            })
                        : widget.list[index].subtasks.length == 0
                            ? SizedBox(
                                height: 30,
                                width: 40,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget._isPause[index] =
                                          !widget._isPause[index];
                                    });
                                  },
                                  child: FlareActor(
                                    'assets/test_2.flr',
                                    fit: BoxFit.fitHeight,
                                    alignment: Alignment.center,
                                    animation: "done",
                                    isPaused: widget._isPause[index],
                                    callback: (String name) {
                                      BlocProvider.of<TaskBlocBloc>(context)
                                          .add(TaskComplete(
                                              task: widget.list[index]));
                                    },
                                  ),
                                ),
                              )
                            : subtaskIcon(context, widget.list, index),
                    subtitle:
                        widget.title != "today" && widget.title != "tomorrow"
                            ? Text(
                                DateFormat('E, MMM d')
                                    .format(widget.list[index].date),
                                style: TextStyle(fontSize: 12.0,color: widget.list[index].date.difference(DateTime.now()).inDays < 0 ? Colors.red : Colors.grey),
                              )
                            : Container(),
                    title: Text(
                          widget.list[index].name,
                          style: TextStyle(
                              color: theme.font_color,
                              decoration: widget.list[index].status
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                        ) ??
                        "null",
                    trailing: IconButton(
                        icon: Icon(
                          Icons.star,
                          color: widget.list[index].priority == false
                              ? Colors.grey
                              : Colors.red[300],
                          size: 30.0,
                        ),
                        onPressed: () async {
                          BlocProvider.of<TaskBlocBloc>(context)
                              .add(TaskStarred(task: widget.list[index]));
                        }),
                    onTap: () async {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  TaskEdit(id: widget.list[index].id)));
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ) : Container();
  }
}

Widget subtaskIcon(BuildContext context, var list, var index) {
  return Stack(
    children: <Widget>[
      IconButton(
        icon: Icon(
          Icons.radio_button_unchecked,
          color: Colors.grey,
          size: 30.0,
        ),
        onPressed: () async {
          BlocProvider.of<TaskBlocBloc>(context)
              .add(TaskComplete(task: list[index]));
        },
      ),
      Positioned(
          left: 15.0,
          top: 15.0,
          child: Icon(
            Icons.list,
            color: Colors.grey,
            size: 19.0,
          ))
    ],
  );
}
