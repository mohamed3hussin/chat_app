import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkMode =ThemeData(
  primarySwatch:Colors.deepOrange,
  scaffoldBackgroundColor: Color(0xFF082032),
  appBarTheme: const AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFF082032),//00308F 0xff000739 082032
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.deepOrange,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
    elevation: 0.0,
    titleSpacing: 20,
    backgroundColor: Color(0xFF082032),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    backgroundColor: Color(0xFF0c2e48),
    unselectedItemColor: Colors.grey,
    elevation: 40.0,
  ),

  textTheme:TextTheme(
    bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyText2: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

) ;
ThemeData lightMode = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.black,
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.grey,
    elevation: 40.0,
  ),
  appBarTheme: const AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    titleSpacing: 20,
    elevation: 0.0,
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
    iconTheme: IconThemeData(color: Colors.black),

  ),
  textTheme:TextTheme(
    bodyText1: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyText2: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),

);