import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ResultScreen extends StatefulWidget {
  final String plantName;
  final String malayalamName;
  final File image;
  final List<dynamic> commonNames;

  const ResultScreen({
    Key? key,
    required this.plantName,
    required this.malayalamName,
    required this.image,
    required this.commonNames,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> _speakText(String text, String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonNamesStr = widget.commonNames.join(", ");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Result"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(widget.image, height: 250),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("English Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Text(widget.plantName,
                        style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => _speakText(widget.plantName, "en-US"),
                    ),
                  ],
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Malayalam Name:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Text(widget.malayalamName,
                        style: const TextStyle(fontSize: 16)),
                    IconButton(
                      icon: const Icon(Icons.volume_up),
                      onPressed: () => _speakText(widget.malayalamName, "ml-IN"),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            if (commonNamesStr.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Common Names:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(commonNamesStr, style: const TextStyle(fontSize: 16)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
