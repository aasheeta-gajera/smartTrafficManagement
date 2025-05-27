import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EmergencyEventsScreen extends StatelessWidget {
  const EmergencyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseReference eventsRef =
    FirebaseDatabase.instance.ref().child('emergency_events');

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Events')),
      body: StreamBuilder<DatabaseEvent>(
        stream: eventsRef.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No emergency events found'));
          }

          final dataMap = Map<dynamic, dynamic>.from(
              snapshot.data!.snapshot.value as Map);
          final entries = dataMap.entries.toList().reversed.toList();

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final item = Map<String, dynamic>.from(entries[index].value);
              final uid = item['uid'] ?? 'Unknown UID';
              final timestamp = item['timestamp'] ?? 'Unknown';

              return ListTile(
                leading: const Icon(Icons.warning, color: Colors.red),
                title: Text('UID: $uid'),
                subtitle: Text('Timestamp: $timestamp'),
              );
            },
          );
        },
      ),
    );
  }
}
