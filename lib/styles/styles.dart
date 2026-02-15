import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xFFFFFFFF);
const Color secondaryColor = Color(0xFF6B38FB);

final TextTheme myTextTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(fontSize: 92, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.poppins(fontSize: 57, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.poppins(fontSize: 46, fontWeight: FontWeight.w400),
  headlineMedium: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w400),
  titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleSmall: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  bodySmall: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: secondaryColor,
    primary: primaryColor,
    onPrimary: Colors.black,
    secondary: secondaryColor,
    surface: Colors.grey[50]!, // Slightly off-white surface for cards to pop
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  textTheme: myTextTheme,
  scaffoldBackgroundColor: Colors.grey[100], // Light grey bg for better card contrast
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent, // Modern transparent app bar
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: secondaryColor,
    primary: Colors.black,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  textTheme: myTextTheme.apply(
     bodyColor: Colors.white,
     displayColor: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
);
