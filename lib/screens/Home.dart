import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget buildCard(BuildContext context, String title, String route) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmerGoFlow - Dashboard'),
      ),
      body: ListView(
        children: [
          buildCard(context, 'Emergency Events', '/emergency_events'),
          buildCard(context, 'Status', '/status'),
          buildCard(context, 'Switch Events', '/switch_events'),
          buildCard(context, 'Traffic Logs', '/traffic_logs'),
        ],
      ),
    );
  }
}
