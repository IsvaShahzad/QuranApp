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
  Timer? _timer; // Declare a Timer variable

  @override
  void initState() {
    super.initState();
    _fetchCurrentTime();
    // Set up a timer to update the time every 10 seconds for testing
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
          // Convert hour to 12-hour format and determine AM/PM
          int hour = data['hour'];
          String period = hour >= 12 ? 'PM' : 'AM';
          hour = hour % 12; // Convert to 12-hour format
          if (hour == 0) hour = 12; // Handle midnight case

          // Combine formatted date with hour, minute, and AM/PM
          _currentDateTime =
              '${data['formatted']} ${hour.toString().padLeft(2, '0')}:${data['minute'].toString().padLeft(2, '0')} $period'; // Format: dd/MM/yyyy hh:mm AM/PM
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
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Set the scaffold background to transparent
      appBar: AppBar(title: Text('Current Date and Time')),
      body: Stack(
        children: [
          // Background color or image for the scaffold
          Container(
            color: Colors.grey[
                200], // You can change this to your desired background color
          ),
          // Container with background image
          Container(
            height: 300, // Set the height of the image container
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTuQ4nuo4lX_Dd5sEgqxpjKZaY-7N_NsdyLYQ&s'), // Your image URL
                fit: BoxFit.cover,
              ),
            ),
            // Centering the date and time text inside the image container
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black54, // Semi-transparent background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _currentDateTime,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          // Container for the grid tiles
          Positioned(
            top: 250, // Positioning the grid tiles right below the image container
            left: 0,
            right: 0,
            child: Container(
              height: 600,
              padding: const EdgeInsets.only(top: 50.0,left: 15,right: 15), // Added top padding
              decoration: BoxDecoration(
                color: Colors.white, // Background color for the grid tiles
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25)), // Rounded top corners

              ),
              child: GridView.builder(
                shrinkWrap:
                    true, // Prevents the GridView from expanding to fill the parent
                physics:
                    NeverScrollableScrollPhysics(), // Prevents scrolling of GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of tiles in a row
                  childAspectRatio: 1, // Aspect ratio of each tile
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 4, // Change to your desired number of items
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color for the square border
                      border: Border.all(color: Colors.white, width: 0), // Square border color and width
                      borderRadius: BorderRadius.circular(0), // No rounding for the square border
                    ),
                    child: Card(
                      elevation: 1, // Shadow effect for the card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Ensure corners are square
                      ),
                      child: Center(child: Text('Tile ${index + 1}')),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
