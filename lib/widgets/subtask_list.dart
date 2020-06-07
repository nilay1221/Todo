import 'package:flutter/material.dart';
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
                    icon: Icon(Icons.check_box_outline_blank),
                    onPressed: () {
                      callback(subtasks[index].id);
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.done,color: Colors.grey,),
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
                initialValue: subtasks[index].name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: subtasks[index].status? TextStyle(color: Colors.grey) : TextStyle(color: Colors.black),
                onChanged: (value) {
                  setName(subtasks[index].id,value);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.clear),
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
