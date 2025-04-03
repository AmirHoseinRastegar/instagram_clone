import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordtoggleCubit extends Cubit<bool> {
  ForgotPasswordtoggleCubit() : super(true);
  void toggleScreen(  {required bool showForgotPasswordScreen}) =>
      emit(showForgotPasswordScreen);
}
