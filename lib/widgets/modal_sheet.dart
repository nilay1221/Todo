import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:todo_bloc/models/theme.dart';

class ModalSheet extends StatefulWidget {
  @override
  _ModalSheetState createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {

  @override
  void initState() { 
    super.initState();
    _actualDate = DateTime.now().toString();
    _date = DateFormat('E, MMM d').format(DateTime.now());

  }

  var task_name;
  var _date;
  var _actualDate;
  @override
  Widget build(BuildContext context) {
    final theme = (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded);
    return Container(
      color: theme.choice == ThemeChoice.dark ? Colors.black87:Colors.white,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Wrap(children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: theme.font_color),
                  decoration: InputDecoration(
                      hintText: "What would you like to do?",hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
                  autofocus: true,
                  onChanged: (value) {
                    task_name = value;
                  },
                ),
              ),
              _date != null
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        
                          margin: EdgeInsets.only(left: 10.0),
                          height: 30.0,
                          decoration: BoxDecoration(
                              
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Colors.grey)),
                          padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.event_available,
                                color: Colors.blue,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "$_date",
                                style: TextStyle(fontSize: 14.0,color:theme.font_color),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                            ],
                          )),
                    )
                  : Container(),
                  SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.event_available,color: Colors.blue[600],),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020,05,01),
                          lastDate: DateTime.now().add(Duration(days: 30)),
                        ).then((value) {
                          _actualDate = value.toString();
                          var date = DateFormat('E, MMM d').format(value);
                          setState(() {
                            _date = date;
                          });
                        });
                      }),
                  FlatButton(
                      onPressed: () {
                        Map task = {
                          'task_name': task_name,
                          'task_date': _actualDate
                        };
                        if (task_name != null && _actualDate != null)
                          Navigator.pop(context, task);
                        else
                          Navigator.pop(context, null);
                      },
                      child: Text("Save",style: TextStyle(color: Colors.blue[600]),))
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}