import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:nature_scanner/screens/result_screen.dart';
import '../utils/malayalam_dict.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage(_image!);
    }
  }

  Future<void> _uploadImage(File image) async {
    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.plant.id/v2/identify'),
    );

    request.headers['Api-Key'] = 'kM7p0z904FooCN3TulsPhhzuxEBstftJ6KCqEPGSKsUwWonDvd'; // Replace with your real key
    request.files.add(await http.MultipartFile.fromPath('images', image.path));
    request.fields['organs'] = json.encode(['leaf']);

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(respStr);

      final suggestions = jsonResponse['suggestions'] as List;
      final firstSuggestion = suggestions.first;
      final plantName = firstSuggestion['plant_name'];
      final commonNames = firstSuggestion['plant_details']['common_names'] ?? [];

      final malayalamName = malayalamDictionary[plantName] ?? "മലയാളം പേര് ലഭ്യമല്ല";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            plantName: plantName,
            malayalamName: malayalamName,
            image: _image!,
            commonNames: commonNames,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nature Scanner"),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(_image!, height: 300),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text("Start Scanning"),
            ),
          ],
        ),
      ),
    );
  }
}
