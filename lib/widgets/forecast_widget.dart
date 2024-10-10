import 'package:demo_weather_app/services/temperature_unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForecastWidget extends StatelessWidget {
  final int temperatureCelsius = 14; // Example temperature
  final int highTempCelsius = 23; // Example high temperature
  final int lowTempCelsius = 14; // Example low temperature

  const ForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tempUnitProvider = Provider.of<TemperatureUnitProvider>(context);
    int temperature = tempUnitProvider.convertTemperature(temperatureCelsius.toDouble());
    // Convert both high and low temperatures
    int highTemp = tempUnitProvider.convertTemperature(highTempCelsius.toDouble());
    int lowTemp = tempUnitProvider.convertTemperature(lowTempCelsius.toDouble());

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          height: 110,
          width: 340,
          decoration: BoxDecoration(
            color: const Color(0xFF3CCF3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white, // Border color
              width: 1.0, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Sunday, 9 Oct',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/sunrise.png'))),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$temperature °${tempUnitProvider.selectedUnit == "Celsius" ? "C" : "F"}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text(
                                'partly cloud',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '$highTemp° / $lowTemp°',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )
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
