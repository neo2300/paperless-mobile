import 'package:flutter/material.dart';
import 'package:paperless_mobile_document_scanner/view/document_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const DocumentScanner(), theme: ThemeData.dark());
  }
}
