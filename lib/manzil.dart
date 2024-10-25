import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Manzil7Screen extends StatefulWidget {
  @override
  _Manzil7ScreenState createState() => _Manzil7ScreenState();
}

class _Manzil7ScreenState extends State<Manzil7Screen> {
  List<dynamic> _ayahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchManzil7();
  }

  Future<void> fetchManzil7() async {
    final url = 'http://api.alquran.cloud/v1/manzil/7/quran-uthmani';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _ayahs = data['data']['ayahs']; // Extract ayahs from the response
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Manzil 7');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching Manzil 7: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manzil 7'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _ayahs.length,
        itemBuilder: (context, index) {
          final ayah = _ayahs[index];
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ayah['text'],
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ayah ${ayah['numberInSurah']}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
