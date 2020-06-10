import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:todo_bloc/models/sort.dart';
import 'package:todo_bloc/models/theme.dart';
import 'package:todo_bloc/widgets/widgets.dart';

class Options extends StatelessWidget {

    List<String> options = ["Sort","Clear Completed","Theme"];
    List<String> sortOptions = ["Custom", "Priority", "Date"];
    List<String> themeOptions = ['Dark','Light'];
   int selected = 0;
   int theme_selected;


   Function get_selected;
   Function selected_callback;

  //  Options({this.options,this.sortOptions,this.get_selected,this.selected_callback});


  @override
  Widget build(BuildContext context) {
    final theme = (BlocProvider.of<ThemeBloc>(context).state as ThemeLoaded);
    theme_selected = theme.choice == ThemeChoice.dark? 0: 1;
    print(theme_selected);
    return PopupMenuButton(
            icon: Icon(Icons.more_vert,color: theme.font_color,),
            color:theme.sacffold_color,
            onSelected: (value) async {
              if (value == "Sort") {
                int _optionSelected = await showDialog(
                    context: context,
                    builder: (context) => SortDialog(
                          sortOptions: sortOptions,
                          selected: selected,
                        ));
                selected = _optionSelected;
                if (_optionSelected == 1) {
                  BlocProvider.of<SortBloc>(context).add(SortChoose(choice: SortChoice.priority));
                }
                if (_optionSelected == 2) {
                  BlocProvider.of<SortBloc>(context).add(SortChoose(choice: SortChoice.date));
                }
                if (_optionSelected == 0) {
                  BlocProvider.of<SortBloc>(context).add(SortChoose(choice: SortChoice.custom));
                }
              }
              else if(value == "Clear Completed") {
                BlocProvider.of<TaskBlocBloc>(context).add(ClearCompleted());
              }
              else if(value == 'Theme') {
                int _optionSelected = await showDialog(barrierDismissible: false,context: context,builder: (context) => SortDialog(sortOptions: themeOptions,selected: theme_selected,));
                // print(_optionSelected);
                BlocProvider.of<ThemeBloc>(context).add(ThemeChange(choice: _optionSelected == 0? ThemeChoice.dark : ThemeChoice.light));                
              }
            },
            itemBuilder: (BuildContext context) {
              return options.map((option) {
                return PopupMenuItem(
                  value: option,
                  child: Text(option,style:TextStyle(color: theme.font_color),),
                );
              }).toList();
            },
          );
  }
}