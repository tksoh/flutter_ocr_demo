import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ocr_test/ocr.dart';
import 'package:path/path.dart';

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
  String ocrText = '';

  @override
  Widget build(BuildContext context) {
    final fileName = basename(imagePath);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              ElevatedButton(
                onPressed: pickImageFile,
                child: Text('Pick an image'),
              ),
              if (imagePath.isNotEmpty) ...[
                Text('Filename: $fileName'),
                Image.file(File(imagePath)),
                ElevatedButton(
                  onPressed: processImage,
                  child: Text('Read Image Text'),
                ),
              ],

              if (ocrText.isNotEmpty)
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: Text('OCR Text: \n$ocrText'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImageFile() async {
    FilePickerResult? result = await FilePicker.pickFiles();

    if (result != null) {
      ocrText = '';
      imagePath = result.files.single.path!;
    }

    setState(() {});
  }

  Future<void> processImage() async {
    if (imagePath.isEmpty) return;
    final file = File(imagePath);
    ocrText = await readImageText(file);
    setState(() {});
  }
}
