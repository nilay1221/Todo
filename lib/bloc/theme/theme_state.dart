part of 'theme_bloc.dart';

@immutable
abstract class ThemeState {}

class ThemeInitial extends ThemeState {}


class ThemeLoaded extends ThemeState {

  final apptheme.Theme theme;

  ThemeLoaded(this.theme);

   apptheme.ThemeChoice get choice => this.theme.choice;
   Color get sacffold_color => this.theme.scaffold_color;
   Color get font_color => this.theme.font_color;

}

