part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

final class ThemeModeChange extends ThemeEvent {
  const ThemeModeChange(this.themeMode);
  final ThemeMode? themeMode;
  @override
  List<Object> get props => [themeMode ?? ThemeMode.system];
}
