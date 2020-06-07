import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/bloc/bloc.dart';
import 'package:todo_bloc/models/sort.dart';
import 'package:todo_bloc/widgets/widgets.dart';

class Options extends StatelessWidget {

    List<String> options = ["Sort"];
    List<String> sortOptions = ["Custom", "Priority", "Date"];
   int selected = 0;


   Function get_selected;
   Function selected_callback;

  //  Options({this.options,this.sortOptions,this.get_selected,this.selected_callback});


  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
            },
            itemBuilder: (BuildContext context) {
              return options.map((option) {
                return PopupMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList();
            },
          );
  }
}