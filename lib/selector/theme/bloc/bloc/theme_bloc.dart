import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.dark) {
    on<ThemeModeChange>((event, emit) =>emit(event.themeMode??state));
  }
  
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) =>
     // ignore: unnecessary_statements
     ThemeMode.values[json['theme_mode'] as int];
  
  
  @override
  Map<String, dynamic>? toJson(ThemeMode state)=> {'theme_mode':state.index};
}
