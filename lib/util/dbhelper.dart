import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' ;
import 'package:todo_bloc/models/todo.dart';


class DbHelper{

  static Database _db;
  static String DBNAME = 'todo';
  static String TABLENAME1 = 'tasks_tbl';
  static String TABLENAME2 = 'subtasks_tbl';
  static String subtask_id = 'subtask_id';
  static String task_id = 'task_id';
  static String task_name = 'task_name';
  static String task_date = 'task_date';
  static String task_status = 'task_status';
  static String task_priority = 'task_priority';

  Future<Database> get db async {
    if(_db!= null) {
      return _db;

    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    Directory appdir = await getApplicationDocumentsDirectory();
    print(appdir);
    String path = join(appdir.path,DBNAME);
    var db = openDatabase(path,version: 1,onCreate: _onCreate,onConfigure: _onConfigure);
    return db;
  }

  _onCreate (Database db , int version) async {
      await db.execute("""
        CREATE TABLE $TABLENAME1(
          $task_id INTEGER PRIMARY KEY AUTOINCREMENT,
          $task_name varchar(255),
          $task_date varchar(255),
          $task_status INTEGER DEFAULT 0,
          $task_priority INTEGER DEFAULT 0
        ); 
      """);
      await db.execute("""
        CREATE TABLE $TABLENAME2(
          $task_id integer,
          $task_name varchar(255),
          $task_status INTEGER DEFAULT 0,
          FOREIGN KEY ($task_id) REFERENCES $TABLENAME1($task_id) ON DELETE CASCADE
        );
      """);
}

_onConfigure(Database db) async {
  await db.execute("PRAGMA foreign_keys = ON");
}

 Future<Task> createTask(Map data) async {
   var dbClient = await db;
   int id = await dbClient.rawInsert("INSERT INTO $TABLENAME1($task_name,$task_date) VALUES(?,?) ;",[data['task_name'],data['task_date']]);
   return Task(id: id,name:data['task_name'],date:DateTime.parse(data['task_date']));
 }

 Future<void> updateTask(Task task) async {
   var dbClient = await db;
   await dbClient.update(TABLENAME1, task.toMap(),where: '$task_id=?',whereArgs: [task.id]);
 }

 Future<void> deleteTask(int id) async {
   var dbClient = await db;
   await dbClient.delete(TABLENAME1,where: '$task_id = ?',whereArgs: [id]);
   await dbClient.delete(TABLENAME2,where: '$task_id = ?',whereArgs: [id]);
 }

 Future<void> addSubtasks(Task task) async{
   var dbClient = await db;
   await dbClient.delete(TABLENAME2,where: '$task_id = ?',whereArgs: [task.id]);
   var batch = dbClient.batch();
   for(var subtask in task.subtasks) {
     batch.insert(TABLENAME2, task.subtasktoMap(subtask));
   }
   await batch.commit(noResult: true); 
 }

 Future<void> deleteCompleted() async {
   var dbClient = await db;
   await dbClient.delete(TABLENAME1,where: '$task_status = 1');
 }

 Future<List<Task>> loadTasks() async {
   var dbClient = await db;
   List<Map> results = await dbClient.rawQuery("SELECT * from $TABLENAME1 ;");
   List<Task> tasks = new List<Task>();
   tasks = await Future.wait( results.map((task) async {
      List<Map> subtask_results = await dbClient.rawQuery("SELECT $task_name,$task_status from $TABLENAME2 where $task_id = ${task['id']};");
      List<Subtask> subtasks = new List<Subtask>();
      if(subtask_results.length > 0) {
        int count = 0;
        subtasks= subtask_results.map((subtask) {
          count += 1;
          Map data = Map.from(subtask);
          data['task_id'] = count;
            Subtask.fromMap(data);
        }).toList();
      }
      Map data = Map.from(task);
      data['subtasks'] = subtasks;
      return Task.fromMap(data);
   }).toList());  
   return tasks;    
 }


  Future close() async => _db.close();

}