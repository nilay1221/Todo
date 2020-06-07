import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_bloc/bloc/sort/sort.dart';
import 'package:todo_bloc/bloc/todo/task_bloc_bloc.dart';
import 'package:todo_bloc/models/sort.dart';
import 'package:todo_bloc/models/todo.dart';

part 'sort_event.dart';
part 'sort_state.dart';

class SortBloc extends Bloc<SortEvent, SortState> {

  final TaskBlocBloc taskbloc;  
  StreamSubscription todosubscription;

  SortBloc({this.taskbloc}) { 
    todosubscription = taskbloc.listen((state) {
      if(state is TaskBlocLoaded) {
        add(TasksUpdated(tasks: (taskbloc.state as TaskBlocLoaded).tasks));
      }
     });

  }

  @override
  SortState get initialState {
    return taskbloc.state is TaskBlocLoaded ? SortLoaded(tasks: (taskbloc.state as TaskBlocLoaded).tasks,choice: SortChoice.custom) : SortLoad();
  }

  @override
  Stream<SortState> mapEventToState(
    SortEvent event,
  ) async* {
      if(event is TasksUpdated) {
        yield* _mapTasksUpdatedtoState(event);
      }
      else if(event is SortChoose) {
        yield* _mapSortChoosetoState(event);
      }
  }


Stream<SortState>  _mapTasksUpdatedtoState(TasksUpdated event) async* {

    yield SortLoaded(tasks: (taskbloc.state as TaskBlocLoaded).tasks,choice: state is SortLoaded ? (state as SortLoaded).choice : SortChoice.custom );

  }

Stream<SortState>  _mapSortChoosetoState(SortChoose event) async* {
    yield SortLoaded(tasks:(taskbloc.state as TaskBlocLoaded).tasks,choice: event.choice);   
  }

  @override
  Future<void> close() {
    todosubscription.cancel();
    return super.close();
  }
}
