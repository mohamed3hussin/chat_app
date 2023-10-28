
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Network/Local/CacheHelper.dart';
import 'AppStates.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);
  bool isDark= false;

  void ChangeThemMode({bool? fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;
      isDark?SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.deepOrange,
              systemNavigationBarIconBrightness: Brightness.light
          )
      ):SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark
          )
      );
      emit(ChangeThemModeState());
    }
    else{
      isDark = !isDark;
      isDark?SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.deepOrange,
              systemNavigationBarIconBrightness: Brightness.light
          )):SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark
          )
      );
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
      {
        emit(ChangeThemModeState());
      });}

  }

}