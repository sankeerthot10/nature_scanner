import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PlantIdService {
  final String apiKey = 'kM7p0z904FooCN3TulsPhhzuxEBstftJ6KCqEPGSKsUwWonDvd'; // Replace this with your Plant.id API key

  Future<Map<String, dynamic>?> identifyPlant(File imageFile) async {
    final url = Uri.parse('https://api.plant.id/v2/identify');

    final requestBody = jsonEncode({
      "images": [base64Encode(imageFile.readAsBytesSync())],
      "modifiers": ["crops_fast", "similar_images"],
      "plant_language": "en",
      "plant_details": ["common_names", "url", "name_authority", "wiki_description"]
    });

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Api-Key': apiKey,
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to identify plant: ${response.statusCode}');
      return null;
    }
  }
}
