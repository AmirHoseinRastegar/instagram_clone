part of 'locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

 final  class LocaleChange extends LocaleEvent {
  const LocaleChange(this.locale);
  final Locale? locale;
 @override
  List<Object> get props => [locale ?? const Object()];
}
