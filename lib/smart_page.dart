import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:smart_app/widgets/provider.dart';
import 'package:smart_app/widgets/show_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  // Handle card tap
  void onDeviceCardTap(String deviceId) {
    showCustomBottomSheet(context, deviceId);
  }

  // Build device card
  Widget _buildDeviceCard(
    Map<String, dynamic> device,
    BuildContext context, {
    Function(String)? onTap,
  }) {
    final toggleState = context.watch<ToggleProvider>().getStateById(device['id']);
    return InkWell(
      onTap: onTap != null ? () => onTap(device['id']) : null,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: toggleState.isSwitchOn ? Colors.grey[100] : Colors.white,
          border: Border.all(color: const Color.fromARGB(96, 90, 89, 89)),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(device['icon'], size: 32, color: Colors.black),
            const SizedBox(height: 16),
            Text(
              device['title'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (device['subtitle'] != null)
              Text(
                device['subtitle'],
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (device['value'] != null)
              Text(
                device['value'],
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  toggleState.status,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  activeColor: Colors.white,
                  activeTrackColor: Colors.black,
                  value: toggleState.isSwitchOn,
                  onChanged: (value) {
                    context.read<ToggleProvider>().toggleDevice(device['id']);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Extracted home tab content for reusability
  Widget _buildHomeTabContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: const Icon(CupertinoIcons.chevron_down),
                  label: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(57, 57, 57, 1),
                        ),
                        children: [
                          TextSpan(
                            text: "MY GARDEN HOUSE",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(57, 57, 57, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: " (6 DEVICES)",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white30,
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(57, 57, 57, 1)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const Text(
              "Good Morning,",
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 131, 116, 116),
                fontWeight: FontWeight.normal,
              ),
            ),
            const Text(
              "Denzel",
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 250, 81, 39),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Summary for today",
                          style: TextStyle(color: Colors.white),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            // shadowColor: const Color.fromARGB(255, 8, 2, 0),
                            backgroundColor:const Color.fromARGB(255, 248, 123, 66),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "CHECK STATS",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "9.4",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 253, 230, 230),
                                  fontSize: 25,
                                ),
                              ),
                              TextSpan(
                                text: " kwh",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 194, 192, 192),
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 50),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "\$24.6",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 253, 230, 230),
                                  fontSize: 25,
                                ),
                              ),
                              TextSpan(
                                text: "  12%",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 194, 192, 192),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "OFFICE",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text("LIVING ROOM")),
                TextButton(onPressed: () {}, child: const Text("KITCHEN")),
                TextButton(onPressed: () {}, child: const Text("BEDROOM")),
              ],
            ),
            const SizedBox(height: 10),
            Consumer<ToggleProvider>(
              builder: (context, toggleProvider, child) {
                final devices = toggleProvider.devices;
                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  itemCount: devices.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _buildDeviceCard(
                      devices[index],
                      context,
                      onTap: onDeviceCardTap,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              TabBarView(
                controller: tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildHomeTabContent(), // Home tab content
                  const Center(child: Text('Tab 2 Content')),
                  const Center(child: Text('Tab 3 Content')),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 65,
                  margin: const EdgeInsets.only(
                    left: 70,
                    right: 70,
                    bottom: 30,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 33, 31, 31),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: tabController,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                    tabs: const [
                      Tab(
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 147, 146, 146),
                          child: Icon(
                            Icons.home,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Tab(
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 230, 80, 11),
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Tab(
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 147, 146, 146),
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}