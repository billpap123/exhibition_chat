import 'package:flutter/material.dart';
import 'chat_page.dart';

void main() {
  runApp(const ExhibitionApp());
}

class ExhibitionApp extends StatelessWidget {
  const ExhibitionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exhibition Chat',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ChatPage(),
    );
  }
}
