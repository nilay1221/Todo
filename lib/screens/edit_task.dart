import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:todo_bloc/models/todo.dart';
import 'package:intl/intl.dart';
import 'package:todo_bloc/widgets/widgets.dart';


class TaskEdit extends StatefulWidget {
  @override
  _TaskEditState createState() => _TaskEditState();

  int id;

  TaskEdit({this.id});
}

class _TaskEditState extends State<TaskEdit> {
  Task task;

  DateTime _date;
  // TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    task = (BlocProvider.of<TaskBlocBloc>(context).state as TaskBlocLoaded ).gettask(widget.id);
    this._date = task.date;
  }

  void toggleTask(int id) {
    setState(() {
      task.subtasks.firstWhere((task) => task.id == id).status = !task.subtasks.firstWhere((task) => task.id == id).status;
    });
  }

  void set_name(int id,String name){
    task.subtasks.firstWhere((task) => task.id == id).name = name;
    
  }

  void delete(int id) {
    setState(() {
      task.subtasks.removeWhere((task) => task.id == id);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: () async{
            BlocProvider.of<TaskBlocBloc>(context).add(TaskUpdate(task: task));
            return true;
          },
          child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () async {
              BlocProvider.of<TaskBlocBloc>(context).add(TaskUpdate(task: task));
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
              onPressed: () async {
                BlocProvider.of<TaskBlocBloc>(context).add(TaskDelete(task: task));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
                child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    initialValue: '${task.name[0].toUpperCase()}${task.name.substring(1)}',
                    decoration: InputDecoration(border: InputBorder.none),
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                        decoration: task.status
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                        onChanged: (value) {
                          task.name = value;
                        },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.event_available),
                  title: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.grey)),
                      child: task.status
                          ? Center(
                            child: Text(
                                "${DateFormat('E, MMM d').format(_date)}",
                                textAlign: TextAlign.left,
                              ),
                          )
                          : FlatButton(
                              child: Text(
                                "${DateFormat('E, MMM d').format(_date)}",
                                textAlign: TextAlign.left,
                              ),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate:
                                            DateTime.now().add(Duration(days: 30)))
                                    .then((value) {
                                  // _actualDate = value.toString();
                                  task.date = value;
                                  var date = DateFormat('E, MMM d').format(value);
                                  setState(() {
                                    _date = value;
                                  });
                                });
                              },
                            )),
                ),
                ListTile(
                  leading: Icon(Icons.subdirectory_arrow_right),
                  title: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SubTaskList(
                          subtasks: task.uncompletedsubtasks,
                          callback: toggleTask,
                          setName: set_name,
                          delete: delete,
                        ),
                         SubTaskList(
                          subtasks: task.completedsubtasks,
                          callback: toggleTask,
                          setName: set_name,
                          delete: delete,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 42.0),
                          child: FlatButton(
                              // color: Colors.blue,
                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  task.subtasks.add(Subtask.empty(id: task.subtasks.length + 1));
                                });
                                                          },
                              child: Text(
                                "Add subtask",
                                textAlign: TextAlign.left,
                              )),
                        
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: RaisedButton(
            color: Colors.white,
            padding: EdgeInsets.all(15.0),
            textColor: Colors.blue[600],
            elevation: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                task.status ? Icon(Icons.replay) :Icon(Icons.done),
                SizedBox(
                  width: 10.0,
                ),
                task.status ? SizedBox() :Text("Mark Complete"),
              ],
            ),
            onPressed: () async{
              BlocProvider.of<TaskBlocBloc>(context).add(TaskComplete(task: task));
              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}