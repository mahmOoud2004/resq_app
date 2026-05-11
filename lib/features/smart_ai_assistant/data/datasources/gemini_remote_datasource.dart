// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:resq_app/features/smart_ai_assistant/prompts/medical_analysis_prompt.dart';

// class GeminiRemoteDataSource {
//   late final GenerativeModel _model;

//   GeminiRemoteDataSource() {
//     final apiKey = dotenv.env['GEMINI_API_KEY'];

//     if (apiKey == null || apiKey.isEmpty) {
//       throw Exception('GEMINI_API_KEY is not set in .env file');
//     }

//     _model = GenerativeModel(
//       model: 'gemini-2.0-flash',
//       apiKey: apiKey,
//       systemInstruction: Content.system(
//         MedicalAnalysisPrompt.systemInstruction,
//       ),
//     );
//   }

//   Future<String> analyzeText(String text) async {
//     try {
//       final prompt = MedicalAnalysisPrompt.generatePrompt(text);

//       final response = await _model.generateContent([
//         Content.text(prompt),
//       ]);

//       final responseText = response.text;

//       if (responseText == null || responseText.isEmpty) {
//         throw Exception("Gemini returned empty response.");
//       }

//       return responseText;
//     } catch (e) {
//       throw Exception("Gemini API Error: $e");
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:resq_app/features/smart_ai_assistant/prompts/medical_analysis_prompt.dart';

class GeminiRemoteDataSource {
  final String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  Future<String> analyzeText(String text) async {
    try {
      final apiKey = dotenv.env['GROQ_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GROQ_API_KEY is missing in .env');
      }

      final prompt =
          MedicalAnalysisPrompt.generatePrompt(text);

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "system",
              "content":
                  MedicalAnalysisPrompt.systemInstruction,
            },
            {
              "role": "user",
              "content": prompt,
            }
          ],
          "temperature": 0.2,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Groq API Error: ${response.body}',
        );
      }

      final data = jsonDecode(response.body);

      final content =
          data['choices'][0]['message']['content'];

      if (content == null || content.toString().isEmpty) {
        throw Exception('Empty AI response');
      }

      return content;
    } catch (e) {
      throw Exception('Groq Error: $e');
    }
  }
}