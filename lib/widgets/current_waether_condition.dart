import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:demo_weather_app/services/temperature_unit_provider.dart';

class CurrentWeatherCondition extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const CurrentWeatherCondition({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    final tempUnitProvider = Provider.of<TemperatureUnitProvider>(context);

    // Fetching data from weatherData Map with fallbacks for null values
    double temperatureCelsius = weatherData?['current']['temp_c']?.toDouble() ?? 0.0;
    String weatherCondition = weatherData?['current']['condition']['text'] ?? 'Unknown';
    double highTempCelsius = weatherData?['forecast']['forecastday'][0]['day']['maxtemp_c']?.toDouble() ?? 0.0;
    double lowTempCelsius = weatherData?['forecast']['forecastday'][0]['day']['mintemp_c']?.toDouble() ?? 0.0;
    double windSpeed = weatherData?['current']['wind_kph']?.toDouble() ?? 0.0;
    int pressure = weatherData?['current']['pressure_mb']?.toInt() ?? 0;
    int humidity = weatherData?['current']['humidity']?.toInt() ?? 0;
    int chanceOfRain = weatherData?['forecast']['forecastday'][0]['day']['daily_chance_of_rain']?.toInt() ?? 0;

    // Converting temperature units
    int temperature = tempUnitProvider.convertTemperature(temperatureCelsius);
    int highTemp = tempUnitProvider.convertTemperature(highTempCelsius);
    int lowTemp = tempUnitProvider.convertTemperature(lowTempCelsius);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          height: 420,
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image:  DecorationImage(
                          image: AssetImage( getWeatherIcon(weatherCondition)), // example image
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$temperature °${tempUnitProvider.selectedUnit == "Celsius" ? "C" : "F"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      weatherCondition,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'High: $highTemp°',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Low: $lowTemp°',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.air,
                          color: Colors.white,
                          size: 38,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$windSpeed km/h',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const Text(
                              'Wind Speed',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.thermostat,
                          color: Colors.white,
                          size: 38,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$pressure hPa',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const Text(
                              'Pressure',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.cloudRain,
                          color: Colors.white,
                          size: 34,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$chanceOfRain%',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const Text(
                              'Chance of Rain',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.white,
                          size: 34,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$humidity%',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            const Text(
                              'Humidity',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
  }else{
     if (condition.contains("Sunny")) {
    return 'assets/images/sunny.png';
  } else if (condition.contains("Clear")) {
    return 'assets/images/clear.png';
  }else if (condition.contains("rain")) {
    return 'assets/images/rain.png';
  } else if (condition.contains("Partly cloudy")) {
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
 
}

