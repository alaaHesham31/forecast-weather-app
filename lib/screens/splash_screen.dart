import 'package:demo_weather_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class SplashScreen extends StatefulWidget {
  
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _cityName = "Unknown";
  bool _isLoading = false; // Track loading state

  // Function to ask for location permission and get the user's location
Future<void> _getLocationAndNavigate(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  setState(() {
    _isLoading = true; // Start loading when fetching location
  });

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    setState(() {
      _isLoading = false;
    });
    _showLocationDialog(
      context,
      "Location services are disabled. Please enable them.",
      "Enable",
      Geolocator.openLocationSettings,
    );
    return;
  }

  // Check for location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permissions are denied.")),
      );
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    setState(() {
      _isLoading = false;
    });
    _showLocationDialog(
      context,
      "Location permissions are permanently denied. Please enable them in settings.",
      "Open Settings",
      Geolocator.openAppSettings,
    );
    return;
  }

  // Get the current position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  // Get the city name from the coordinates
  List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    setState(() {
      // Use administrativeArea (e.g., province or state) as the main city
      _cityName = placemarks[0].administrativeArea ?? "City not found";
      _isLoading = false;
    });

    // Navigate to HomeScreen and pass the city name
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(cityName: _cityName),
      ),
    );
  } else {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to retrieve city name.")),
    );
  }
}


  // Helper function to show dialog for location issues
  void _showLocationDialog(
      BuildContext context, String message, String buttonText, VoidCallback action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Location Required"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: action,
              child: Text(buttonText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A2344),
              Color.fromARGB(255, 125, 32, 142),
              Colors.purple,
              Color.fromARGB(255, 151, 44, 170),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation
              LottieBuilder.asset(
                "assets/lottie/Animation - 1727217283565.json",
                height: 250, // Adjust the size as needed
              ),

              // Title and Subtitle Text
              const SizedBox(height: 20),
              Text(
                "Weather",
                style: GoogleFonts.lato(
                  fontSize: 70,
                  color: Colors.white,
                ),
              ),
              Text(
                "ForeCasts",
                style: GoogleFonts.lato(
                  fontSize: 60,
                  color: Color.fromARGB(255, 255, 203, 59), // Yellow color
                ),
              ),

              // Button for navigation
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Ask for location and navigate to HomeScreen
                  _getLocationAndNavigate(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 255, 203, 59), // Same yellow as the text
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 70, vertical: 15),
                ),
                child: Text(
                  'Get Start',
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Color.fromARGB(255, 125, 32, 142), // Text color
                  ),
                ),
              ),

              // Loading Indicator
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 255, 203, 59),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
