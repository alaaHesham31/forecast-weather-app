import 'package:demo_weather_app/widgets/weather_for_search_page.dart'; 
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final String cityName;

  const SearchPage({Key? key, required this.cityName}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _cities = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Sharm El Sheikh',
    'Luxor',
    'Aswan',
    'Hurghada',
    'Port Said',
    'Suez',
    'Mansoura',
    'Ismailia',
    'Tanta',
    'Damanhur',
    'Faiyum',
    'Minya',
    'Beni Suef',
    'Qena',
    'Sohag',
    'Cairo Governorate',
    'Giza Governorate',
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities; // Initialize with all cities
  }

  void _onTextChanged(String text) {
    setState(() {
      _filteredCities = _cities
          .where((city) => city.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  void _onSearch() {
    String query = _searchController.text;
    if (query.isNotEmpty) {
      print('Searching for: $query');
      // You can implement additional search logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Space at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _onTextChanged,
                      onSubmitted: (value) => _onSearch(),
                      decoration: InputDecoration(
                        hintText: 'Search for a location',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Show WeatherForSearchPage if the text field is empty
            _searchController.text.isEmpty
                ? WeatherForSearchPage(cityName: widget.cityName) // Ensure this widget is correctly defined
                : Expanded(
                    child: ListView.builder(
                      itemCount: _filteredCities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on_outlined, color: Colors.white),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _filteredCities[index],
                                style: const TextStyle(color: Colors.white, fontSize: 22),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  print('Selected city: ${_filteredCities[index]}');
                                },
                                child: const Text('Search', style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
