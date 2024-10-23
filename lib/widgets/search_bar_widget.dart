import 'package:demo_weather_app/widgets/show_modal.dart';
import 'package:flutter/material.dart';
import '../screens/search_page.dart'; // Assuming you have this file already

class SearchBarWidget extends StatelessWidget {
  final String cityName;
  final Function(String) onCitySelected; // Callback function to handle selected city

  const SearchBarWidget({Key? key, required this.cityName, required this.onCitySelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigate to the SearchPage and wait for the selected city
        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SearchPage(cityName: cityName)),
        );

        if (result != null && result is Map<String, dynamic>) {
          final selectedCity = result['city'];
          onCitySelected(selectedCity); // Pass the selected city back to the HomeScreen
        }
      },
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF3CCF3), // Search bar background color
          borderRadius: BorderRadius.circular(30), // Rounded corners
          border: Border.all(
            color: Colors.white, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.white),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                cityName.isEmpty ? 'Select a city' : cityName, // Display selected city name
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const ShowModal(), // Moved the modal widget here
          ],
        ),
      ),
    );
  }
}
