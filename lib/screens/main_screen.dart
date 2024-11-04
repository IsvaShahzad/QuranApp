import 'dart:async'; // Import the async library for Timer
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quranapp/main.dart';
import 'package:quranapp/screens/manzil.dart';
import 'package:quranapp/screens/sajda.dart';
import 'package:quranapp/screens/translation.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentDateTime = 'Loading...';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchCurrentTime();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchCurrentTime();
    });
  }

  Future<void> _fetchCurrentTime() async {
    final url =
        'https://tools.aimylogic.com/api/now?tz=Asia/Karachi&format=dd/MM/yyyy';

    try {
      final response = await http.get(Uri.parse(url));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          int hour = data['hour'];
          String period = hour >= 12 ? 'PM' : 'AM';
          hour = hour % 12;
          if (hour == 0) hour = 12;

          _currentDateTime =
          '${data['formatted']} ${hour.toString().padLeft(2, '0')}:${data['minute'].toString().padLeft(2, '0')} $period';
        });
      } else {
        setState(() {
          _currentDateTime = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _currentDateTime = 'Failed to fetch time';
      });
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/quran.png',
      'assets/images/sajda.png',
      'assets/images/manzil.png',
      'assets/images/yaseen.png',
      'assets/images/translation.png',
    ];

    // List of different text for each tile
    final List<String> texts = [
      'Quran',
      'Sajda',
      'Manzil',
      'Yaseen',
      'Translate'
    ];

    // List of pages corresponding to each tile
    final List<Widget> pages = [
      QuranHomePage(),
      SajdaScreen(),
      ManzilScreen(),
      QuranTranslationScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://cdn.pixabay.com/photo/2014/04/08/22/52/texture-319740_640.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 125, bottom: 20),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        _currentDateTime,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded( // Use Expanded to allow the second container to take available space
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: SingleChildScrollView( // Make the inner content scrollable
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
                      shrinkWrap: true, // Allow GridView to size itself
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1, // Adjust this for larger tiles
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => pages[index],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.brown.withOpacity(0.4),
                                  spreadRadius: 3,
                                  blurRadius: 13,
                                  offset: Offset(0, 6),
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 115, left: 47),
                                child: Text(
                                  texts[index],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Kanit',
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
