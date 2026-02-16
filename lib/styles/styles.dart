import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFF6B38FB);
const Color secondaryColor = Color(0xFFFFAB40);

final TextTheme myTextTheme = TextTheme(
  headlineMedium: GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
  titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
  bodyLarge: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400),
  bodyMedium: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400),
  bodySmall: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    secondary: secondaryColor,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  textTheme: myTextTheme,
  scaffoldBackgroundColor: const Color(0xFFF8F9FA),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: primaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: Colors.white,
    surface: const Color(0xFF1E1E1E),
    onSurface: Colors.white,
  ).copyWith(secondary: secondaryColor, onSecondary: Colors.black),
  textTheme: myTextTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: const Color(0xFF2C2C2C),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white38),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[700]!),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: secondaryColor),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
