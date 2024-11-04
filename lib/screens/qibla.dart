import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';

class QiblaDirectionScreen extends StatefulWidget {
  @override
  _QiblaDirectionScreenState createState() => _QiblaDirectionScreenState();
}

class _QiblaDirectionScreenState extends State<QiblaDirectionScreen> {
  double? _latitude;
  double? _longitude;
  double? _qiblaDirection;
  double? _deviceOrientation;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _listenToGyroscope();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied.');
      }
    }

    // Fetch the user's current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });

    // Fetch Qibla direction
    await _fetchQiblaDirection();
  }

  Future<void> _fetchQiblaDirection() async {
    if (_latitude != null && _longitude != null) {
      final response = await http.get(Uri.parse('http://api.aladhan.com/v1/qibla/$_latitude/$_longitude'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _qiblaDirection = data['data']['direction'];
        });
      } else {
        throw Exception('Failed to load Qibla direction');
      }
    }
  }

  void _listenToGyroscope() {
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        // Calculate the device orientation based on gyroscope data
        _deviceOrientation = event.y; // Adjust based on your specific needs
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Qibla Direction")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_qiblaDirection != null && _deviceOrientation != null)
              Transform.rotate(
                angle: (_qiblaDirection! - _deviceOrientation!).toRadians(),
                child: Icon(Icons.arrow_upward, size: 100, color: Colors.green),
              )
            else
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

extension on double {
  double toRadians() => this * (3.1415926535897932 / 180.0);
}
