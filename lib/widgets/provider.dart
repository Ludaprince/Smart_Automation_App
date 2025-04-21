import 'package:flutter/material.dart';

class ToggleState {
  final String id;
  bool isSwitchOn;
  String status;

  ToggleState({
    required this.id,
    required this.isSwitchOn,
    required this.status,
  });
}

class ToggleProvider extends ChangeNotifier {
  final List<ToggleState> _toggleStates = [
    ToggleState(id: '1', isSwitchOn: true, status: 'ON'),
    ToggleState(id: '2', isSwitchOn: false, status: 'OFF'),
    ToggleState(id: '3', isSwitchOn: false, status: 'OFF'),
    ToggleState(id: '4', isSwitchOn: true, status: 'ON'),
  ];

  // Store device data
  final List<Map<String, dynamic>> _devices = [
    {
      'id': '1',
      'icon': Icons.ac_unit,
      'title': 'Air conditioner',
      'subtitle': 'Temperature',
      'value': '18°C',
      'brand': 'LG XBA-32',
    },
    {
      'id': '2',
      'icon': Icons.tv,
      'title': 'Smart TV',
      'value': '50%', // Default value for Smart TV
      'brand': 'Samsung QLED',
      'subtitle': 'Volume',
    },
    {
      'id': '3',
      'icon': Icons.lightbulb,
      'title': 'Main lamp',
      'subtitle': 'Brightness',
      'value': '26%',
      'brand': 'Philips Hue',
    },
    {
      'id': '4',
      'icon': Icons.light,
      'title': 'Desk lamp',
      'subtitle': 'Brightness',
      'value': '78%',
      'brand': 'Xiaomi Mi',
    },
  ];

  List<ToggleState> get toggleStates => _toggleStates;
  List<Map<String, dynamic>> get devices => _devices;

  void toggleDevice(String id) {
    final index = _toggleStates.indexWhere((state) => state.id == id);
    if (index != -1) {
      _toggleStates[index].isSwitchOn = !_toggleStates[index].isSwitchOn;
      _toggleStates[index].status = _toggleStates[index].isSwitchOn ? 'ON' : 'OFF';
      notifyListeners();
    }
  }

  void updateDeviceValue(String id, String value) {
    final index = _devices.indexWhere((device) => device['id'] == id);
    if (index != -1) {
      _devices[index]['value'] = value;
      notifyListeners();
    }
  }

  ToggleState getStateById(String id) {
    return _toggleStates.firstWhere((state) => state.id == id);
  }

  Map<String, dynamic> getDeviceById(String id) {
    return _devices.firstWhere((device) => device['id'] == id);
  }
}