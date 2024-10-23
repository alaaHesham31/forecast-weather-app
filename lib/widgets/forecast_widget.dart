import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_weather_app/services/weather_service.dart';
import 'package:demo_weather_app/services/temperature_unit_provider.dart';

class ForecastWidget extends StatefulWidget {
  final String cityName;

  const ForecastWidget({Key? key, required this.cityName}) : super(key: key);

  @override
  _ForecastWidgetState createState() => _ForecastWidgetState();
}

class _ForecastWidgetState extends State<ForecastWidget> {
  final WeatherService _weatherService = WeatherService();
  late Future<Map<String, dynamic>> _forecastData;

  @override
  void initState() {
    super.initState();
    _forecastData = _weatherService.fetch7DayForecast(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    final tempUnitProvider = Provider.of<TemperatureUnitProvider>(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: _forecastData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        // Extract the forecast days
        List<dynamic> forecastDays = snapshot.data!['forecast']['forecastday'];

        return Column(
          children: forecastDays.map((dayData) {
            String date = dayData['date'];
            int highTempCelsius = dayData['day']['maxtemp_c'].toInt();
            int lowTempCelsius = dayData['day']['mintemp_c'].toInt();
            String condition = dayData['day']['condition']['text'];
            // String iconUrl = 'http:${dayData['day']['condition']['icon']}';
            int avgTempCelsius = dayData['day']['avgtemp_c'].toInt();

            // Convert temperatures based on user preference
            int highTemp = tempUnitProvider
                .convertTemperature(highTempCelsius.toDouble())
                .toInt();
            int lowTemp = tempUnitProvider
                .convertTemperature(lowTempCelsius.toDouble())
                .toInt();
            int avgTemp = tempUnitProvider
                .convertTemperature(avgTempCelsius.toDouble())
                .toInt();

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                height: 110,
                width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _formatDate(date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(getWeatherIcon(condition)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Weather condition and temperatures
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$avgTemp °${tempUnitProvider.selectedUnit == "Celsius" ? "C" : "F"}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Weather condition
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    condition,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            '$highTemp° / $lowTemp°',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Helper function to format the date
  String _formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return '${_getWeekday(date.weekday)}, ${date.day} ${_getMonth(date.month)}';
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

String getWeatherIcon(String condition) {
  if (condition.contains("Sunny")) {
    return 'assets/images/sunny.png';
  } else if (condition.contains("clear")) {
    return 'assets/images/clear.png';
  }else if (condition.contains("rain")) {
    return 'assets/images/rain.png';
  } else if (condition.contains("Partly Cloudy")) {
    return 'assets/images/partly-cloud.png';
  }else if (condition.contains("Cloudy")) {
    return 'assets/images/cloud.png';
  } else if (condition.contains("snow")) {
    return 'assets/images/snow.png';
  }else if (condition.contains("Overcast")) {
    return 'assets/images/overcast.png';
  }
  // Add more conditions and icons as needed
  return 'assets/images/default.png'; // Fallback icon
}
