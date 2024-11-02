import 'package:flutter/material.dart';
import 'package:quranapp/service/manzil_service.dart';

// Manzil Screen Widget
class ManzilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manzil 7 Ayahs')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Future.wait([
          fetchManzilUthmani(),      // Fetch Asad translation for Manzil 7
          fetchManzilAsad(), // Fetch Uthmani text for Manzil 7
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

          // Group ayahs by Surah
          Map<String, List<Map<String, dynamic>>> groupedAyahs = {};
          for (var i = 0; i < translations.length; i++) {
            var surahName = translations[i]['surah']['name'];
            if (!groupedAyahs.containsKey(surahName)) {
              groupedAyahs[surahName] = [];
            }
            groupedAyahs[surahName]!.add({
              'arabic': arabicTexts[i]['text'],
              'translation': translations[i]['text'],
            });
          }

          return ListView(
            children: groupedAyahs.entries.map((entry) {
              String surahName = entry.key;
              List<Map<String, dynamic>> ayahs = entry.value;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surahName,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end, // Align Arabic text to the end
                        children: ayahs.map((ayah) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ayah['arabic'],
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right, // Align Arabic text to the right
                                ),
                                SizedBox(height: 5),
                                Text(
                                  ayah['translation'] ?? 'No English translation',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
