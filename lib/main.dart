import 'package:demo_weather_app/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'screens/splash_screen.dart'; // Import SplashScreen
import 'services/temperature_unit_provider.dart';
import 'services/notification_service.dart'; // Import NotificationService

String cityName = "Unknown"; // Variable to hold the city name

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Workmanager
  await Workmanager().initialize(
    callbackDispatcher, // The callback function for background tasks
    isInDebugMode: true, // Set to false in production
  );

  runApp(
    
    ChangeNotifierProvider(
      create: (_) => TemperatureUnitProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(), // Wrap SplashScreen in MaterialApp
      ),
    ),
  );
}

// The background task handler function
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WeatherService weatherService = WeatherService();
    NotificationService notificationService = NotificationService(); // Initialize NotificationService
    
    // Use the cityName variable that gets dynamically updated
    var weatherData = await weatherService.fetchCurrentWeather(cityName);

    // Daily Weather Summary Task
    if (task == "dailyWeatherSummary") {
      var forecast = weatherData['forecast']['forecastday'][0]['day'];
      String title = "Today's Weather Forecast";
      String body =
          "$cityName: ${forecast['condition']['text']} with a high of ${forecast['maxtemp_c'].round()}°C and a low of ${forecast['mintemp_c'].round()}°C.";
      await notificationService.sendNotification(title, body); // Send notification
    }
    // Severe Weather Alert Task
    else if (task == "severeWeatherAlertTask") {
      var forecast = weatherData['forecast']['forecastday'][0]['day'];
      if (forecast['daily_chance_of_rain'] > 60) {
        String title = "Weather Alert: Heavy Rain Expected";
        String body =
            "$cityName: Heavy rain expected from 3 PM to 6 PM today. Stay safe!";
        await notificationService.sendNotification(title, body); // Send notification
      }
    }

    return Future.value(true);
  });
}
