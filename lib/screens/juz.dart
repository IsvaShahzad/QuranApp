import 'package:flutter/material.dart';
import 'package:quranapp/service/juz_service.dart';

// Juz30 Screen Widget
class Juz30Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Juz 30')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Future.wait([
          fetchJuz30Asad(),      // Fetch Asad translation
          fetchJuz30Uthmani(),   // Fetch Uthmani text
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Check if data is present and not null
          final translations = snapshot.data![0]['data']['ayahs'];
          final arabicTexts = snapshot.data![1]['data']['ayahs'];

          // Handle case where data may be null
          if (translations == null || arabicTexts == null) {
            return Center(child: Text('No data available'));
          }

          return ListView.builder(
            itemCount: translations.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arabicTexts[index]['text'] ?? 'No Arabic text',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end, // Align Arabic text to the end
                      ),
                      SizedBox(height: 10),
                      Text(
                        translations[index]['text'] ?? 'No English translation',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
