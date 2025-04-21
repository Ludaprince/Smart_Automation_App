import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_app/smart_page.dart';
import 'package:smart_app/widgets/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ToggleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


