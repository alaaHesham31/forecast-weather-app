import 'package:demo_weather_app/services/temperature_unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowModal extends StatefulWidget {
  const ShowModal({super.key});

  @override
  State<ShowModal> createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  String _selectedUnit = 'Celsius'; // Default temperature unit
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
                      height: 280,
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
                                      radius: 24,
                                      backgroundImage: AssetImage(
                                          'assets/images/user-avatar.png'),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Joe Doe',
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
                  ],
                );
              },
            );
          },
        );
      },
     child: Stack(
  alignment: Alignment.center, // Align children to the center
  children: [
    const CircleAvatar(
      radius: 20,
    ),
    Container(
      padding: const EdgeInsets.all(4),
      child: const Icon(
        Icons.notifications, // Notification icon
        size: 24,            // Size of the icon
        color: Color.fromARGB(255, 42, 35, 35),  // Icon color
      ),
    ),
  ],
)


    );
  }

  void _showTemperatureUnitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.thermostat_outlined,
              color: Colors.white, size: 32),
          title: const Column(
            children: [
              Center(
                  child: Text('Temperature Unit',
                      style: TextStyle(color: Colors.white, fontSize: 24))),
              SizedBox(height: 8),
              Text(
                  'Changing this setting will update across all of your account settings.',
                  style: TextStyle(
                      color: Color.fromARGB(255, 220, 218, 218), fontSize: 16)),
            ],
          ),
          backgroundColor: Color(0xFFBA90C6),
          content: Consumer<TemperatureUnitProvider>(
            builder: (context, tempUnitProvider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text(
                      'Celsius',
                      style: TextStyle(color: Colors.white),
                    ),
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
                    title: const Text(
                      'Fahrenheit',
                      style: TextStyle(color: Colors.white),
                    ),
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