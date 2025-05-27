import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference statusRef =
    FirebaseDatabase.instance.ref().child('status');

    return Scaffold(
      appBar: AppBar(title: const Text('Status')),
      body: StreamBuilder<DatabaseEvent>(
        stream: statusRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No status record found'));
          }

          final statusData = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map);

          final emergencyUid = statusData['emergency_uid'] ?? 'Unknown';
          final emergencyActive = statusData['emergency_vehicle_active'] ?? false;

          return Center(
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.all(16),
              child: ListTile(
                leading: Icon(
                  emergencyActive ? Icons.directions_car : Icons.car_rental_outlined,
                  color: emergencyActive ? Colors.green : Colors.grey,
                ),
                title: Text('Emergency UID: $emergencyUid'),
                subtitle: Text('Vehicle Active: $emergencyActive'),
              ),
            ),
          );
        },
      ),
    );
  }
}
