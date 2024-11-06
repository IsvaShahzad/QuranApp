// sajda_screen.dart
import 'package:flutter/material.dart';
import '../service/sajda_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import flutter_spinkit package

class SajdaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image with "Sajda Ayahs" title
            Padding(
              padding: EdgeInsets.only(top: 60),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/images/3.png'), // Replace with your header image
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                      bottom: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                      bottom: Radius.circular(30),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Text(
                            'Al Quran,',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Kanit',
                              color: Colors.white70,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'Sajda Ayahs',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // Space below header

            // Bismillah image
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Image.asset(
                'assets/images/bismillah.jpg', // Replace with Bismillah image path
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Fetch and display Sajda ayahs
            FutureBuilder<List<Map<String, dynamic>>>(
              future: Future.wait([
                fetchSajdaAyahs(),       // Fetch English translation
                fetchSajdaAyahsArabic(), // Fetch Arabic text
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitThreeBounce(
                      color: Colors.grey, // Set color for the dots
                      size: 20.0,         // Set size for the dots
                    ),
                  ); // Show loading dots while fetching data
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Check if data is present and not null
                final translations = snapshot.data![0]['data']['ayahs'];
                final arabicTexts = snapshot.data![1]['data']['ayahs'];

                if (translations == null || arabicTexts == null) {
                  return Center(child: Text('No data available'));
                }

                // Display each ayah with Arabic text on top and English translation below
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: translations.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                    thickness: 0.2,
                  ),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffe7dfd9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 13,
                                  backgroundColor: Color(0xff866c55),
                                  child: Text(
                                    '${translations[index]['numberInSurah']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                arabicTexts[index]['text'] ?? 'No Arabic text',
                                style: TextStyle(fontSize: 23),
                                textAlign: TextAlign.end,
                              ),
                              SizedBox(height: 10),
                              Text(
                                translations[index]['text'] ?? 'No English translation',
                                style: TextStyle(fontSize: 15, fontFamily: 'Montserrat'),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
