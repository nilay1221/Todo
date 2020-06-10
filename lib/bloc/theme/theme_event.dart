part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ThemeLoad extends ThemeEvent{}



class ThemeChange extends ThemeEvent{

  final apptheme.ThemeChoice choice;

  ThemeChange({this.choice});
}