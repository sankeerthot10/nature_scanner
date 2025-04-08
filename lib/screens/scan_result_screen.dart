import 'package:flutter/material.dart';

class ScanResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ScanResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suggestions = result['suggestions'] ?? [];
    final first = suggestions.isNotEmpty ? suggestions[0] : null;
    final plantName = first?['plant_name'] ?? 'Unknown';
    final commonNames = first?['plant_details']?['common_names']?.join(', ') ?? 'N/A';
    final wikiUrl = first?['plant_details']?['url'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Result'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: first == null
            ? const Center(child: Text('No result found'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scientific Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(plantName, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text(
              'Common Names:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(commonNames, style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            if (wikiUrl.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () {
                  // You can add launch URL if needed
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('Learn More'),
              ),
          ],
        ),
      ),
    );
  }
}
