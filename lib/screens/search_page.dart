import 'package:demo_weather_app/services/temperature_unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:demo_weather_app/services/weather_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// FlutterLocalNotificationsPlugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SearchPage extends StatefulWidget {
  final String cityName;
  final Map<String, dynamic>? weatherData;

  const SearchPage({Key? key, required this.cityName, this.weatherData})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  Future<Map<String, dynamic>>? _currentWeather;
  bool _isSearching = false; // Flag to track search state

  List<String> _cities = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Sharm El Sheikh',
    'Luxor',
    'Aswan',
    'Hurghada',
    'Port Said',
    'Suez',
    'Mansoura',
    'Ismailia',
    'Tanta',
    'Damanhur',
    'Faiyum',
    'Minya',
    'Beni Suef',
    'Qena',
    'Sohag',
    'Cairo Governorate',
    'Giza Governorate',
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities; // Initialize with all cities
    // Fetch current weather for the initial city (passed from home screen)
    if (widget.cityName.isNotEmpty) {
      _currentWeather = _weatherService.fetchCurrentWeather(widget.cityName);
    }
  }

  void _onTextChanged(String text) {
    setState(() {
      _isSearching = text.isNotEmpty; // Show list when typing
      _filteredCities = _cities
          .where((city) => city.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _onSearch(String city) async {
    // Fetch weather data for the selected city
    var newWeatherData = await _weatherService.fetchCurrentWeather(city);

    // Check if there is a high chance of rain
    bool hasRainAlert = newWeatherData['forecast']['forecastday'][0]['day']
            ['daily_chance_of_rain'] >
        60;

    // Build the notification content
    String title = "Weather Summary for $city";
    String weatherCondition = newWeatherData['current']['condition']['text'];
    double temp = newWeatherData['current']['temp_c'];
    String body = "$city: $weatherCondition, temperature: ${temp.round()}°C";

    if (hasRainAlert) {
      body += "\nAlert: Heavy rain expected.";
    }

    // Send the notification
    _sendNotification(title, body);

    // Pass the updated city and weather data back to the home screen
    Navigator.pop(context, {
      'city': city,
      'weatherData': newWeatherData,
    });
  }

  // Function to send notification
  void _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'weather_channel_id', 'Weather Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tempUnitProvider = Provider.of<TemperatureUnitProvider>(context);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Space at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _onTextChanged,
                      decoration: InputDecoration(
                        hintText: 'Search for a location',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Go back without selecting
                          },
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Show current weather if the user is NOT searching and weather data is available
            if (!_isSearching && _currentWeather != null)
              FutureBuilder<Map<String, dynamic>>(
                future: _currentWeather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show loading indicator
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    var weatherData = snapshot.data!;
                    double temperatureCelsius =
                        weatherData['current']['temp_c']?.toDouble() ?? 0.0;
                    double lowTempCelsius = weatherData['forecast']
                                ['forecastday'][0]['day']['mintemp_c']
                            ?.toDouble() ??
                        0.0;
                    String weatherCondition = weatherData['current']
                            ['condition']['text'] ??
                        'Unknown';

                    int temperature =
                        tempUnitProvider.convertTemperature(temperatureCelsius);
                    int lowTemp =
                        tempUnitProvider.convertTemperature(lowTempCelsius);

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.cityName,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  Text(
                                    '$temperature° / $lowTemp°',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            getWeatherIcon(weatherCondition)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    weatherCondition,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

            // Show the list of cities only when the user starts typing
            if (_isSearching)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.location_on_outlined,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _filteredCities[index],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              _onSearch(_filteredCities[
                                  index]); // Pass selected city and fetch weather
                            },
                            child: const Text('Search',
                                style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

bool isNightTime() {
  final hour = DateTime.now().hour;
  return hour < 6 || hour > 18; // Consider night between 6 PM and 6 AM
}

String getWeatherIcon(String condition) {
  if (isNightTime()) {
    return 'assets/images/moon.png'; // Moon icon for night
  } else {
    if (condition.contains("Sunny")) {
      return 'assets/images/sunny.png';
    } else if (condition.contains("clear")) {
      return 'assets/images/clear.png';
    } else if (condition.contains("rain")) {
      return 'assets/images/rain.png';
    } else if (condition.contains("Partly Cloudy")) {
      return 'assets/images/partly-cloud.png';
    } else if (condition.contains("Cloudy")) {
      return 'assets/images/cloud.png';
    } else if (condition.contains("snow")) {
      return 'assets/images/snow.png';
    }else if (condition.contains("Overcast")) {
    return 'assets/images/overcast.png';
  }
    // Add more conditions and icons as needed
    return 'assets/images/default.png'; // Fallback icon
  }
}
