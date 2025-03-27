import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<bool> {
  AuthCubit() : super(true);

  void toggleAuthScreen({required bool showLogin}) => emit(showLogin);
}
