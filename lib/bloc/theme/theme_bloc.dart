import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_bloc/models/theme.dart' as apptheme; 

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState => ThemeInitial();

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if(event is ThemeLoad) {
      yield* _mapThemeLoadtoState() ;
    }
    if(event is ThemeChange) {
      yield * _mapThemeCHangetoState(event);
    }

  }

  Stream<ThemeState> _mapThemeLoadtoState() async* {

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String theme = preferences.getString('theme') ?? 'Light';
      if (theme == 'Light') {
        yield ThemeLoaded(apptheme.Theme(scaffold_color: Colors.white,font_color:Colors.black,choice: apptheme.ThemeChoice.light));
      }
      else if(theme == 'Dark'){
        yield ThemeLoaded(apptheme.Theme(scaffold_color: Colors.black,font_color: Colors.white,choice: apptheme.ThemeChoice.dark));
      }
  }

  Stream<ThemeState> _mapThemeCHangetoState(ThemeChange event) async* {
      print('yielding');
    if(event.choice == apptheme.ThemeChoice.dark) {
        yield ThemeLoaded(apptheme.Theme(scaffold_color: Colors.black,font_color: Colors.white,choice:event.choice));
    }
    else if(event.choice == apptheme.ThemeChoice.light) {
        yield ThemeLoaded(apptheme.Theme(scaffold_color: Colors.white,font_color:Colors.black,choice: event.choice));
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('theme', event.choice == apptheme.ThemeChoice.dark ? 'Dark' : 'Light');

  }
}
