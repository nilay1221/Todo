part of 'sort_bloc.dart';

@immutable
abstract class SortEvent {}

class SortChoose extends SortEvent {

  final SortChoice choice ;

  SortChoose({this.choice});

}

class TasksUpdated extends SortEvent {

  final List<Task> tasks;

  TasksUpdated({this.tasks});

}