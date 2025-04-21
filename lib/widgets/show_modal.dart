import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_app/widgets/provider.dart';

void showCustomBottomSheet(BuildContext context, String deviceId) {
  // Get device data and toggle state
  final toggleProvider = Provider.of<ToggleProvider>(context, listen: false);
  final device = toggleProvider.devices.firstWhere((d) => d['id'] == deviceId);
  // final toggleState = Provider.of<ToggleProvider>(context, listen: false).getStateById(deviceId);
  final screenHeight = MediaQuery.of(context).size.height;

  // Define device-specific modes
  final Map<String, List<String>> deviceModes = {
    '1': ['COLD', 'FAN', 'DRY'], // Air conditioner
    '2': ['LOW', 'WARM', 'HIGH'], // Smart TV
    '3': ['DIM', 'BRIGHT', 'AUTO'], // Main lamp
    '4': ['DIM', 'BRIGHT', 'AUTO'], // Desk lamp
  };

  // Get modes for the current device, default to generic modes if not found
  final List<String> modes =
      deviceModes[deviceId] ?? ['MODE1', 'MODE2', 'MODE3'];
  String selectedMode = modes[0]; // Default to first mode

  showModalBottomSheet(
    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Get device and toggle state from provider
          final device = Provider.of<ToggleProvider>(context, listen: false)
              .getDeviceById(deviceId);

          // Determine slider range and initial value based on device
          double minValue;
          double maxValue;
          String displayValue;
          double temperature;

          if (deviceId == '1') {
            // Air conditioner: Temperature in °C
            minValue = 16.0;
            maxValue = 32.0;
            displayValue = device['value'] ?? '21°C';
            temperature =
                double.tryParse(displayValue.replaceAll('°C', '')) ?? 21.0;
          } else {
            // Other devices (Smart TV, Main lamp, Desk lamp): Percentage
            minValue = 0.0;
            maxValue = 100.0;
            displayValue = device['value'] ?? '50%';
            temperature =
                double.tryParse(displayValue.replaceAll('%', '')) ?? 50.0;
          }

          return Container(
            height: screenHeight * 0.75,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Device name and toggle switch
                Text(
                  '${device['brand']}', // Static brand name, adjust if dynamic
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${device['title']}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<ToggleProvider>(
                      builder: (context, toggleProvider, child) {
                        final toggleState =
                            toggleProvider.getStateById(deviceId);
                        return Switch(
                          activeColor: Colors.white,
                          activeTrackColor: Colors.black,
                          value: toggleState.isSwitchOn,
                          onChanged: (value) {
                            toggleProvider.toggleDevice(deviceId);
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Dynamic mode selection buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: modes
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _buildModeButton(
                            label: entry.value,
                            isSelected: selectedMode == entry.value,
                            onPressed: () {
                              setState(() {
                                selectedMode = entry.value;
                              });
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                // Temperature/Percentage dial
                Center(
                  child: SleekCircularSlider(
                    min: minValue,
                    max: maxValue,
                    initialValue: temperature,
                    appearance: CircularSliderAppearance(
                      size: 240,
                      startAngle: 180,
                      angleRange: 180,
                      customColors: CustomSliderColors(
                        trackColor: Colors.white,
                        progressBarColors: [Colors.blue, Colors.red],
                        dotColor: Colors.white,
                      ),
                      customWidths: CustomSliderWidths(
                        trackWidth: 10,
                        progressBarWidth: 10,
                        handlerSize: 3,
                      ),
                      infoProperties: InfoProperties(
                        mainLabelStyle: const TextStyle(
                          fontSize: 0, // Hide default label
                        ),
                      ),
                    ),
                    innerWidget: (double value) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 250, 250, 250),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 250, 250, 250),
                            gradient: RadialGradient(
                              colors: [
                                Color.fromARGB(255, 250, 250, 250), // Lighter center
                                Color.fromARGB(255, 220, 220, 220), // Slightly darker edge
                              ],
                              center: Alignment.center,
                              radius: 3,
                            ), // Simulate inner shadow with a subtle gradient
                            // boxShadow: [
                            //   // Outer shadow all around
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.5),
                            //     offset: const Offset(0, 0), // No offset to spread evenly
                            //     blurRadius: 8,
                            //     spreadRadius: 2,
                            //   ),
                            //   // Inner shadow simulation
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.3),
                            //     offset: const Offset(0, 0),
                            //     blurRadius: 4,
                            //     spreadRadius: -2, // Negative spread to simulate inner shadow
                            //   ),
                            // ],
                          ),
                          child: Center(
                            child: Text(
                              deviceId == '1'
                                  ? '${value.round()}°C'
                                  : '${value.round()}%',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onChange: (double value) {
                      setState(() {
                        temperature = value;
                        // Update provider with new value
                        final newValue = deviceId == '1'
                            ? '${value.round()}°C'
                            : '${value.round()}%';
                        Provider.of<ToggleProvider>(context, listen: false)
                            .updateDeviceValue(deviceId, newValue);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Adjustment buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Left group: MIN overlapping with -
                    SizedBox(
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          _buildAdjustmentButton(
                            label: '-',
                            color: Colors.grey.shade800,
                            onTap: () {
                              setState(() {
                                if (temperature > minValue) temperature -= 1;
                                // Update provider with new value
                                final newValue = deviceId == '1'
                                    ? '${temperature.round()}°C'
                                    : '${temperature.round()}%';
                                Provider.of<ToggleProvider>(context,
                                        listen: false)
                                    .updateDeviceValue(deviceId, newValue);
                              });
                            },
                          ),
                          Positioned(
                            left: 0,
                            child: _buildAdjustmentButton2(
                              label: 'MIN',
                              color: const Color.fromARGB(255, 218, 136, 254),
                              onTap: () {
                                setState(() {
                                  temperature = minValue;
                                  // Update provider with new value
                                  final newValue = deviceId == '1'
                                      ? '${minValue.round()}°C'
                                      : '${minValue.round()}%';
                                  Provider.of<ToggleProvider>(context,
                                          listen: false)
                                      .updateDeviceValue(deviceId, newValue);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right group: + overlapping with MAX
                    SizedBox(
                      width: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          _buildAdjustmentButton(
                            label: '+',
                            color: Colors.grey.shade800,
                            onTap: () {
                              setState(() {
                                if (temperature < maxValue) temperature += 1;
                                // Update provider with new value
                                final newValue = deviceId == '1'
                                    ? '${temperature.round()}°C'
                                    : '${temperature.round()}%';
                                Provider.of<ToggleProvider>(context,
                                        listen: false)
                                    .updateDeviceValue(deviceId, newValue);
                              });
                            },
                          ),
                          Positioned(
                            right: 0,
                            child: _buildAdjustmentButton2(
                              label: 'MAX',
                              color: const Color.fromARGB(255, 255, 150, 160),
                              onTap: () {
                                setState(() {
                                  temperature = maxValue;
                                  // Update provider with new value
                                  final newValue = deviceId == '1'
                                      ? '${maxValue.round()}°C'
                                      : '${maxValue.round()}%';
                                  Provider.of<ToggleProvider>(context,
                                          listen: false)
                                      .updateDeviceValue(deviceId, newValue);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildModeButton({
  required String label,
  required bool isSelected,
  required VoidCallback onPressed,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 16,
        color: isSelected ? Colors.black : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}

Widget _buildAdjustmentButton2({
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

Widget _buildAdjustmentButton({
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
