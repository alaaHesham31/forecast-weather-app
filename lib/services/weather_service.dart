import 'package:dio/dio.dart';

class WeatherService {
  final String apiKey = 'ffbb02b6eef34eeaa44124223242710';
  final String forecastBaseUrl = 'http://api.weatherapi.com/v1/forecast.json';
  final String searchBaseUrl = 'http://api.weatherapi.com/v1/search.json';
  final String reverseGeocodeUrl = 'http://api.weatherapi.com/v1/current.json';

  final Dio dio = Dio();

  // Fetch current weather (1 day)
  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final url = '$forecastBaseUrl?key=$apiKey&q=$city&days=1&aqi=no&alerts=no';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }

  // Fetch 7-day forecast
  Future<Map<String, dynamic>> fetch7DayForecast(String city) async {
    final url = '$forecastBaseUrl?key=$apiKey&q=$city&days=7&aqi=no&alerts=no';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load 7-day forecast');
      }
    } catch (e) {
      throw Exception('Failed to load 7-day forecast: $e');
    }
  }

  // Fetch city name based on coordinates
  Future<String> fetchCityName(double lat, double lon) async {
    final url = '$reverseGeocodeUrl?key=$apiKey&q=$lat,$lon';

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data['location']['name']; // Extract city name
      } else {
        throw Exception('Failed to load city name');
      }
    } catch (e) {
      throw Exception('Failed to load city name: $e');
    }
  }
}
