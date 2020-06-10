import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:todo_bloc/models/todo.dart';

class SubTaskList extends StatelessWidget {
  final List<Subtask> subtasks;
  final taskindex;
  Function callback;
  Function setName;
  Function delete;

  SubTaskList({this.subtasks, this.taskindex,this.callback,this.setName,this.delete});


  
  @override
  Widget build(BuildContext context) {
    final theme = (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded);
    return ListView.builder(
      itemCount: subtasks.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        print("Subtask view ${subtasks[index].name}");
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            subtasks[index].status == false
                ? IconButton(
                    icon: Icon(Icons.radio_button_unchecked,color: Colors.grey,),
                    onPressed: () {
                      callback(subtasks[index].id);
                    },
                  )
                : IconButton(
                    icon: Icon(MdiIcons.checkboxMarkedCircleOutline,color: Colors.grey,),
                    onPressed: () {
                      callback(subtasks[index].id);
                    },
                  ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: TextFormField(
                key: UniqueKey(),
                autofocus: index == subtasks.length -1 ? true : false,
                initialValue: subtasks[index].name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: subtasks[index].status? TextStyle(color: Colors.grey) : TextStyle(color: theme.font_color),
                onChanged: (value) {
                  setName(subtasks[index].id,value);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear,color: Colors.grey,),
              onPressed: () {
                delete(subtasks[index].id);
              },
            ),
            SizedBox(
              height: 40.0,
            )
          ],
        );
      },
    );
  }
}
