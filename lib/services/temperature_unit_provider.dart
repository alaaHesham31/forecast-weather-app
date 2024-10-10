import 'package:flutter/material.dart';

class TemperatureUnitProvider extends ChangeNotifier {
  String _selectedUnit = 'Celsius'; // Default is Celsius

  String get selectedUnit => _selectedUnit;

  void setUnit(String newUnit) {
    _selectedUnit = newUnit;
    notifyListeners(); // Notify widgets to rebuild with new value
  }

  // Function to convert temperature based on selected unit and round the value
  int convertTemperature(double tempInCelsius) {
    if (_selectedUnit == 'Fahrenheit') {
      return ((tempInCelsius * 9 / 5) + 32).round(); // Rounds and returns as int
    }
    return tempInCelsius.round(); // Rounds and returns as int for Celsius
  }
}
