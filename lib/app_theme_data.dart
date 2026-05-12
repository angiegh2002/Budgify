import 'package:budgify/services/cache_helper.dart';
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

  cardColor: white,
  textTheme:  TextTheme(
    bodyLarge: TextStyle(color: black),
    bodyMedium: TextStyle(color: black),
    bodySmall: TextStyle(color: gray4),
  ),

  appBarTheme:  AppBarTheme(
    backgroundColor: green,
    foregroundColor: white,
    elevation: 0,
    centerTitle: true,
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


ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: grayDarkM,
  primaryColor: green,

  colorScheme: ColorScheme.dark(
    primary: green,
    secondary: green,
    error: orange,
    surface: darkM,
    onPrimary: white,
    onSurface: white,
    onError: white,
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: white),
    bodyMedium: TextStyle(color: white),
    titleLarge: TextStyle(color: white),
    bodySmall: TextStyle(color: gray4),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: green,
    foregroundColor: white,
    elevation: 0,
    centerTitle: true,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: grayDarkM,
    labelStyle: const TextStyle(color: gray2),
    hintStyle: const TextStyle(color: gray2),
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