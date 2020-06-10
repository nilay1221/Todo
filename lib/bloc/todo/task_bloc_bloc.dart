import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flare_flutter/asset_provider.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:todo_bloc/models/todo.dart';
import 'package:todo_bloc/util/dbhelper.dart';

part 'task_bloc_event.dart';
part 'task_bloc_state.dart';

class TaskBlocBloc extends Bloc<TaskBlocEvent, TaskBlocState> {

  DbHelper dbHelper = DbHelper();

  @override
  TaskBlocState get initialState => TaskBlocLoad();

  @override
  Stream<TaskBlocState> mapEventToState(
    TaskBlocEvent event,
  ) async* {

    if(event is TaskLoad) {
      yield* _mapTaskLoadtoState();
    }
    if(event is TaskAdd) {
      yield* _mapTaskAddtoState(event);
    }
    if(event is TaskComplete) {
      yield* _mapTaskCompletetoState(event);
    }
    if(event is TaskDelete) {
      yield* _mapTaskDeletetoState(event);
    }
    if(event is TaskStarred) {
      yield* _mapTaskStarredtoState(event);
    }
    if(event is TaskUpdate) {
      yield* _mapTaskUpdatetoState(event);
    }
    if(event is ClearCompleted) {
      yield * _mapClearCompletedtoState();
    }

  }

    final AssetProvider assetProvider =
    AssetFlare(bundle: rootBundle, name: 'assets/test_2.flr');

Future<void> _warmupAnimations() async {
  await cachedActor(assetProvider);
}


  Stream<TaskBlocState> _mapTaskLoadtoState() async* {
     List<Task> tasks = await dbHelper.loadTasks();
     await _warmupAnimations();
     yield TaskBlocLoaded(tasks: tasks);
  }

  Stream<TaskBlocState> _mapTaskAddtoState(TaskAdd event) async* {
      if(state is TaskBlocLoaded) {
        final updatedTask = await dbHelper.createTask(event.task);
        final List<Task> updatedTasks = List.from((state as TaskBlocLoaded).tasks)..add(updatedTask);
        yield TaskBlocLoaded(tasks: updatedTasks);
      }
  }

  Stream<TaskBlocState> _mapTaskCompletetoState(TaskComplete event) async* {
    if(state is TaskBlocLoaded) {
      event.task.updateTask(status: !event.task.status);
      await dbHelper.updateTask(event.task);
      final List<Task> updatedTasks  = (state as TaskBlocLoaded).tasks.map((task) {
          return task.id == event.task.id ? event.task : task ;
      }).toList();
      yield TaskBlocLoaded(tasks: updatedTasks);
    }
  }

  Stream<TaskBlocState> _mapTaskDeletetoState(TaskDelete event) async* {
    if(state is TaskBlocLoaded) {
      await dbHelper.deleteTask(event.task.id);
      final List<Task> updatedTasks = (state as TaskBlocLoaded).tasks.where((task) => task.id != event.task.id).toList();
      yield TaskBlocLoaded(tasks: updatedTasks);
    }
  }
  Stream<TaskBlocState> _mapTaskStarredtoState(TaskStarred event) async* {
    if(state is TaskBlocLoaded) {
      event.task.updateTask(priority: !event.task.priority);
      await dbHelper.updateTask(event.task);
      final List<Task> updatedTasks  = (state as TaskBlocLoaded).tasks.map((task) {
          return task.id == event.task.id ? event.task : task ;
      }).toList();
      yield TaskBlocLoaded(tasks: updatedTasks);
    }
  }

  Stream<TaskBlocState> _mapTaskUpdatetoState(TaskUpdate event) async* {
      if(state is TaskBlocLoaded) {
          await dbHelper.updateTask(event.task);
          final List<Task> updatedTasks = (state as TaskBlocLoaded).tasks.map((task){
            return task.id == event.task.id ? event.task : task;
          }).toList();
        yield TaskBlocLoaded(tasks: updatedTasks);

      }
    }

    Stream<TaskBlocState> _mapClearCompletedtoState() async* {
      if(state is TaskBlocLoaded) {
        await dbHelper.deleteCompleted();
        final List<Task> updatedTasks = (state as TaskBlocLoaded).tasks.where((task) => task.status == false).toList();
        yield TaskBlocLoaded(tasks: updatedTasks);
        
      }
 
    }




}

