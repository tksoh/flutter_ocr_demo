import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> readImageText(File imageFile) async {
  // 1. Create an instance (can specify script like Latin, Chinese, etc.)
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);

  // 2. Prepare the image (from a file path or camera stream)
  final inputImage = InputImage.fromFilePath(imageFile.path);

  // 3. Process the image
  final RecognizedText recognizedText = await textRecognizer.processImage(
    inputImage,
  );

  // 4. Extract data
  String text = recognizedText.text; // The full raw text
  debugPrint('Found text: $text');

  for (TextBlock block in recognizedText.blocks) {
    for (TextLine line in block.lines) {
      debugPrint('Found line: ${line.text}');
    }
  }

  // 5. Always close the recognizer when done
  textRecognizer.close();

  return text;
}
