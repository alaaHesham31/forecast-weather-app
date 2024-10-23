import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SunsetWidget extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const SunsetWidget({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    String sunsetTimeString = weatherData?['forecast']['forecastday'][0]['astro']['sunset'] ?? 'Unknown';

    // Function to calculate hours left until sunset
    String calculateHoursLeftUntilSunset(String sunsetTimeString) {
      if (sunsetTimeString == 'Unknown') return 'Unknown';

      try {
        // Parse the sunset time from the string (e.g., '06:45 PM')
        DateFormat format = DateFormat('h:mm a');  // Correct 12-hour format
        DateTime sunsetTime = format.parse(sunsetTimeString);

        // Get the current time
        DateTime now = DateTime.now();

        // Create a DateTime object for today’s sunset
        DateTime todaySunset = DateTime(now.year, now.month, now.day, sunsetTime.hour, sunsetTime.minute);

        // If the sunset time is before now (meaning it's tomorrow's sunset), add a day
        if (todaySunset.isBefore(now)) {
          todaySunset = todaySunset.add(Duration(days: 1));
        }

        // Calculate the difference in hours and minutes between now and sunset
        Duration difference = todaySunset.difference(now);
        int hoursLeft = difference.inHours;

        return '$hoursLeft hours left';
      } catch (e) {
        // Handle any errors in parsing
        return 'Could not calculate time';
      }
    }

    String hoursLeftUntilSunset = calculateHoursLeftUntilSunset(sunsetTimeString);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          height: 100,
          width: 340,
          decoration: BoxDecoration(
            color: Color(0xFF3CCF3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white, // Border color
              width: 1.0, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/sunset.png'))),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sunset',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(height: 4,),
                          Text(
                            sunsetTimeString,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  hoursLeftUntilSunset, // Display the time difference
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
