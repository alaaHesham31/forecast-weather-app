import 'package:demo_weather_app/widgets/show_modal.dart';
import 'package:flutter/material.dart';
import '../screens/search_page.dart'; // Assuming you have this file already

class SearchBarWidget extends StatelessWidget {
  final String cityName;
  const SearchBarWidget({Key? key, required this.cityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When the search bar is tapped, navigate to the search page
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) =>  SearchPage(cityName: '$cityName')),
        );
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
                cityName,
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
