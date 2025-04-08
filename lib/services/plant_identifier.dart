import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlantIdentifier {
  static const String apiKey = 'kM7p0z904FooCN3TulsPhhzuxEBstftJ6KCqEPGSKsUwWonDvd'; // Replace with your actual key

  static Future<Map<String, dynamic>> identifyPlant(File imageFile) async {
    final url = Uri.parse('https://api.plant.id/v2/identify');
    final base64Image = base64Encode(await imageFile.readAsBytes());

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Api-Key': apiKey,
      },
      body: jsonEncode({
        'images': [base64Image],
        'organs': ['leaf'],
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to identify plant');
    }
  }
}
