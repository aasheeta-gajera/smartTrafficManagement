import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/Home.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          //4D233E
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF672E50),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF3B6237),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/emergency_events': (context) => const EmergencyEventsScreen(),
        '/status': (context) => const StatusScreen(),
        '/switch_events': (context) => const SwitchEventsScreen(),
        '/traffic_logs': (context) => const TrafficLogsScreen(),
      },
    );
  }
}