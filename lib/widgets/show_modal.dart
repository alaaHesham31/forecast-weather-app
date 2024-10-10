import 'package:demo_weather_app/services/temperature_unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'temperature_unit_dialog.dart'; // Import the temperature dialog widget

class ShowModal extends StatefulWidget {
  const ShowModal({super.key});

  @override
  State<ShowModal> createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  String _selectedUnit = 'Celsius'; // Default temperature unit
  int _notificationCount = 5; // Example notification count
    bool _isLoading = false; // Loading indicator


 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show the modal when the CircleAvatar is tapped
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background Container for the modal
                    Container(
                      height: 700,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1A2344).withOpacity(0.9),
                            Color.fromARGB(255, 125, 32, 142).withOpacity(0.8),
                            Colors.purple.withOpacity(0.8),
                            Color.fromARGB(255, 151, 44, 170).withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Settings",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  50), // Space for the overlapping container
                        ],
                      ),
                    ),
                    // Overlapping smaller container
                    Positioned(
                      top: 70, // Adjust this value to control the overlap
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 160,
                        decoration: BoxDecoration(
                          color: Color(0xFFBA90C6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User profile details
                            const Row(
                              children: [
                                Stack(
                                  children: [
                                    const CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          AssetImage('assets/images/user-avatar.png'),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Alaa Elkeshky',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ],
                            ),
                            //const SizedBox(height: 10),
 // ListTile for selecting temperature units
                            ListTile(
                              leading: const Icon(Icons.thermostat,
                                  color: Colors.white),
                              title: const Text(
                                'Temperature units',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(_selectedUnit,
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                // Show temperature unit selection dialog
                                _showTemperatureUnitDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                   const Positioned(
                      top: 250, // Adjust this value to control the overlap
                      left: 20,
                      right: 20,
                      child: const Text(
                        "Notifications",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 300, // Adjust this value to control the overlap
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height:
                            350, // Adjust the height of the notification container
                        decoration: BoxDecoration(
                          color: Color(0xFFBA90C6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Recent Notifications",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            // Wrap the ListView in Expanded so it can scroll within the available space
                            Expanded(
                              child: Scrollbar(
                                thumbVisibility:
                                    true, // Makes the scrollbar always visible
                                thickness:
                                    6, // Set the thickness of the scrollbar
                                radius: const Radius.circular(
                                    10), // Make the scrollbar curved
                                child: ListView.builder(
                                  itemCount:
                                      10, // Example number of notifications
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(Icons.notifications,
                                          color: Colors.white),
                                      title: Text(
                                        'Notification #$index',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: const Text(
                                        'This is the detail of the notification.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        // Define what happens when a notification is tapped
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/user_avatar.png'),
            
          ),
          if (_notificationCount > 0) // Show badge if notifications exist
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  '$_notificationCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showTemperatureUnitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Temperature Unit"),
          backgroundColor: Color(0xFFBA90C6),
          content: Consumer<TemperatureUnitProvider>(
            builder: (context, tempUnitProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Celsius'),
                    value: 'Celsius',
                    groupValue: tempUnitProvider.selectedUnit,
                    onChanged: (String? value) {
                      if (value != null) {
                      setState(() {
                        tempUnitProvider.setUnit(value); // Update provider
                        _selectedUnit = value; // Update local state
                      });
                    }
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Fahrenheit'),
                    value: 'Fahrenheit',
                    groupValue: tempUnitProvider.selectedUnit,
                    onChanged: (String? value) {
                      if (value != null) {
                      setState(() {
                        tempUnitProvider.setUnit(value); // Update provider
                        _selectedUnit = value; // Update local state
                      });
                    }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Apply temperature unit and show loading
                      tempUnitProvider.setUnit(_selectedUnit);
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Close modal
                      
                      setState(() {
                        _isLoading = true; // Show loading indicator
                      });

                      // Simulate temperature conversion delay
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          _isLoading = false; // Hide loading indicator
                        });
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}