import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<String> readImageText(File imageFile, TextRecognitionScript lang) async {
  final textRecognizer = TextRecognizer(script: lang);
  final inputImage = InputImage.fromFilePath(imageFile.path);
  final RecognizedText recognizedText = await textRecognizer.processImage(
    inputImage,
  );

  String text = recognizedText.text;
  debugPrint('Found text: $text');

  for (TextBlock block in recognizedText.blocks) {
    for (TextLine line in block.lines) {
      debugPrint('Found line: ${line.text}');
    }
  }

  textRecognizer.close();

  return text;
}
