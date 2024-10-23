import 'package:demo_weather_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Notification setup
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _cityName = "Unknown";
  bool _isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    _initializeNotification(); // Initialize notifications
  }

  // Initialize local notifications
  Future<void> _initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Function to show weather notification
  Future<void> _showWeatherNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Channel ID
      'your_channel_name', // Channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Weather Alert', // Notification title
      'Check out the latest weather update!', // Notification body
      platformChannelSpecifics,
    );
  }

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
        String? cityName = placemarks[0].administrativeArea ?? "City not found";
        if (cityName.contains("Government")) {
          cityName = cityName.replaceAll("Government", "").trim();
        }

        _cityName = cityName; // Assign the processed city name
        _isLoading = false;
      });

      // Navigate to HomeScreen and pass the city name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(cityName: _cityName),
        ),
      );

      // Register the background task for notification
      Workmanager().registerOneOffTask("weatherNotificationTask", "weatherNotificationTask");
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to retrieve city name.")),
      );
    }
    // Register daily summary notification task once city is detected
  Workmanager().registerPeriodicTask(
    "dailyWeatherSummary",
    "dailyWeatherSummary",
    frequency: const Duration(hours: 24), // Daily
    initialDelay: const Duration(hours: 8), // 8 AM every day
  );

  // Example for severe weather alerts or other notifications
  Workmanager().registerOneOffTask("severeWeatherAlertTask", "severeWeatherAlertTask");

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => HomeScreen(cityName: _cityName),
    ),
  );
  }

  // Helper function to show dialog for location issues
  void _showLocationDialog(
      BuildContext context, String message, String buttonText, VoidCallback action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:const Text("Location Required"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: action,
              child: Text(buttonText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
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
                  color: const Color.fromARGB(255, 255, 203, 59), // Yellow color
                ),
              ),

              // Button for navigation
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Ask for location and navigate to HomeScreen
                  _getLocationAndNavigate(context);
                  _showWeatherNotification(); // Show notification immediately for testing
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 203, 59), // Same yellow as the text
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
                    color: const Color.fromARGB(255, 125, 32, 142), // Text color
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
