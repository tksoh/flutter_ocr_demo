import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
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
      home: SafeArea(
        bottom: true,
        child: const MyHomePage(title: 'Flutter OCR'),
      ),
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
  TextRecognitionScript detectionLang = TextRecognitionScript.chinese;
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final fileName = basename(imagePath);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Pick an image'),
              ),
              if (imagePath.isNotEmpty) ...[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Filename: $fileName'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0, // Border width
                      ),
                    ),
                    child: Image.file(File(imagePath)),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: processImage,
                      child: Text('Read Image Text'),
                    ),
                    _langSelectDropdown(),
                  ],
                ),
                SizedBox(height: 10),
              ],
              if (ocrText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child: Text('OCR Text: \n$ocrText'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Widget _langSelectDropdown() {
    return DropdownMenu<TextRecognitionScript>(
      initialSelection: detectionLang,
      onSelected: (TextRecognitionScript? value) {
        if (value != null) detectionLang = value;
      },
      dropdownMenuEntries: TextRecognitionScript.values
          .map<DropdownMenuEntry<TextRecognitionScript>>((
            TextRecognitionScript status,
          ) {
            return DropdownMenuEntry<TextRecognitionScript>(
              value: status,
              label: status.name, // Accesses the enum's name as a string
            );
          })
          .toList(),
    );
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      ocrText = '';
      imagePath = image.path;
      setState(() {});
    }
  }

  Future<void> processImage() async {
    if (imagePath.isEmpty) return;
    final file = File(imagePath);
    ocrText = await readImageText(file, detectionLang);
    setState(() {});
    Future.delayed(Duration(milliseconds: 100), () => _scrollToBottom());
  }
}
