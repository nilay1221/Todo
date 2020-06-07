
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/bloc.dart' ;
import 'package:todo_bloc/models/sort.dart';
import 'package:todo_bloc/widgets/widgets.dart';

class HomeScreem extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tasks"),
      actions: <Widget>[
        Options(),
      ],
      ),
      body: BlocBuilder<SortBloc,SortState>(
        builder: (context,state) {
            if(state is SortLoad) {
              return Loading();
            }
            else if(state is SortLoaded){
              if((state as SortLoaded).uncompleted.length == 0) {
                  return Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage:AssetImage('images/logo.jpg'),
                            radius: 65.0,
                          ),
                          SizedBox(height: 20.0,),
                          Text("You're all done for today.",style: TextStyle(fontSize: 16.0,color: Colors.black54),),
                        ],
                      ),
                    )
                  
                  ,);
              }
              else if(state.choice == SortChoice.custom) {
                  return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: <Widget>[
                  ExpandedTile(title: 'Uncompleted Tasks',list: state.uncompleted,),
                  ExpandedTile(title: 'Completed Tasks',list: state.completed)
                ],),
              );
              }
              else if(state.choice == SortChoice.date) {
                var _tasklist = state.sortByTime();
                return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _tasklist.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(_tasklist[index]['tasks'].length > 0) {
                    return SizedBox(
                      child: ExpandedTile(title: '${_tasklist[index]['title']}',list: _tasklist[index]['tasks'],),
                    );
                      }
                      else{
                        return Container();
                      }
                   },
                  )
                ],),
              );
                
              }
              else if(state.choice == SortChoice.priority) {
                
                return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: <Widget>[
                  state.starred.length > 0? ExpandedTile(title: 'Priority',list: state.starred,) : Container(width: 0.0,height: 0.0,),
                  ExpandedTile(title: 'No Priority',list: state.unstarred),
                  ExpandedTile(title: 'Completed',list: state.completed)
                ],),
              );
              }
              
            }
        } 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map task = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              builder: (context) => ModalSheet());
          if (task != null) {
            BlocProvider.of<TaskBlocBloc>(context).add(TaskAdd(task: task));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}