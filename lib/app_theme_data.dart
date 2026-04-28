import 'package:flutter/material.dart';
import 'const.dart';

ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: gray1,
  primaryColor: green,
  colorScheme: ColorScheme.light(
    primary: green,
    secondary: green,
    error: orange,
    surface: white,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: black),
    bodyMedium: TextStyle(color: black),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: green,
    foregroundColor: white,
    elevation: 0,
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(

    backgroundColor: green,
    selectedItemColor: white,
    unselectedItemColor: gray2,
    selectedLabelStyle: TextStyle(color: white),
    unselectedLabelStyle:  TextStyle(color: gray2),

  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: green,
    selectionColor: green.withOpacity(0.3),
    selectionHandleColor: green,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: gray1,

    labelStyle: TextStyle(color: gray2),
    hintStyle: TextStyle(color: gray2),

    prefixIconColor: gray2,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: gray3),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: green, width: 2),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: orange, width: 2),
    ),

    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: orange, width: 2),
    ),

    errorStyle: TextStyle(color: orange),
  ),


);

