part of 'task_bloc_bloc.dart';

@immutable
abstract class TaskBlocState {}

class TaskBlocLoad extends TaskBlocState {}


class TaskBlocLoaded extends TaskBlocState{

  List<Task> tasks ;

  TaskBlocLoaded({this.tasks});

  List<Task> uncompleteTasks() {
    List<Task> _uncompletedtasks = this.tasks.where((task) => task.status == false).toList();
    return _uncompletedtasks;
  }

  List<Task> completedTasks() {
    List<Task> _completedtasks = this.tasks.where((task) => task.status == true).toList();
    return _completedtasks;
  }

  Task gettask(int id) => this.tasks.firstWhere((task) => task.id == id);



  @override
  String toString() => 'TasksLoaded {tasks : $tasks}';

}