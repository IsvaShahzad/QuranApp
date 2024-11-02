import 'dart:async'; // Import the async library for Timer
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentTimeScreen extends StatefulWidget {
  @override
  _CurrentTimeScreenState createState() => _CurrentTimeScreenState();
}

class _CurrentTimeScreenState extends State<CurrentTimeScreen> {
  String _currentDateTime = 'Loading...';
  String _islamicDate = 'Loading Islamic Date...';
  Timer? _timer; // Declare a Timer variable

  @override
  void initState() {
    super.initState();
    _fetchCurrentTime();
    // Set up a timer to update the time every minute
    _timer = Timer.periodic(Duration(seconds: 10), (timer) { // Update every 10 seconds for testing
      _fetchCurrentTime();
    });
  }

  Future<void> _fetchCurrentTime() async {
    final url = 'https://tools.aimylogic.com/api/now?tz=Asia/Karachi&format=dd/MM/yyyy';

    try {
      final response = await http.get(Uri.parse(url));
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Convert hour to 12-hour format and determine AM/PM
          int hour = data['hour'];
          String period = hour >= 12 ? 'PM' : 'AM';
          hour = hour % 12; // Convert to 12-hour format
          if (hour == 0) hour = 12; // Handle midnight case

          // Combine formatted date with hour, minute, and AM/PM
          _currentDateTime = '${data['formatted']} ${hour.toString().padLeft(2, '0')}:${data['minute'].toString().padLeft(2, '0')} $period'; // Format: dd/MM/yyyy hh:mm AM/PM
        });

        // Fetch Islamic date each time the current time is updated
        await _fetchIslamicDate(data['formatted']); // Pass the date string directly
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

  Future<void> _fetchIslamicDate(String date) async {
    // Use a valid API that returns Islamic date
    final url = 'http://api.aladhan.com/v1/gToH?date=$date'; // Adjust URL as per the actual API used

    try {
      final response = await http.get(Uri.parse(url));
      print('Islamic Date Status Code: ${response.statusCode}');
      print('Islamic Date Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _islamicDate = '${data['data']['hijri']['date']} ${data['data']['hijri']['month']['en']} ${data['data']['hijri']['year']}';
        });
      } else {
        setState(() {
          _islamicDate = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _islamicDate = 'Failed to fetch Islamic date';
      });
      print('Islamic Date Error: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Current Date and Time')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentDateTime,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                _islamicDate,
                style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
