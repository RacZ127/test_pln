import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feature/todo_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: const Color(0xFFf6f5ee),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFf6f5ee),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        hoverColor: Colors.transparent,
      ),
      home: TodoPage(),
    );
  }
}