import 'package:flutter/material.dart';

enum ThemeChoice{light,dark}


class Theme {
  final ThemeChoice choice;
   final Color scaffold_color;
   final Color font_color;

   Theme({this.scaffold_color,this.font_color,this.choice}); 



}