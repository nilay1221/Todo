
class Subtask {
  int id;
  String name;
  bool status = false;

  Subtask({this.name,this.status,this.id});

  factory Subtask.fromMap(Map data) {
    return Subtask(name: data['task_name'],status: data['task_status'],id: data['task_id']);
  }

  Subtask.empty({this.id});

}


class Task {

  int id;
  String name;
  DateTime date;
  bool status = false;
  bool priority = false;
  List<Subtask> subtasks = new List<Subtask>();

  Task({this.id,this.name,this.date});

  Task.withsubtask({this.id,this.name,this.date,this.status,this.priority,this.subtasks});

  void updateTask({String name,DateTime date,bool status,bool priority,List<Subtask> subtask}) {
    this.name = name ?? this.name;
    this.date = date ?? this.date;
    this.status = status ?? this.status;
    this.priority = priority ?? this.priority;
    this.subtasks = subtasks ?? this.subtasks;
  }

  List<Subtask> get uncompletedsubtasks => this.subtasks.where((subtask) => subtask.status == false).toList();
  List<Subtask> get completedsubtasks => this.subtasks.where((subtask) => subtask.status == true).toList();
  


  Map<String,dynamic> toMap() {
    
    return {
      'task_name' : this.name,
      'task_date' : this.date.toString(),
      'task_status' : this.status ? 1: 0,
      'task_priority' : this.priority? 1: 0,
    };
  }

  Map subtasktoMap(Subtask subtask) {
    return {
      'task_id' : this.id,
      'task_name' : subtask.name,
      'task_status' : subtask.status ? 1:0
    };

  }

  factory Task.fromMap(Map data) {
    List<Subtask> subtasks;
    if(data['subtasks'].length > 0 ) {
        subtasks = data['subtasks'].map((subtask) {
      Subtask.fromMap(subtask);
    }).toList();
    }
    else{
      subtasks = new List<Subtask>();
    }
    
    return Task.withsubtask(id:data['task_id'],name: data['task_name'],date:DateTime.parse(data['task_date']),status: data['task_status']== 1?true:false,priority: data['task_priority'] == 1? true:false,subtasks: subtasks);
  }
  
}