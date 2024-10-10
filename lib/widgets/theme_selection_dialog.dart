import 'package:flutter/material.dart';

class ThemeSelectionDialog extends StatefulWidget {
  final ThemeMode initialTheme; // The initial selected theme
  final ValueChanged<ThemeMode> onThemeChanged; // Callback to update theme

  ThemeSelectionDialog({
    required this.initialTheme,
    required this.onThemeChanged,
  });

  @override
  _ThemeSelectionDialogState createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  ThemeMode? _selectedTheme; // Store the currently selected theme

  @override
  void initState() {
    super.initState();
    // Set the initial theme based on the passed theme from the parent widget
    _selectedTheme = widget.initialTheme;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose App Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Light Theme'),
            value: ThemeMode.light,
            groupValue: _selectedTheme,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedTheme = value; // Update the selected theme
              });
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark Theme'),
            value: ThemeMode.dark,
            groupValue: _selectedTheme,
            onChanged: (ThemeMode? value) {
              setState(() {
                _selectedTheme = value; // Update the selected theme
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without making changes
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Pass the selected theme back to the parent widget
            widget.onThemeChanged(_selectedTheme!);
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
