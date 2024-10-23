import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date and time formatting

class SunriseWidget extends StatelessWidget {
  final Map<String, dynamic>? weatherData;

  const SunriseWidget({super.key, this.weatherData});

  @override
  Widget build(BuildContext context) {
    String sunriseTimeString = weatherData?['forecast']['forecastday'][0]['astro']['sunrise'] ?? 'Unknown';

    // Function to calculate hours left until sunrise
    String calculateHoursLeft(String sunriseTimeString) {
      if (sunriseTimeString == 'Unknown') return 'Unknown';

      try {
        // Parse the sunrise time from the string (e.g., '05:58 AM')
        DateFormat format = DateFormat('h:mm a');  // Correct 12-hour format
        DateTime sunriseTime = format.parse(sunriseTimeString);

        // Get the current time
        DateTime now = DateTime.now();

        // Create a DateTime object for today’s sunrise
        DateTime todaySunrise = DateTime(now.year, now.month, now.day, sunriseTime.hour, sunriseTime.minute);

        // If the sunrise time is before now (meaning it's tomorrow's sunrise), add a day
        if (todaySunrise.isBefore(now)) {
          todaySunrise = todaySunrise.add(Duration(days: 1));
        }

        // Calculate the difference in hours and minutes between now and sunrise
        Duration difference = todaySunrise.difference(now);
        int hoursLeft = difference.inHours;

        return '$hoursLeft hours left';
      } catch (e) {
        // Handle any errors in parsing
        return 'Could not calculate time';
      }
    }

    String hoursLeftUntilSunrise = calculateHoursLeft(sunriseTimeString);

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
                              image: AssetImage('assets/images/sunrise.png'))),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sunrise',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            sunriseTimeString,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  hoursLeftUntilSunrise, // Display the time difference
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
