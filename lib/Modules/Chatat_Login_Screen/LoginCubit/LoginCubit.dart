

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'LoginStates.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit():super(LoginInitialState());
  static LoginCubit get(context)=>BlocProvider.of(context);

  void UserLogin({
    required String email,
    required String password,
})
  {
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password)
        .then((value)
    {
      print(value.user!.email);
      print(value.user!.uid);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error)
    {
      emit(LoginErrorState(error.toString()));
    });
  }
  bool isPasswordShow = true;
  void PasswordShowed()
  {
    isPasswordShow=!isPasswordShow;
    emit(LoginShowPasswordState());
  }
}