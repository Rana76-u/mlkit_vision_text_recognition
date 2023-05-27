import 'package:flutter/material.dart';
import 'package:mlkit_text_recognition/ocr_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OCR Demo',
      home: OCRScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}