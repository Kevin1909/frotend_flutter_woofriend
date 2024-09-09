import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorPrimaryTheme = Color(0xFF40A2D8);
const colorSecondaryTheme = Color(0xFFFFFFFF);
const colorTertiaryTheme = Color(0xFF000000);

class AppTheme {
  ThemeData getTheme() => ThemeData(

      ///* General
      useMaterial3: true,
      colorSchemeSeed: colorPrimaryTheme,

      ///* Texts
      textTheme: TextTheme(
        titleLarge:
            GoogleFonts.nerkoOne(fontSize: 40, fontWeight: FontWeight.bold),
        titleMedium:
            GoogleFonts.nerkoOne(fontSize: 30, fontWeight: FontWeight.bold),
        titleSmall: GoogleFonts.nerkoOne(
            fontSize: 20,
            color: colorPrimaryTheme,
            fontWeight: FontWeight.normal),
        labelMedium: GoogleFonts.nerkoOne(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium:
            GoogleFonts.nerkoOne(fontSize: 17, fontWeight: FontWeight.normal),
      ),

      ///* Scaffold Background Color
      scaffoldBackgroundColor: colorSecondaryTheme,

      ///* Buttons
      filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(GoogleFonts.nerkoOne(
                  fontWeight: FontWeight.bold, fontSize: 18)))),

      ///* AppBar
      appBarTheme: AppBarTheme(
        color: colorPrimaryTheme,
        titleTextStyle: GoogleFonts.nerkoOne(
            fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
      ));
}
