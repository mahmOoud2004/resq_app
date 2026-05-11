import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/foundation.dart';

class OcrLocalDataSource {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> recognizeText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      String text = recognizedText.text;
      debugPrint("OCR Extracted Text Length: ${text.length}");
      return text;
    } catch (e) {
      debugPrint("OCR Error: $e");
      throw Exception("Failed to extract text from image: $e");
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
