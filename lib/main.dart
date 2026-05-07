import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ocr_test/ocr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OCR',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter OCR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ElevatedButton(
              onPressed: pickImageFile,
              child: Text('Pick an image'),
            ),
            Text('Image Path: $imagePath'),
            if (imagePath.isNotEmpty)
              ElevatedButton(
                onPressed: processImage,
                child: Text('Process Image'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImageFile() async {
    FilePickerResult? result = await FilePicker.pickFiles();

    if (result != null) {
      imagePath = result.files.single.path!;
    } else {
      imagePath = '';
    }

    setState(() {});
  }

  void processImage() {
    if (imagePath.isEmpty) return;
    final file = File(imagePath);
    doOcr(file);
  }
}
