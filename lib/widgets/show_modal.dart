import 'package:demo_weather_app/services/temperature_unit_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'temperature_unit_dialog.dart'; // Import the temperature dialog widget
import 'theme_selection_dialog.dart'; // Import the ThemeSelectionDialog

class ShowModal extends StatefulWidget {
  const ShowModal({super.key});

  @override
  State<ShowModal> createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  String _selectedUnit = 'Celsius'; // Default temperature unit
  int _notificationCount = 5; // Example notification count

  // Define the selected theme variable
  ThemeMode _selectedTheme = ThemeMode.light; // Default is light theme

  void _showThemeSelectionDialog(
      BuildContext context, StateSetter setModalState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ThemeSelectionDialog(
          initialTheme: _selectedTheme, // Pass the current theme
          onThemeChanged: (ThemeMode newTheme) {
            // Set the selected theme and update both the parent widget and modal UI
            setState(() {
              _selectedTheme = newTheme;
            });
            setModalState(() {}); // Rebuild the modal to reflect changes
          },
        );
      },
    );
  }

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
                      height: 750,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1A2344).withOpacity(0.8),
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
                        height: 260,
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
                                    SizedBox(height: 4),
                                    Text(
                                      'alaa.elkeshky33@gmail.com',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

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
                                _showTemperatureUnitDialog(
                                    context);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.brightness_6,
                                  color: Colors.white),
                              title: const Text(
                                'App Theme',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                _selectedTheme == ThemeMode.light
                                    ? 'Light'
                                    : 'Dark',
                                style: const TextStyle(color: Colors.white),
                              ),
                              onTap: () {
                                // Show theme selection dialog
                                _showThemeSelectionDialog(
                                    context, setModalState);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                   const Positioned(
                      top: 350, // Adjust this value to control the overlap
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
                      top: 400, // Adjust this value to control the overlap
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height:
                            300, // Adjust the height of the notification container
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
        title: Text("Select Temperature Unit"),
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
                      tempUnitProvider.setUnit(value);
                      Navigator.pop(context); // Close the dialog
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Fahrenheit'),
                  value: 'Fahrenheit',
                  groupValue: tempUnitProvider.selectedUnit,
                  onChanged: (String? value) {
                    if (value != null) {
                      tempUnitProvider.setUnit(value);
                      Navigator.pop(context); // Close the dialog
                    }
                  },
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