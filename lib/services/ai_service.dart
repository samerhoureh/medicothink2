import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/medical_report.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  Future<String> generateResponse(String message, List<String> context) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_API_ENDPOINT/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
          'context': context,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      }
      throw Exception('Failed to generate response');
    } catch (e) {
      print('AI response error: $e');
      throw Exception('Failed to communicate with AI service');
    }
  }

  Future<MedicalReport> analyzeMedicalReport(String reportContent) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_API_ENDPOINT/analyze-report'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': reportContent,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MedicalReport.fromJson(data);
      }
      throw Exception('Failed to analyze report');
    } catch (e) {
      print('Report analysis error: $e');
      throw Exception('Failed to analyze medical report');
    }
  }

  Future<double> calculateSimilarity(String report1, String report2) async {
    try {
      final response = await http.post(
        Uri.parse('YOUR_API_ENDPOINT/calculate-similarity'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'report1': report1,
          'report2': report2,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['similarity_score'];
      }
      throw Exception('Failed to calculate similarity');
    } catch (e) {
      print('Similarity calculation error: $e');
      throw Exception('Failed to calculate report similarity');
    }
  }
}