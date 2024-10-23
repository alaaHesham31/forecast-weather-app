import 'package:flutter/material.dart';
import 'package:demo_weather_app/services/weather_service.dart';
import 'package:demo_weather_app/widgets/current_waether_condition.dart';
import 'package:demo_weather_app/widgets/forecast_widget.dart';
import 'package:demo_weather_app/widgets/search_bar_widget.dart';
import 'package:demo_weather_app/widgets/sunrise_widget.dart';
import 'package:demo_weather_app/widgets/sunset_widget.dart';

class HomeScreen extends StatefulWidget {
  final String cityName;

  const HomeScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _currentWeather;
  bool _isLoading = true;
  late String _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.cityName; // Start with the city passed to HomeScreen
    _fetchWeather();
  }

  // Function to fetch weather data
  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weatherData = await _weatherService.fetchCurrentWeather(_selectedCity);
      setState(() {
        _currentWeather = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to handle city selection from SearchBarWidget
  void _onCitySelected(String newCity) {
    setState(() {
      _selectedCity = newCity;
    });
    _fetchWeather(); // Fetch weather for the new city
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      // Pass the onCitySelected callback to SearchBarWidget
                      child: SearchBarWidget(
                        cityName: _selectedCity,
                        onCitySelected: _onCitySelected,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Current Conditions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_currentWeather != null)
                      CurrentWeatherCondition(
                        weatherData: _currentWeather, // Pass weather data map here
                      ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 15),
                      child: Text(
                        'Sunrise & Sunset',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SunriseWidget(weatherData: _currentWeather),
                    SunsetWidget(weatherData: _currentWeather),
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 15),
                      child: Text(
                        '7-day forecast',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (!_isLoading)
                      ForecastWidget(cityName: _selectedCity)
                    else
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 203, 59),),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
