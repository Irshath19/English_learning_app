import 'package:english_learning/AdminPanel/AdminHomePage.dart';
import 'package:english_learning/Components/HomePage.dart';
import 'package:english_learning/AdminPanel/vocalupload.dart';
import 'package:english_learning/Components/video_player_widget.dart';
import 'package:english_learning/Components/vocabulary.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
