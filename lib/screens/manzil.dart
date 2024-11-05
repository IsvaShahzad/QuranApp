import 'package:flutter/material.dart';
import 'package:quranapp/service/manzil_service.dart';
import 'package:google_fonts/google_fonts.dart';

// Manzil Screen Widget
class ManzilScreen extends StatelessWidget {
  final int manzilNumber;

  ManzilScreen({this.manzilNumber = 1});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manzil $manzilNumber Ayahs')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchManzil(manzilNumber),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final ayahs = snapshot.data?['data']['ayahs'];
          if (ayahs == null || ayahs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Group ayahs by Surah
          Map<String, List<Map<String, dynamic>>> groupedAyahs = {};
          for (var ayah in ayahs) {
            var surahName = ayah['surah']['name'];
            if (!groupedAyahs.containsKey(surahName)) {
              groupedAyahs[surahName] = [];
            }
            groupedAyahs[surahName]!.add({
              'arabic': ayah['text'],
              'translation': ayah['translation'] ?? 'No English translation',
            });
          }

          return Scrollbar(
            child: ListView(
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
                          style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: ayahs.map((ayah) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ayah['arabic'],
                                    style: GoogleFonts.allura(fontSize: 24, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    ayah['translation'],
                                    style: GoogleFonts.cairo(fontSize: 16),
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
            ),
          );
        },
      ),
    );
  }
}
