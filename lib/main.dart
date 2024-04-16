import 'package:chatbot_and_image_generator/colors.dart';
import 'package:chatbot_and_image_generator/homepage.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Assistant';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: My_Colors.whiteColor,
          appBarTheme: AppBarTheme(backgroundColor: My_Colors.whiteColor)),
      home: Homepage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatgpt and Dell e2',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: Text(""),
    );
  }
}
