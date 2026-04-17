import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppleMapController mapController;
  double speed = 0.0;
  late StreamSubscription<Position> positionStream;

  void _onMapCreated(AppleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _startListeningToGPS();
  }

  Future<void> _startListeningToGPS() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Request location permission
    final permission = await Geolocator.requestPermission();
    
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }
    
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    // Start listening to position updates
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0, // Update on every change
      ),
    ).listen((Position position) {
      setState(() {
        // Convert m/s to km/h (position.speed is in m/s)
        speed = position.speed * 3.6;
      });
      
      // Update map camera to follow user location
      mapController.animateCamera(
        CameraUpdateOptions(
          bearing: position.heading,
          tilt: 0,
          zoom: 17,
          target: LatLng(position.latitude, position.longitude),
        ),
      );
    });
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Row(
        children: [
          // Left half - Speed Display
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Speed',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${speed.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: CupertinoColors.systemGreen,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'km/h',
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right half - Apple Map
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AppleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.7749, -122.4194), // San Francisco
                    zoom: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

