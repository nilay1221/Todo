part of 'sort_bloc.dart';

@immutable
abstract class SortState {}

class SortInitial extends SortState {}


class SortLoad extends SortState {}

class SortLoaded extends SortState {

  final List<Task> tasks ;
  final SortChoice choice;

  SortLoaded({this.tasks,this.choice});


  List<Map<String, dynamic>> sortByTime() {
    Map<String, List<Task>> sorted = Map<String, List<Task>>();
    DateTime today = DateTime.now();
    sorted['overdue'] = List<Task>();
    sorted['today'] = List<Task>();
    sorted['tomorrow'] = List<Task>();
    sorted['7days'] = List<Task>();
    sorted['later'] = List<Task>();
    List<Task> curr_tasks = this.tasks.where((task) => task.status == false).toList();
    curr_tasks.forEach((task) {
      DateTime task_date = task.date;
      print(task_date.day);
      print(today.add(Duration(days: 1)).day);
      if (task_date.day == today.day &&
          task_date.month == today.month &&
          task_date.year == today.year)
        sorted['today'].add(task);
      else if (task_date.difference(today).inDays <= 1 &&
          task_date.day == today.add(Duration(days: 1)).day)
        sorted['tomorrow'].add(task);
      else if ((task_date.difference(today).inDays <= 7 &&
          task_date.difference(today).inDays > 0))
        sorted['7days'].add(task);
      else if ((task_date.difference(today).inDays > 0))
        sorted['later'].add(task);
      else if ((task_date.difference(today).inDays < 0 &&
          task_date.day != today.day)) sorted['overdue'].add(task);
    });

    return [{'title':'Overdue','tasks':sorted['overdue']},{'title':'Today','tasks':sorted['today']},
    {'title':'Tomorrow','tasks':sorted['tomorrow']},{'title':'Next 7 days','tasks':sorted['7days']},
    {'title':'Later','tasks':sorted['later']}
    ];
  }

  List<Task> get uncompleted => this.tasks.where((task) => task.status == false).toList();

  List<Task> get starred => this.tasks.where((task) => task.priority == true && task.status == false).toList();

  List<Task> get unstarred => this.tasks.where((task) => task.priority == false && task.status == false).toList();

  List<Task> get completed => this.tasks.where((task) => task.status == true).toList();


}

