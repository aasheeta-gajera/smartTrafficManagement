import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smarttrafficmanagement/screens/Home.dart';
import 'screens/emergency_events_screen.dart';
import 'screens/status_screen.dart';
import 'screens/switch_events_screen.dart';
import 'screens/traffic_logs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmerGoFlow - Traffic Management',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/emergency_events': (context) => EmergencyEventsScreen(),
        '/status': (context) => StatusScreen(),
        '/switch_events': (context) => SwitchEventsScreen(),
        '/traffic_logs': (context) => TrafficLogsScreen(),
      },
    );
  }
}
