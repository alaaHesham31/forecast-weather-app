import 'package:demo_weather_app/services/weather_service.dart'; // Service to fetch weather data
import 'package:demo_weather_app/services/temperature_unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherForSearchPage extends StatefulWidget {
  final String cityName;

  const WeatherForSearchPage({super.key, required this.cityName});

  @override
  State<WeatherForSearchPage> createState() => _WeatherForSearchPageState();
}

class _WeatherForSearchPageState extends State<WeatherForSearchPage> {
    Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  bool _hasError = false;

  final WeatherService weatherService = WeatherService(); // Create instance of WeatherService

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  // Fetch weather data based on city name
  Future<void> _fetchWeatherData() async {
    try {
      final weatherData = await weatherService.fetchCurrentWeather(widget.cityName);
      setState(() {
        _weatherData = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tempUnitProvider = Provider.of<TemperatureUnitProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: _isLoading
            ? const CircularProgressIndicator() // Show loading spinner while fetching data
            : _hasError
                ? const Text('Failed to load weather data') // Error handling
                : Column(
                    children: [
                      Container(
                        height: 90,
                        width: 340,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3CCF3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              widget.cityName,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '${tempUnitProvider.convertTemperature(_weatherData?['current']['temp_c'])}° / ${tempUnitProvider.convertTemperature(_weatherData?['forecast']['forecastday'][0]['day']['mintemp_c'])}°',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/sunrise.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    _weatherData?['current']['condition']
                                            ['text'] ??
                                        'Unknown',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      const Text(
                        'your location',
                        style: TextStyle(
                          color: Color.fromARGB(255, 207, 200, 200),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
