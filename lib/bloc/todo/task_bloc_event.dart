part of 'task_bloc_bloc.dart';

@immutable
abstract class TaskBlocEvent {}


class TaskLoad extends TaskBlocEvent{}

class TaskAdd extends TaskBlocEvent{
  
  final Map task;

  TaskAdd({this.task});

  @override
  String toString() {
   return  'TaskAdd {task : $task}' ;
  }

}

class TaskUpdate extends TaskBlocEvent{
  
  final Task task;

  TaskUpdate({this.task});

  @override
  String toString() {
   return  'TaskUpdate {task : $task}' ;
  }

}

class TaskComplete extends TaskBlocEvent{
  
  final Task task;

  TaskComplete({this.task});

  @override
  String toString() {
   return  'TaskComplete {task : $task}' ;
  }
}

  class TaskPriority extends TaskBlocEvent{
  
  final Task task;

  TaskPriority({this.task});

  @override
  String toString() {
   return  'TaskPriority {task : $task}' ;
  }

}

  class TaskDelete extends TaskBlocEvent{
  
  final Task task;

  TaskDelete({this.task});

  @override
  String toString() {
   return  'TaskDelete {task : $task}' ;
  }

}

  class TaskStarred extends TaskBlocEvent{
  
  final Task task;

  TaskStarred({this.task});

  @override
  String toString() {
   return  'TaskStarred {task : $task}' ;
  }

}