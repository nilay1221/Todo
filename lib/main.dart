import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flare_flutter/asset_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:todo_bloc/screens/home_screen.dart';



void main() {
  FlareCache.doesPrune = false;
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return TaskBlocBloc()..add(TaskLoad());
            },
          ),
          BlocProvider<SortBloc>(
            create: (context) =>
                SortBloc(taskbloc: BlocProvider.of<TaskBlocBloc>(context)),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc()..add(ThemeLoad()),
          )
        ],
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        home: HomeScreem());
  }
}
