import 'package:demo_weather_app/widgets/current_waether_condition.dart';
import 'package:demo_weather_app/widgets/forecast_widget.dart';
import 'package:demo_weather_app/widgets/search_bar_widget.dart';
import 'package:demo_weather_app/widgets/sunrise_widget.dart';
import 'package:demo_weather_app/widgets/sunset_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String cityName;
  const HomeScreen({Key? key, required this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity, // Ensure the container takes full height
          width: double.infinity, // Ensure the container takes full width
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
            // Wrap the Column in SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0), // Add some padding
                  child: SearchBarWidget(cityName: '$cityName'),
                ),
                // You can add more widgets below this to expand the content
                const Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Current Conditions',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const CurrentWaetherCondition(),
                const Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 15),
                  child: Text(
                    'Sunrise & Sunset',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SunriseWidget(),
                const SunsetWidget(),

                const Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 15),
                  child: Text(
                    '7-day forecast',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const ForecastWidget(),
                const ForecastWidget(),
                const ForecastWidget(),
                const ForecastWidget(),
                const ForecastWidget(),
                const ForecastWidget(),
                const ForecastWidget(),


                SizedBox(
                  height: 100,
                ) // You can add more content
              ],
            ),
          ),
        ),
      ),
    );
  }
}
