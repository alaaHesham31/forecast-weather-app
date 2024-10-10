import 'package:flutter/material.dart';

class TemperatureUnitDialog extends StatelessWidget {
  final String selectedUnit;
  final ValueChanged<String> onUnitChanged;

  const TemperatureUnitDialog({
    super.key,
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon:
          const Icon(Icons.thermostat_outlined, color: Colors.white, size: 32),
      title: const Column(
        children: [
          Center(
              child: Text('Temperature Unit',
                  style: TextStyle(color: Colors.white, fontSize: 24))),
          SizedBox(height: 8),
          Text(
              'Changing this setting will update across all of your account settings.',
              style: TextStyle(color: Color.fromARGB(255, 220, 218, 218), fontSize: 16)),
        ],
      ),
      backgroundColor: Colors.grey[900],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RadioListTile<String>(
            title: const Text('Celsius',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            value: 'Celsius',
            groupValue: selectedUnit,
            onChanged: (String? value) {
              if (value != null) {
                onUnitChanged(value);
                Navigator.of(context).pop(); // Close dialog
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('Fahrenheit',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            value: 'Fahrenheit',
            groupValue: selectedUnit,
            onChanged: (String? value) {
              if (value != null) {
                onUnitChanged(value);
                Navigator.of(context).pop(); // Close dialog
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {},
          child: Text('Ok'),
        )
      ],
    );
  }
}



